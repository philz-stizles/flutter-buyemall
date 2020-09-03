import 'package:flutter/material.dart';

class CartItem with ChangeNotifier {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem( 
    {@required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,});
}
