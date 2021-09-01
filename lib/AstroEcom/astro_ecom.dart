import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_sample/AstroEcom/CheckoutDetails.dart';
import 'package:ecom_sample/AstroEcom/ViewCart.dart';
import 'dart:convert';
import 'package:ecom_sample/AstroEcom/ProductCard.dart';
import 'package:ecom_sample/AstroEcom/ViewProduct.dart';
import 'package:ecom_sample/AstroEcom/productController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:badges/badges.dart';

class AstroEcom extends StatefulWidget {
  @override
  _AstroEcomState createState() => _AstroEcomState();
}

class _AstroEcomState extends State<AstroEcom> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  ProductController _productController = Get.find<ProductController>();

  setProductSession(List<dynamic> cartList) async {
    final encodeData = json.encode(cartList);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartList', encodeData);

    final cartSession = await prefs.getString('cartList');
    final decodeData = json.decode(cartSession!);

    _productController.cartProductList.value = decodeData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
        centerTitle: true,
        actions: [
          Icon(Icons.clear).onTap(() {
            _productController.clearCartProductList();
          }),
          Obx(
            () => Badge(
              badgeColor: Vx.red600,
              // ignore: invalid_use_of_protected_member
              showBadge: _productController.cartProductList.value.length == 0
                  ? false
                  : true,
              badgeContent:
                  // ignore: invalid_use_of_protected_member
                  _productController.cartProductList.value.length
                      .toString()
                      .text
                      .white
                      .make(),
              position: BadgePosition(top: 5, end: -10),
              child: Icon(Icons.shopping_cart),
              animationType: BadgeAnimationType.slide,
            ),
          ).onInkTap(() {
            _productController.setCheckoutPrice();
            Get.to(
              // CheckoutDetails(),
              ViewCart(),
              transition: Transition.cupertino,
              duration: Duration(milliseconds: 500),
            );
          }),
          SizedBox(
            width: 30,
          )
        ],
      ),
      drawer: Drawer(
        semanticLabel: 'thamizhhd',
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              title: Text("Working on it").text.xl2.make(),
            ),
          ],
        ),
      ),
      body: Center(
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('Products').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text('No product datas');
              } else {
                final productDatas = snapshot.data!.docs;
                final productDatasList = [];
                for (var i in productDatas) {
                  Map convertData = {
                    'productRating': i['productRating'],
                    'productPrice': i['productPrice'],
                    'productName': i['productName'],
                    'productDisplayImage': i['productDisplayImage'],
                    'productDescription': i['productDescription'],
                    'totalPrice': i['productPrice'],
                    'docId': i.id
                  };

                  productDatasList.add(convertData);
                }
                _productController.setProductList(productDatasList);
                return GridView.count(
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.57,
                  crossAxisCount: 2,
                  children: [
                    // ignore: invalid_use_of_protected_member
                    for (var i in _productController.productList.value)
                      ProductCard(
                        title: i['productName'],
                        price: i['productPrice'],
                        image: i['productDisplayImage'],
                        rating: i['productRating'],
                        addTocart: () async {
                          // ignore: invalid_use_of_protected_member
                          if (_productController.checkingCart(i['docId'])) {
                            VxToast.show(context,
                                msg:
                                    'you already added this product in you cart');
                          } else {
                            _productController.setCartProductList(i);
                          }
                        },
                        productView: () {
                          _productController.setProductView(i);
                          print(i);
                          Get.to(ViewProduct(),
                              transition: Transition.cupertino,
                              duration: Duration(milliseconds: 500));
                        },
                      ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
