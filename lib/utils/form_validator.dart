import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum InputTypes {
  Email,
  Password,
}

class FormValidator {
  final InputTypes inputType;
  final String content;
  final bool allowNull;
  final bool allowZero;
  final bool allowNegativeNumbers;

  FormValidator({
    @required this.inputType,
    @required this.content,
    this.allowNull = false,
    this.allowZero = false,
    this.allowNegativeNumbers = false,
  });

  //Maybe implement some REGEX in the future...?
  String _emailValidate() {
    if (!allowNull && content == null) {
      return 'Missing e-mail address.';
    }
    if (!content.contains('@')) {
      return 'Invalid e-mail address.';
    }
    return null;
  }

  String _passwordValidate() {
    if (!allowNull && content == null) {
      return 'Password cannot be empty.';
    }
    if (content.length < 5) {
      return 'Password must be at least 5 characters long.';
    }
    return null;
  }

  String validate() {
    switch (inputType) {
      case InputTypes.Email:
        return _emailValidate();
      case InputTypes.Password:
        return _passwordValidate();
    }
  }
}
