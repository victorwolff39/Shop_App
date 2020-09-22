import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_app/utils/endpoints.dart';
import 'package:shop_app/models/error.dart';

class Product with ChangeNotifier {
  final String _productsUrl = Endpoints.PRODUCTS;
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

  Future<Error> toggleFavorite() async {
    _toggleFavorite();
    try {
      final response = await patch('$_productsUrl/$id.json',
          body: json.encode({'isFavorite': isFavorite}));
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
