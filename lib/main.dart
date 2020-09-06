import 'package:buyemall/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/providers.dart';
import 'screens/screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (cxt) => AuthProvider()), // This can be
          // provided at the AuthScreen directly, however we would be needing the
          // provider at other parts of the widget tree and not just at the Auth
          // AuthScreen
          ChangeNotifierProxyProvider<AuthProvider, ProductsProvider>(
            // The provider you want
            create: (_) => ProductsProvider(),
            update: (_, authProvider, previousProductsProvider) {
              return previousProductsProvider..update(authProvider);
            },
          ),
          ChangeNotifierProvider(create: (cxt) => CartProvider()),
          ChangeNotifierProvider(create: (cxt) => OrdersProvider())
        ], // All children Widgets of this
        // class would then be able to listen to the same instance of the
        // ProductsProvider, however only children that are listeing would
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                fontFamily: 'Roboto',
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: (!authProvider.isAuthenticated)
                  ? FutureBuilder(
                    future: authProvider.tryAutoLogin(),
                    builder: (context, authResultSnapshot) {
                      return (authResultSnapshot.connectionState == ConnectionState.waiting)
                      ? Scaffold(body: Center(child: Text('Loading...'),))
                      : AuthScreen();
                    },
                  )
                  : ProductOverviewScreen(),
              routes: routes,
            );
          },
        ));
  }
}
