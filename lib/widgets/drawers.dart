import 'package:buyemall/providers/auth_provider.dart';
import 'package:buyemall/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SimpleDrawer extends StatelessWidget {
  const SimpleDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false, // Do not show back icon as
            // this would be inappropriate for an Appbar on a sidedrawer
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit_attributes),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed ('/');
              Provider.of<AuthProvider>(context, listen: false).logOut();
            },
          )
        ],
      ),
    );
  }
}
