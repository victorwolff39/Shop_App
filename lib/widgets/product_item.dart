import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*
     * Setting the "listen: false" makes so your provider don't listen to updates.
     *
     * That could be useful if we weren't using two icons in the favorite button,
     * we would STILL receive the all the products information (including non final attributes
     * like "isFavorite") AND be able to use methods (like toggleFavorite),
     * but would not "notice" if any information gets updated.
     *
     * Using a Consumer in order to update the icon... See comment bellow
     *
     */
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_DETAIL,
                arguments: product,
              );
            },
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              /*
               *
               * Using a Consumer to Wrap the Icon in the IconButton.
               * The Provider is configured to not listen to updates (listen: false).
               * For that reason, we are not getting notified when values change, so we use a
               * Consumer to wrap only the objects that we need to update values for optimization.
               *
               */
              icon: Consumer<Product>(
                builder: (ctx, product, _) => Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
              ),
              onPressed: product.toggleFavorite,
            ),
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                cart.addItem(product);
                print(cart.itemsCount);
              },
            ),
          )),
    );
  }
}
