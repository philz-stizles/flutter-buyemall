import 'package:buyemall/providers/orders_provider.dart';
import 'package:buyemall/widgets/drawers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const String routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrdersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (context, index) {
          var orderItem = ordersProvider.orders[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title: Text('\$${orderItem.amount}'),
                  subtitle: Text(DateFormat('dd MM yyyy hh:mm')
                      .format(orderItem.createdAt)),
                  trailing: IconButton(
                      icon: Icon((_expanded) ? Icons.expand_less : Icons.expand_more),
                      onPressed: () {
                        setState(() {
                          _expanded = !_expanded;
                        });
                      }),
                )
              ],
            ),
          );
        },
      ),
      drawer: SimpleDrawer(),
    );
  }
}
