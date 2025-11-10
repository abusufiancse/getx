// lib/controllers/product_controller.dart
import 'package:get/get.dart';
import '../core/network/network_caller.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  // --- Product List State ---
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;

  // --- Category State ---
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = ''.obs; // Empty string means "All"
  final RxBool isCategoriesLoading = true.obs;

  int _currentPage = 0;
  final int _limit = 10; // Number of products per page

  @override
  void onInit() {
    super.onInit();
    // Fetch initial data to populate categories and the first page of products
    _fetchInitialData();
  }

  /// Fetches the first page of products and a larger set to extract all categories.
  Future<void> _fetchInitialData() async {
    isCategoriesLoading.value = true;
    // Fetch a larger set initially to get as many categories as possible
    final response = await _networkCaller.request(
      method: 'GET',
      url: 'https://dummyjson.com/products?limit=100',
    );

    if (response.isSuccess) {
      final productResponse = ProductResponse.fromJson(response.responseData);

      // Extract unique categories from the fetched products
      _extractCategories(productResponse.products);

      // Display only the first page of products
      products.assignAll(productResponse.products.take(_limit));
      _currentPage = 1;
      hasMore.value = productResponse.products.length > _limit;
    } else {
      errorMessage.value = response.errorMessage;
    }
    isCategoriesLoading.value = false;
  }

  /// Extracts unique categories from a list of products and updates the state.
  void _extractCategories(List<Product> productList) {
    final uniqueCategories = productList.map((p) => p.category).toSet().toList();
    uniqueCategories.sort(); // Sort categories alphabetically for a clean UI
    categories.assignAll(uniqueCategories);
  }

  /// Fetches products from the API, handling both "All" and category-specific views.
  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      // Reset pagination and clear the list for a fresh start
      _currentPage = 0;
      products.clear();
      hasMore.value = true;
    }

    // Prevent multiple simultaneous requests or fetching if no more data is available
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    // Construct URL based on the selected category
    String url;
    if (selectedCategory.value.isEmpty) {
      // URL for all products
      url = 'https://dummyjson.com/products?limit=$_limit&skip=${_currentPage * _limit}';
    } else {
      // URL for a specific category
      url = 'https://dummyjson.com/products/category/${selectedCategory.value}?limit=$_limit&skip=${_currentPage * _limit}';
    }

    try {
      final response = await _networkCaller.request(method: 'GET', url: url);

      if (response.isSuccess) {
        final productResponse = ProductResponse.fromJson(response.responseData);

        if (isRefresh) {
          products.assignAll(productResponse.products);
        } else {
          products.addAll(productResponse.products);
        }

        _currentPage++;
        // If the number of products returned is less than the limit, we've reached the end
        hasMore.value = productResponse.products.length == _limit;
      } else {
        errorMessage.value = response.errorMessage;
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch products: $e';
    } finally {
      isLoading.value = false;
    }
  }

  /// Sets the selected category and refreshes the product list.
  /// Pass an empty string to show all products.
  void selectCategory(String category) {
    // Always update and refresh to provide clear user feedback, even if re-selecting.
    selectedCategory.value = category;
    fetchProducts(isRefresh: true);
  }

  Future<void> refreshProducts() async {
    await fetchProducts(isRefresh: true);
  }

  Product? getProductById(int id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}