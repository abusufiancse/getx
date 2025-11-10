// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'lib/core/utils/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Product App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: AppRoutes.allProducts,
      getPages: AppRoutes.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}