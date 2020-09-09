import 'package:buyemall/providers/cart_provider.dart';
import 'package:buyemall/providers/products_provider.dart';
import 'package:buyemall/screens/screens.dart';
import 'package:buyemall/widgets/drawers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      // A new Screen should return a Scaffold
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Your Products'),
        actions: <Widget>[
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return IconButton(
                  icon: Icon(Icons.add_circle),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(ProductEditScreen.routeName);
                  });
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: productsProvider.items.length,
              itemBuilder: (_, i) {
                var product = productsProvider.items[i];
                return Column(
                  children: [
                    ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(product.imageUrl),
                        ),
                        title: Text(product.title),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      ProductEditScreen.routeName,
                                      arguments: product);
                                },
                                color: Theme.of(context).primaryColor,
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return AlertDialog(
                                          title: Text('Are you sure?'),
                                          actions: [
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: Text('No')),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: Text('Yes'))
                                          ],
                                        );
                                      },
                                    );
                                    Provider.of<ProductsProvider>(context,
                                            listen: false)
                                        .deleteProduct(product.id);
                                  },
                                  color: Theme.of(context).errorColor)
                            ],
                          ),
                        )),
                    Divider()
                  ],
                );
              }),
        ),
      ),
      drawer: SimpleDrawer(),
    );
  }
}
