import 'package:flutter/cupertino.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'file:///E:/%23STORAGE/PROJECTS/curso_flutter/shop_app/lib/providers/product.dart';

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

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }
}
