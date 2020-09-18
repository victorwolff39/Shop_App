import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
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
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Todos'),
                  value: FilterOptions.All,
                ),
                PopupMenuItem(
                  child: Text('Favoritos'),
                  value: FilterOptions.Favorite,
                ),
              ],
            ),
          ],
        ),
        body: Consumer<ProductsProvider>(
          builder: (ctx, product, _) => ProductsGrid(_showFavoriteOnly),
        )

        //ProductsGrid(_showFavoriteOnly),
        );
  }
}
