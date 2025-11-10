// lib/utils/app_routes.dart
import 'package:get/get.dart';
import '../../screens/all_products_screen.dart';

class AppRoutes {
  static const String allProducts = '/all-products';
  static const String productDetail = '/product-detail';

  static List<GetPage> routes = [
    GetPage(
      name: allProducts,
      page: () => AllProductsScreen(),
    ),
  ];
}