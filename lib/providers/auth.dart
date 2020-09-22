import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_app/models/error.dart';
import 'package:shop_app/utils/endpoints.dart';

class Auth with ChangeNotifier {

  Future<Error> signUp(String email, String password) async {
    final response = await post(Endpoints.AUTH_API, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));
    print(json.decode(response.body));
    return Error(
      title: 'No error',
      description: 'Seriously... There is nothing here...'
    );
  }
}