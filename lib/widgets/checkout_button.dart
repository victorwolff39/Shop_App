import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/error.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';

class CheckoutButton extends StatefulWidget {
  @override
  _CheckoutButtonState createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'CHECKOUT',
            ),
      textColor: Theme.of(context).primaryColor,
      onPressed: cart.totalAmount > 0
          ? () async {
              final orders = Provider.of<Orders>(context, listen: false);
              setState(() {
                _isLoading = true;
              });
              Error error = await orders.addOrder(cart);
              setState(() {
                _isLoading = false;
              });
              if (error != null) {
                final scaffold = Scaffold.of(context);
                scaffold.showSnackBar(SnackBar(
                  content: Text(error.description),
                ));
              } else {
                cart.clear();
              }
            }
          : null,
    );
  }
}
