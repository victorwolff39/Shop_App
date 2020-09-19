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
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  void addOrder(Cart products) {
    _items.insert(
        0,
        Order(
          id: Random().nextDouble().toString(),
          date: DateTime.now(),
          products: products.items.values.toList(),
          total: products.totalAmount,
        ));
    notifyListeners();
  }
}
