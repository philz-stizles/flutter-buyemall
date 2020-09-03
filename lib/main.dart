import 'package:buyemall/routes.dart';
import 'package:buyemall/screens/product_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/products_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (cxt) => ProductsProvider()),
        ChangeNotifierProvider(create: (cxt) => CartProvider())
      ],  // All children Widgets of this 
      // class would then be able to listen to the same instance of the 
      // ProductsProvider, however only children that are listeing would
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'Roboto',
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: ProductOverviewScreen(),
        routes: routes,
      ),
    );
  }
}
