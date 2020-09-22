import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop_app/data/endpoints.dart';
import 'package:shop_app/models/error.dart';
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
  final _ordersUrl = Endpoints.ORDERS;

  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<Error> addOrder(Cart cart) async {
    final date = DateTime.now();
    try {
      final response = await post(
        '$_ordersUrl.json',
        body: json.encode({
          'total': cart.totalAmount,
          'date': date.toIso8601String(),
          'products': cart.items.values.map((item) => {
            'quantity': item.quantity,
            'total': item.total,
            'id': item.product.id,
            'price': item.product.price,
            'description': item.product.description,
            'isFavorite': item.product.isFavorite,
            'title': item.product.title,
            'imageUrl': item.product.imageUrl,
          }).toList()
        }),
      );
      _items.insert(
          0,
          Order(
            id: json.decode(response.body)['name'],
            date: date,
            products: cart.items.values.toList(),
            total: cart.totalAmount,
          ));
      notifyListeners();
      return null;
    } catch (error) {
      return Error(
        title: 'Unknown Error',
        description: 'An unexpected error has occurred.',
      );
    }
  }






    /*
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
  */
}
