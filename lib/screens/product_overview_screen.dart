import 'package:buyemall/providers/cart_provider.dart';
import 'package:buyemall/providers/products_provider.dart';
import 'package:buyemall/screens/cart_screen.dart';
import 'package:buyemall/screens/screens.dart';
import 'package:buyemall/widgets/badges.dart';
import 'package:buyemall/widgets/drawers.dart';
import 'package:buyemall/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

enum FilterOptions { All, Favorites }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavs = false;
  bool _isLoading = false;
  Widget child;

  @override
  void initState() {
    _isLoading = true;
    Provider.of<ProductsProvider>(context, listen: false).fetchProducts()
      .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // A new Screen should return a Scaffold
      appBar: AppBar(
        centerTitle: true,
        title: Text('Products Overview'),
        actions: <Widget>[
          PopupMenuButton<FilterOptions>(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.All) {
                  _showFavs = false;
                } else {
                  _showFavs = true;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            initialValue: FilterOptions.All,
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('All'),
                  value: FilterOptions.All,
                ),
                PopupMenuItem(
                  child: Text('Favorites'),
                  value: FilterOptions.Favorites,
                )
              ];
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return BadgedIcon(
                  icon: MdiIcons.cartPlus,
                  value: cartProvider.cartItemsCount.toString(),
                  onPressed: () {
                    return Navigator.of(context)
                        .pushNamed(CartScreen.routeName);
                  });
            },
          )
        ],
      ),
      body: (_isLoading) 
        ? Center(child: CircularProgressIndicator(),)
        : ProductsGrid(_showFavs),
      drawer: SimpleDrawer(),
    );
  }
}
