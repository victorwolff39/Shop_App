import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/error.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/utils/form_validator.dart';

enum AuthMode { SignUp, SignIn }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.SignIn;

  final _passwordController = TextEditingController();
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit() async {
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();
    
    Auth auth = Provider.of(context, listen: false);
    Error error;

    if (_authMode == AuthMode.SignIn) {
      //Login
    } else {
      error = await auth.signUp(_authData['email'], _authData['password']);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchView() {
    if (_authMode == AuthMode.SignIn) {
      _authMode = AuthMode.SignUp;
    } else {
      _authMode = AuthMode.SignIn;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: _authMode == AuthMode.SignIn ? 290 : 371,
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return FormValidator(
                    content: value,
                    inputType: InputTypes.Email,
                  ).validate();
                },
                onSaved: (value) => _authData['email'] = value,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  return FormValidator(
                    content: value,
                    inputType: InputTypes.Password,
                  ).validate();
                },
                onSaved: (value) => _authData['password'] = value,
              ),
              if (_authMode == AuthMode.SignUp)
                TextFormField(
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                  obscureText: true,
                  validator: _authMode == AuthMode.SignUp
                      ? (value) {
                          if (value != _passwordController.text) {
                            return "Passwords don't match.";
                          }
                          return null;
                        }
                      : null,
                ),
              Spacer(),
              _isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: Theme.of(context).primaryColor,
                      textColor:
                          Theme.of(context).primaryTextTheme.button.color,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      child: Text(
                        _authMode == AuthMode.SignIn ? 'LOGIN' : 'REGISTER',
                      ),
                      onPressed: _submit,
                    ),
              FlatButton(
                child:
                    Text(_authMode == AuthMode.SignIn ? "Sign Up" : "Sign In"),
                textColor: Theme.of(context).primaryColor,
                onPressed: _isLoading ? null : _switchView,
              )
            ],
          ),
        ),
      ),
    );
  }
}
