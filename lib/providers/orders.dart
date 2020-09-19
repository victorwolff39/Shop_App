import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    this.id,
    this.total,
    this.products,
    this.date,
  });
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [...orders];
  }

  void addOrder(Cart products, double total) {
    _orders.insert(
        0,
        Order(
          id: Random().nextDouble().toString(),
          date: DateTime.now(),
          products: products.items.values,
          total: products.totalAmount,
        ));
    notifyListeners();
  }
}
