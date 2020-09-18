import 'package:flutter/cupertino.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/models/product.dart';

class ProductsProvider with ChangeNotifier {
  /*
  * To test the Provider functionality, remove DUMMY_PRODUCTS from here
  * and note that there is no more products in the ProductsOverview page.
  *
  * List<Product> _items = [];
   */
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items => [..._items];

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
