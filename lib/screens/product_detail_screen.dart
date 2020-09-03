import 'package:buyemall/models/product.dart';
import 'package:buyemall/providers/products_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final _productId = ModalRoute.of(context).settings.arguments as String;
    final _selectedProduct = Provider.of<ProductsProvider>(
      context,
      listen: false // listen: false would load data once, and then will not 
      // listen to changes afterwards, true will listen to changes and is the 
      // default
    ).findById(_productId);

    return Scaffold(
      appBar: AppBar(title: Text(_selectedProduct.title),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                _selectedProduct.imageUrl,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
            SizedBox(height: 10,),
            Text('\$${_selectedProduct.price}', style: TextStyle(color: Colors.grey, fontSize: 20),),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                _selectedProduct.description, 
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(color: Colors.grey, fontSize: 20),),
            )
          ],
        ),
      )
    );
  }
}