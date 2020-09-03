import 'package:buyemall/providers/products_provider.dart';
import 'package:buyemall/widgets/product_grid_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    // You can only use the Provider.of listener in a Widget that has a parent
    // with the Provider  ChangeNotifierProvider/Multiprovider etc.
    // This build method will then re-build whenever there is a change in the
    // object it is listening to.
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = (showFavs) 
      ? productsProvider.favoriteItems 
      : productsProvider.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //Grid structure
            crossAxisCount: 2, // Number of columns
            childAspectRatio:
                2 / 2, // size ratio of each column width to height
            crossAxisSpacing: 10.0, // Spacing between columns
            mainAxisSpacing: 10.0 // Spacing between row s
            ),
        itemCount: products.length, // Number of items to build
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductGridTile(),
              // child: ProductGridTile(products[i]),
            ));
  }
}
