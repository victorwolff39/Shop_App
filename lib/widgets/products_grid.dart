import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/widgets/product_grid_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavoriteOnly;

  ProductsGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    /*
     * Getting products from the provider
    */
    final productsProvider = Provider.of<ProductsProvider>(context);
    final products = !showFavoriteOnly
        ? productsProvider.items
        : productsProvider.favoriteItems;

    return products.length != 0
        ? GridView.builder(
            itemCount: products.length,
            padding: EdgeInsets.all(10),
            /*
            * We are using a pre-existent ChangeNotifierProvider, so it is recommended
            * that a .value is used instead of a "create: "
            *
            * This ChangeNotifierProvider is created at the product.dart file, contrary
            * to the Provider used in the products list that needed a new file
            * (products_provider.dart) to be created.
            */
            itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              value: products[index],
              child: ProductGridItem(),
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
          )
        : Center(
            child: Text('No product found.'),
          );
  }
}
