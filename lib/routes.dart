import 'package:flutter/material.dart';

import 'screens/screens.dart';

final Map<String, WidgetBuilder> routes = {
  ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
  ProductEditScreen.routeName: (context) => ProductEditScreen(),
  UserProductsScreen.routeName: (context) => UserProductsScreen(),
  CartScreen.routeName: (context) => CartScreen(),
  OrdersScreen.routeName: (context) => OrdersScreen(),
};
