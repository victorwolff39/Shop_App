import 'package:flutter/material.dart';

class Error {
  final String title;
  final String description;
  final String code;

  Error({
    @required this.title,
    @required this.description,
    this.code,
  });
}
