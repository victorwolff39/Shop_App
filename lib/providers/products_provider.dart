import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shop_app/utils/endpoints.dart';
import 'package:shop_app/models/error.dart';
import 'package:shop_app/providers/product.dart';

class ProductsProvider with ChangeNotifier {
  final String _productsUrl = Endpoints.PRODUCTS;
  final String _userFavoritesUrl = Endpoints.USER_FAVORITES;
  List<Product> _items = [];
  String _token;
  String _userId;

  ProductsProvider([this._token, this._userId, this._items = const[]]);

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> loadProducts() async {
    _items.clear();
    final response = await get('$_productsUrl.json?auth=$_token');
    Map<String, dynamic> data = json.decode(response.body);

    final favoriteResponse = await get('$_userFavoritesUrl/$_userId.json?auth=$_token');
    final favoritesMap = json.decode(favoriteResponse.body);

    if (data != null) {
      data.forEach((productId, productData) {
        final isFavorite = favoritesMap == null ? false : favoritesMap[productId] ?? false; //If the product is not present in the userFavorites, it will be considered as "false"
        _items.add(Product(
          id: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<Error> addProduct(Product newProduct) async {
    try {
      final response = await post(
        '$_productsUrl.json?auth=$_token',
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
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

  Future<Error> updateProduct(Product product) async {
    if (product == null || product.id == null) {
      return null;
    }
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      try {
        await patch('$_productsUrl/${product.id}.json?auth=$_token',
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
            }));
        _items[index] = product;
        notifyListeners();
        return null;
      } catch (error) {
        return Error(
          title: 'Unknown Error',
          description: 'An unexpected error has occurred.',
        );
      }
    } else {
      return null;
    }
  }

  Future<Error> deleteProduct(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    //final index = _items.indexWhere((prod) => prod.id == prod.id);
    if (index >= 0) {
      final product = _items[index];
      try {
        final response = await delete('$_productsUrl/${product.id}.json?auth=$_token');
        _items.remove(product);
        notifyListeners();
        if (response.statusCode >= 400) {
          _items.add(product);
          notifyListeners();
          return Error(
              title: 'Unknown Error',
              description: 'An unexpected error has occurred.');
        }
        return null;
      } catch (error) {
        return Error(
            title: 'Unknown Error',
            description: 'An unexpected error has occurred.');
      }
    }
    return null;
  }

  int itemsCount() {
    return _items.length;
  }
}
