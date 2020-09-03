import 'package:buyemall/models/product.dart';
import 'package:buyemall/providers/cart_provider.dart';
import 'package:buyemall/providers/products_provider.dart';
import 'package:buyemall/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridTile extends StatelessWidget {
  // final Product product;
  // ProductGridTile(this.product);

  Image _buildGridTileChild(BuildContext context, Product product) {
    return Image.network(
      product.imageUrl,
      fit: BoxFit.cover,
      // filterQuality: FilterQuality.high,
    );
  }

  GridTileBar _buildGridTileFooter(
      BuildContext context, Product product, CartProvider cartProvider) {
    return GridTileBar(
      leading: Consumer<Product>(builder: (context, product, child) {
        return IconButton(
            icon: Icon(
              (product.isFavorite) ? Icons.favorite : Icons.favorite_border,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => product.toggleFavoriteStatus());
      }),
      backgroundColor: Colors.black87,
      title: Text(
        product.title,
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
          icon: Icon(
            Icons.shopping_cart,
          ),
          onPressed: () {
            cartProvider.addCartItem(product.id, product.title, product.price);
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the Provider in this way solves the problem of passing ..
    // The Product Model must then extend the ChangeNotifier for you to be
    // able to listen to changes at the Product model level.
    final product = Provider.of<Product>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GestureDetector(
        child: GridTile(
            child: _buildGridTileChild(context, product),
            footer: _buildGridTileFooter(context, product, cartProvider)),
        onTap: () {
          Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
        },
      ),
    );
  }
}
