import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop_app/utils/endpoints.dart';
import 'package:shop_app/models/error.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/product.dart';

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

  Future<void> loadOrders() async {
    List<Order> loadedItems = [];
    final response = await get('$_ordersUrl.json');
    Map<String, dynamic> data = json.decode(response.body);
    if (data != null) {
      data.forEach((orderId, orderData) {
        loadedItems.add(Order(
          id: orderId,
          total: orderData['total'],
          date: DateTime.parse(orderData['date']),
          products: (orderData['products'] as List<dynamic>).map((item) {
            return CartItem(
              product: Product(
                title: item['title'],
                description: item['description'],
                id: item['id'],
                isFavorite: item['isFavorite'],
                imageUrl: item['imageUrl'],
                price: item['price'],
              ),
              total: item['total'],
              quantity: item['quantity'],
            );
          }).toList(),
        ));
      });
      notifyListeners();
    }
    _items.clear();
    _items = loadedItems.reversed.toList();
    return Future.value();
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
