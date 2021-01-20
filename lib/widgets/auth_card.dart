import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/exceptions/auth_exception.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/utils/form_validator.dart';

enum AuthMode { SignUp, SignIn }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> _form = GlobalKey();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.SignIn;

  final _passwordController = TextEditingController();

  AnimationController _controller;
  Animation<double> _opacityAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween(
      begin: Offset(0, -1.5),
      end: Offset(0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  Future<void> _submit(BuildContext context) async {
    _authData.clear();
    if (!_form.currentState.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    _form.currentState.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_authMode == AuthMode.SignIn) {
        await auth.signIn(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await auth.signUp(
          _authData['email'],
          _authData['password'],
        );
      }
    } on AuthException catch (error) {
      _showMessageDialog(error.toString());
    } catch (error) {
      _showMessageDialog("An unknown error has occurred.");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _showMessageDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Authentication Error"),
        content: Text(msg),
        actions: [
          FlatButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _switchView() {
    if (_authMode == AuthMode.SignIn) {
      _authMode = AuthMode.SignUp;
      _controller.forward();
    } else {
      _authMode = AuthMode.SignIn;
      _controller.reverse();
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
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
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
                validator: _authMode == AuthMode.SignUp
                    ? (value) {
                        //If the user is not creating a account, I don't want to validate his password
                        return FormValidator(
                          content: value,
                          inputType: InputTypes.Password,
                        ).validate();
                      }
                    : null,
                onSaved: (value) => _authData['password'] = value,
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                  maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: TextFormField(
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
                  ),
                ),
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
                      onPressed: () {
                        _submit(context);
                      },
                    ),
              FlatButton(
                child:
                    Text(_authMode == AuthMode.SignIn ? "Sign Up" : "Sign In"),
                textColor: Theme.of(context).primaryColor,
                onPressed: _isLoading ? null : _switchView,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
