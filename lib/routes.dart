import 'package:buyemall/screens/cart_screen.dart';
import 'package:buyemall/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
  CartScreen.routeName: (context) => CartScreen(),
};
