import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop_app/exceptions/auth_exception.dart';
import 'package:shop_app/models/error.dart';
import 'package:shop_app/utils/endpoints.dart';

class Auth with ChangeNotifier {
  /*
   * Note: signIn and signUp are practically the same thing.
   */

  Future<void> signIn(String email, String password) async {
    final response = await post(Endpoints.AUTH_SIGNIN_API,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    print(json.decode(response.body));

    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      throw AuthException(responseBody["error"]["message"]);
    }
    return Future.value();
  }

  Future<void> signUp(String email, String password) async {
    final response = await post(Endpoints.AUTH_SIGNUP_API,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }));
    print(json.decode(response.body));

    final responseBody = json.decode(response.body);
    if (responseBody["error"] != null) {
      throw AuthException(responseBody["error"]["message"]);
    }
    return Future.value();
  }
}
