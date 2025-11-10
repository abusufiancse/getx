// lib/screens/all_products_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/lib/screens/product_detail_screen.dart';
import '../controllers/product_controller.dart.dart';
import '../widgets/shimmer_loading.dart';

class AllProductsScreen extends StatelessWidget {
  AllProductsScreen({Key? key}) : super(key: key);

  final ProductController productController = Get.put(ProductController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    // Setup scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
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
      body: Obx(() {
        if (productController.products.isEmpty && productController.isLoading.value) {
          return const ProductShimmer();
        }

        if (productController.errorMessage.isNotEmpty) {
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
              if (productController.isLoading.value)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
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
    );
  }
}