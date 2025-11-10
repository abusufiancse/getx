// lib/screens/all_products_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/lib/screens/product_detail_screen.dart';
import '../controllers/product_controller.dart.dart';
import '../widgets/shimmer_loading.dart';
import 'package:shimmer/shimmer.dart';

class AllProductsScreen extends StatelessWidget {
  AllProductsScreen({super.key});

  final ProductController productController = Get.put(ProductController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Setup scroll listener for pagination
    scrollController.addListener(() {
      // Trigger fetch when user is near the bottom of the list
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        productController.fetchProducts();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              productController.refreshProducts();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // --- Categories Row ---
          _buildCategoriesRow(),
          const Divider(height: 1),

          // --- Product List ---
          Expanded(
            child: Obx(() {
              // Show shimmer on initial load of products
              if (productController.products.isEmpty && productController.isLoading.value) {
                return const ProductShimmer();
              }

              // Show error message if products failed to load
              if (productController.errorMessage.isNotEmpty && productController.products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${productController.errorMessage.value}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          productController.refreshProducts();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Show product list with pull-to-refresh
              return RefreshIndicator(
                onRefresh: () async {
                  await productController.refreshProducts();
                },
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: productController.products.length,
                        itemBuilder: (context, index) {
                          return ProductCard(
                            product: productController.products[index],
                          );
                        },
                      ),
                    ),
                    // Show loading indicator at the bottom while fetching more pages
                    if (productController.isLoading.value)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    // Show message when all products have been loaded
                    if (!productController.hasMore.value && productController.products.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No more products',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// Builds the horizontal scrollable row of category chips.
  /// This implementation uses a Row for more reliable state updates.
  Widget _buildCategoriesRow() {
    return Obx(() {
      // Show shimmer while categories are being loaded for the first time
      if (productController.isCategoriesLoading.value) {
        return _buildCategoryShimmerList();
      }

      // Create a list that includes "All" at the beginning
      final allCategories = ['All', ...productController.categories];

      return SizedBox(
        height: 60,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: allCategories.map((category) {
              // The controller's state is an empty string for "All"
              final categoryState = category == 'All' ? '' : category;
              final isSelected = productController.selectedCategory.value == categoryState;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                // Using a unique key is still best practice
                child: _buildCategoryChip(category, isSelected),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  /// Builds a single, tappable category chip.
  Widget _buildCategoryChip(String category, bool isSelected) {
    return ChoiceChip(
      // KEY FIX: Add a unique key for each chip to ensure Flutter can track its state.
      key: ValueKey(category),
      label: Text(category),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          // Pass an empty string for "All" to match the controller's logic
          productController.selectCategory(category == 'All' ? '' : category);
        }
      },
      pressElevation: 4,
      backgroundColor: Colors.grey[200],
      selectedColor: Colors.blue.shade100,
      labelStyle: TextStyle(
        color: isSelected ? Colors.blue.shade800 : Colors.black,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  /// Builds a shimmering placeholder for the category row.
  Widget _buildCategoryShimmerList() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        itemCount: 8, // Placeholder shimmer count
        itemBuilder: (context, index) => _buildCategoryShimmer(),
      ),
    );
  }

  /// Builds a single shimmering placeholder for a category chip.
  Widget _buildCategoryShimmer() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: 80,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}