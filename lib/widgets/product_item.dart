import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.PRODUCT_FORM, arguments: product);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                /*
                 * Using a different approach this time...
                 * Instead of the button executing the action (deletion), It now
                 * returns a boolean value that can be picked up by the method "then"
                 * at the end.
                 */
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Delete Product'),
                    content: Text(
                        'You are about to delete ${product.title}. Do you want to proceed?'),
                    actions: [
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                ).then((value) {
                  if(value) {
                    Provider.of<ProductsProvider>(context, listen: false).deleteProduct(product.id);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
