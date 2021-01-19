import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_app/utils/endpoints.dart';
import 'package:shop_app/models/error.dart';

class Product with ChangeNotifier {
  //final String _productsUrl = Endpoints.PRODUCTS;
  final String _userFavoritesUrl = Endpoints.USER_FAVORITES;
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<Error> toggleFavorite(String token, String userId) async {
    _toggleFavorite();
    try {
      final response = await put('$_userFavoritesUrl/$userId/$id.json?auth=$token',
          body: json.encode(isFavorite));
      if(response.statusCode >= 400) {
        _toggleFavorite();
        return Error(
          title: 'Unknown Error',
          description: 'An unexpected error has occurred.',
        );
      }
      return null;
    } catch (error) {
      _toggleFavorite();
      return Error(
        title: 'Unknown Error',
        description: 'An unexpected error has occurred.',
      );
    }
  }
}
