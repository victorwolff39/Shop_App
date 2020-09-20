import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/data/endpoints.dart';
import 'package:shop_app/models/error.dart';
import 'package:shop_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  /*
  * To test the Provider functionality, remove DUMMY_PRODUCTS from here
  * and note that there is no more products in the ProductsOverview page.
  *
  * List<Product> _items = [];
   */
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<Error> addProduct(Product newProduct) async {
    const productsUrl = Endpoints.PRODUCTS;
    try {
      final response = await post(
        productsUrl,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
          'isFavorite': newProduct.isFavorite,
        }),
      );

      _items.add(Product(
        id: json.decode(response.body)['name'],
        //Using the returned "name"
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
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

  void updateProduct(Product product) {
    if (product == null || product.id == null) {
      return;
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final index = _items.indexWhere((prod) => prod.id == prod.id);
    if (index >= 0) {
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    }
  }

  int itemsCount() {
    return _items.length;
  }
}
