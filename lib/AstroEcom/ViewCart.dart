import 'dart:ui';

import 'package:ecom_sample/AstroEcom/CartEdit.dart';
import 'package:ecom_sample/AstroEcom/OrderDetails.dart';
import 'package:ecom_sample/AstroEcom/productController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'dart:convert';

// ignore: must_be_immutable
class ViewCart extends StatelessWidget {
  ProductController _productController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
                'Total Items ${_productController.cartProductList.value.length}')
            .onTap(() async {}),
      ),
      bottomSheet: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: MaterialButton(
          color: Colors.lightBlueAccent,
          minWidth: context.screenWidth,
          splashColor: Colors.blueAccent,
          height: 50,
          highlightColor: Colors.blue,
          child: Obx(() => ' Pay \$${_productController.checkoutPrice.value}'
              .text
              .white
              .size(20)
              .bold
              .make()),
          onPressed: () {
            Get.to(
              OrderDetails(),
              transition: Transition.cupertino,
              duration: Duration(milliseconds: 500),
            );
          },
        ),
      ),
      body: Container(
        child: Obx(() => ListView.builder(
            // ignore: invalid_use_of_protected_member
            itemCount: _productController.cartProductList.value.length,
            itemBuilder: (context, index) {
              // ignore: invalid_use_of_protected_member
              final cartItem = _productController.cartProductList.value[index];
              return CartEdit(
                title: cartItem['productName'],
                image: cartItem['productDisplayImage'],
                price: cartItem['productPrice'],
                productId: index,
              );
            })),
      ),
    );
  }
}
