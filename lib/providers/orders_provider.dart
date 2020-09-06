import 'package:buyemall/models/cart.dart';
import 'package:buyemall/models/order.dart';
import 'package:flutter/material.dart';

class OrdersProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders]; // return a copy of the items
  }

  bool addOrder(List<CartItem> cartItems, double total) {
    _orders.insert(0, OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      createdAt: DateTime.now(),
      products: cartItems));
    notifyListeners();
    return true;
  }

  // bool removeOrder(String productId) {
  //   _cartItems.remove(productId);
  //   notifyListeners();
  //   return true;
  // }

  // int get orderCount {
  //   return (_orders == null) ? 0 : _orders.length;
  // }

  // double get cartTotalAmount {
  //   var total = 0.0;
  //   _orders.forEach((key, value) {
  //     total += (value.price * value.quantity);
  //   });
  //   return total;
  // }
}
