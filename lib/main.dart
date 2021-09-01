import 'dart:convert';

import 'package:ecom_sample/AstroEcom/astro_ecom.dart';
import 'package:ecom_sample/AstroEcom/orderController.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AstroEcom/productController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(ProductController());
  Get.put(OrderController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: AstroEcom(),
    );
  }
}
