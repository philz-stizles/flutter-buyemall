import 'package:buyemall/models/cart.dart';
import 'package:buyemall/providers/cart_provider.dart';
import 'package:buyemall/widgets/cards.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Items'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    Spacer(),
                    Chip(
                      label: Text('\$${cartProvider.cartTotalAmount}',
                          style: TextStyle(
                            color: Colors.white70,
                          )),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    FlatButton(
                        onPressed: () {},
                        child: Text(
                          'ORDER NOW',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              var cartItem = cartProvider.cartItems.values.toList()[index];
              return DismissibleTileCard(
                id: cartItem.id, 
                leading: '\$${(cartItem.price * cartItem.quantity)}',
                title: cartItem.title,
                subTitle: 'Total: ${cartItem.price}',
                trailing: '${cartItem.quantity} X',
                onDismissed: (_) => cartProvider.removeCartItem(cartItem.productId),
              );
            },
          ))
        ],
      ),
    );
  }
}
