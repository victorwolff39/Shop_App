import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/utils/app_routes.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
          centerTitle: true,
          actions: [
            Consumer<Cart>(
              /*
               * In this case I make use of the 3rd parameter in the Consumer.
               * I don't need to rebuild the whole IconButton, so I put it in the child (upper one)
               * of the Consumer, and in the builder's child I put the badge, that is what will
               * effectively be changing according to the value received from the Cart provider.
               */
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.CART),
              ),
              builder: (ctx, cart, child) =>
                  Badge(
                    value: cart.itemsCount.toString(),
                    child: child,
                  ),
            ),
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.All) {
                    _showFavoriteOnly = false;
                  } else {
                    _showFavoriteOnly = true;
                  }
                });
              },
              icon: Icon(Icons.filter_list),
              itemBuilder: (_) =>
              [
                PopupMenuItem(
                  child: Text('All'),
                  value: FilterOptions.All,
                ),
                PopupMenuItem(
                  child: Text('Favorites'),
                  value: FilterOptions.Favorite,
                ),
              ],
            ),
          ],
        ),
        body: Consumer<ProductsProvider>(
          builder: (ctx, product, _) => ProductsGrid(_showFavoriteOnly),
        ),
      drawer: AppDrawer(),
      //ProductsGrid(_showFavoriteOnly),
    );
  }
}
