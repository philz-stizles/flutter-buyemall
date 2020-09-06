import 'package:buyemall/models/cart.dart';
import 'package:flutter/foundation.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime createdAt;


  OrderItem( 
    {@required this.id,
    @required this.amount,
    @required this.products,
    @required this.createdAt,});
}