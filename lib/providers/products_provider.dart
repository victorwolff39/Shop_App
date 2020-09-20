import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/data/dummy_data.dart';
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

  void addProduct(Product newProduct) {
    _items.add(Product(
      id: Random().nextDouble().toString(),
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    notifyListeners();
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
