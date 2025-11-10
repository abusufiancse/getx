// lib/controllers/product_controller.dart
import 'package:get/get.dart';
import '../core/network/network_caller.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final NetworkCaller _networkCaller = NetworkCaller();

  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMore = true.obs;
  final RxString errorMessage = ''.obs;

  int _currentPage = 0;
  final int _limit = 10;
  final int _totalProducts = 0;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 0;
      products.clear();
      hasMore.value = true;
    }

    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await _networkCaller.request(
        method: 'GET',
        url: 'https://dummyjson.com/products?limit=$_limit&skip=${_currentPage * _limit}',
      );

      if (response.isSuccess) {
        final productResponse = ProductResponse.fromJson(response.responseData);

        if (isRefresh) {
          products.assignAll(productResponse.products);
        } else {
          products.addAll(productResponse.products);
        }

        _currentPage++;
        hasMore.value = products.length < productResponse.total;
      } else {
        errorMessage.value = response.errorMessage;
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch products: $e';
    } finally {
      isLoading.value = false;
    }
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