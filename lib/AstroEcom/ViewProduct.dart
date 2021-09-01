import 'package:ecom_sample/AstroEcom/productController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';

class ViewProduct extends StatelessWidget {
  ProductController _productController = Get.find<ProductController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                ///image
                Stack(
                  children: [
                    Hero(
                      tag: "Image",
                      child: Image.network(
                        _productController
                            .productView.value['productDisplayImage'],
                        fit: BoxFit.cover,
                      )
                          .box
                          .height(
                            context.screenWidth / 1.6,
                          )
                          .width(context.screenWidth)
                          .shadow2xl
                          .make(),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios_rounded),
                          color: Vx.white,
                          highlightColor: Colors.black,
                          splashColor: Vx.white,
                        )
                      ],
                    )
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///title
                      _productController.productView.value['productName']
                          .toString()
                          .text
                          .size(25)
                          .make()
                          .marginOnly(top: 20),

                      ///Row ratting price
                      HStack(
                        // children:
                        [
                          VxRating(
                            onRatingUpdate: (val) {
                              print(val);
                            },
                            isSelectable: false,
                            maxRating: 5,
                            value: _productController
                                .productView.value['productRating']
                                .toDouble(),
                            size: 25,
                            count: 5,
                            selectionColor: Colors.deepOrangeAccent,
                          ).py8(),
                          '\$ ${int.parse(_productController.productView.value['productPrice'].toString()).numCurrency}'
                              .text
                              .xl3
                              .make(),
                        ],
                        alignment: MainAxisAlignment.spaceAround,
                        axisSize: MainAxisSize.max,
                      ).marginSymmetric(vertical: 20),
                      _productController.productView.value['productDescription']
                          .toString()
                          .text
                          .xl
                          .make(),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                MaterialButton(
                  minWidth: context.screenWidth,
                  height: 50,
                  color: Colors.blueAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_rounded,
                        color: Vx.white,
                      ).px8(),
                      Text('View Cart').text.white.xl2.make(),
                    ],
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();

                    // Get.to(TrackOrder());
                  },
                ).cornerRadius(0).marginSymmetric(vertical: 10),
                MaterialButton(
                  minWidth: context.screenWidth / 2,
                  height: 50,
                  color: Colors.blueAccent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_shopping_cart_outlined,
                        color: Vx.white,
                      ).px8(),
                      Text('Add to Cart').text.white.xl2.make(),
                    ],
                  ),
                  onPressed: () {
                    if (_productController.checkingCart(
                        _productController.productView.value['docId'])) {
                      VxToast.show(context,
                          msg: 'you already added this product in you cart');
                    } else {
                      _productController.setCartProductList(
                          _productController.productView.value);
                    }

                    // Get.to(TrackOrder());
                  },
                ).cornerRadius(0).marginSymmetric(vertical: 10),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
