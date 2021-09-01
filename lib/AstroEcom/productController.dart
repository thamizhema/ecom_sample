import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void printWarning(String text) {
  print(' \x1B[32m $text\x1B[0m');
}

void printError(String text) {
  print('\x1B[31m$text\x1B[0m');
}

class ProductController extends GetxController {
  final productList = [].obs;
  final cartProductList = [].obs;
  final checkoutPrice = 0.obs;
  final checkCart = false.obs;
  final productView = {}.obs;

  setProductView(product) {
    productView(product);
  }

  setProductList(product) {
    productList(product);
  }

  checkingCart(docId) {
    for (var id in cartProductList) {
      if (id['docId'] == docId) {
        return true;
        // checkCart(true);
        break;
      }
    }
    return false;
  }

  setCartProductList(cartList) {
    cartProductList.add(cartList);
    setSession(cartProductList);
  }

  clearCartProductList() {
    cartProductList.clear();
  }

  removeCartProductList(index) {
    cartProductList.removeAt(index);
    setSession(cartProductList);
  }

  setCheckoutPrice() {
    dynamic total = 0;
    for (var i in cartProductList) {
      total += i['totalPrice'];
    }
    checkoutPrice(total);
  }

  updateCartProductList({index, key, value}) {
    cartProductList[index][key] = value;
  }

  setSession(cartList) async {
    final encodeData = json.encode(cartList);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('cartList', encodeData);
  }

  getSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cartSession = await prefs.getString('cartList');
    final decodeData = json.decode(cartSession!);
    cartProductList(decodeData);
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getSession();
    printWarning('getx init function completed');
    // print('getx init function completed');
  }
}
