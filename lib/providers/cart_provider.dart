import 'package:buyemall/models/cart.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems}; // return a copy of the items
  }

  bool addCartItem(String productId, String title, double price) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(productId, (existingItem) {
        return CartItem(
            id: existingItem.id,
            productId: existingItem.productId,
            title: existingItem.title,
            quantity: existingItem.quantity + 1,
            price: existingItem.price);
      });
    } else {
      _cartItems.putIfAbsent(productId, () {
        return new CartItem(
            id: DateTime.now().toString(),
            productId: productId,
            title: title,
            quantity: 1,
            price: price);
      });
    }
    notifyListeners();
    return true;
  }

  bool removeCartItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
    return true;
  }

  int get cartItemsCount {
    return (_cartItems == null) ? 0 : _cartItems.length;
  }

  double get cartTotalAmount {
    var total = 0.0;
    _cartItems.forEach((key, value) {
      total += (value.price * value.quantity);
    });
    return total;
  }
}
