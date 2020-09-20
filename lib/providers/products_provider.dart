import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop_app/data/dummy_data.dart';
import 'package:shop_app/data/endpoints.dart';
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

  Future<void> addProduct(Product newProduct) {
    const productsUrl = Endpoints.PRODUCTS;
    /*
     * To return a Future, you need to put the "return" in front so that ONLY
     * when the code inside of "then" finishes it will return a Future that can
     * be accessed with the Then function.
     */
    return post(
      productsUrl,
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'isFavorite': newProduct.isFavorite,
      }),
      /*
      * The method POST returns a Future<Response>, this means that the program
      * will not stop and wait for the HTTP response, but instead will continue
      * running and execute something once it receives the response.
      *
      * I can get the response by using the .then() and receiving the "response".
      *
      * .then((response) {
      * });
      */
    ).then((response) {
      _items.add(Product(
        id: json.decode(response.body)['name'],
        //Using the returned "name"
        title: newProduct.title,
        description: newProduct.description,
        price: newProduct.price,
        imageUrl: newProduct.imageUrl,
      ));
      notifyListeners();
    });
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
