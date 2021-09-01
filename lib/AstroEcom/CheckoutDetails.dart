import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecom_sample/AstroEcom/astro_ecom.dart';
import 'package:ecom_sample/AstroEcom/orderController.dart';
import 'package:ecom_sample/AstroEcom/productController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CheckoutDetails extends StatefulWidget {
  @override
  _CheckoutDetailsState createState() => _CheckoutDetailsState();
}

class _CheckoutDetailsState extends State<CheckoutDetails> {
  late Razorpay _razorpay;
  OrderController _orderController = Get.find<OrderController>();
  ProductController _productController = Get.find<ProductController>();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_yI4lHyiI5FRJWt',
      'amount': 100,
      'name': 'OceanAcademy',
      'description': 'Booking Appointment',
      'prefill': {
        'contact': _orderController.orderDelivery.value['number'],
        'email': 'test@gmail.com'
      },
      'external': {
        'wallets': ['paytm', 'phonepe']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    VxToast.show(
      context,
      msg: 'Success',
      position: VxToastPosition.bottom,
      bgColor: Colors.green,
      textColor: Vx.white,
      textSize: 15,
    );
    _orderController.updateOrderDelivery(
        'paymentId', response.paymentId.toString());
    printWarning(response.paymentId.toString());

    Map<String, dynamic> firebaseData = {};
    for (var data in _orderController.orderDelivery.value.entries) {
      firebaseData[data.key.toString()] = data.value;
    }
    _firestore.collection('buyer').add(firebaseData);
    _productController.clearCartProductList();
    Get.offAll(AstroEcom());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    printWarning(response.message.toString());
    // var test = json.decode([response]);
    var test = jsonDecode(response.message.toString());
    print(response.message);
    print(test.runtimeType);
    print(test['error']['description']);

    VxDialog.showConfirmation(context,
        content: "${test['error']['description']}",
        title: "payment failed", onCancelPress: () {
      Get.offAll(AstroEcom());
    }, onConfirmPress: openCheckout);
    _productController.clearCartProductList();
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    VxToast.show(
      context,
      msg: 'Wallet pay',
      position: VxToastPosition.bottom,
      bgColor: Colors.yellow[900],
      textColor: Vx.white,
      textSize: 15,
    );
    printWarning(response.walletName.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            color: Vx.white,
            // padding: EdgeInsets.symmetric(horizontal: 20),
            height: 600,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(Icons.close))
                      ],
                    ),
                    Text('Check Your Order Info')
                        .text
                        .xl2
                        .make()
                        .marginOnly(top: 20, bottom: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (var userInfo
                              in _orderController.orderDelivery.value.entries)
                            if (userInfo.key != 'cartList')
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    Text(userInfo.key)
                                        .text
                                        .size(20)
                                        .make()
                                        .box
                                        .width(context.screenWidth / 3)
                                        .make(),
                                    Text(userInfo.value.toString())
                                        .text
                                        .size(20)
                                        .make()
                                        .box
                                        // .alignCenter
                                        .width(context.screenWidth / 2)
                                        .make(),
                                  ],
                                ),
                              )
                        ],
                      ).scrollVertical(),
                    ),
                  ],
                ),
                MaterialButton(
                  minWidth: context.screenWidth,
                  height: 50,
                  color: Colors.blueAccent,
                  child: Text('Okay').text.white.xl2.make(),
                  onPressed: () {
                    VxDialog.showTicker(
                      context,
                      barrierDismissible: false,
                      showClose: true,
                      content:
                          'Are sure to Pay \$ ${_productController.checkoutPrice.value.toString()}',
                      onConfirmPress: openCheckout,
                    );
                    // Get.to(TrackOrder());
                  },
                ).cornerRadius(5),
              ],
            ),
          ).cornerRadius(15),
        ),
      ),
    );
  }
}
