import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import 'dart:io' show Platform;
import '../providers/auth.dart';
import '../validation/validation.dart';

// import 'google_sign_in_button.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with Validation {
  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  bool _registrationMode = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final _formKey = GlobalKey<FormState>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    const radius = 15.0;

    auth.addListener(() {
      if (auth.isAuthenticated) Navigator.of(context).pop();
    });

    final emailField = TextFormField(
      obscureText: false,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Email',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      validator: validateEmail,
      controller: emailController,
    );

    final passwordField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      validator: validatePassword,
      controller: passwordController,
    );

    final passwordConfirmField = TextFormField(
      obscureText: true,
      style: style,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: 'Confirm password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      validator: (v) => validatePasswordConfirm(v, passwordController.text),
      controller: passwordConfirmController,
    );

    final actionButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(radius),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (!_formKey.currentState.validate()) {
            return;
          }

          try {
            if (_registrationMode) {
              await auth.register(
                  emailController.text, passwordController.text);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User has been registered successfully'),
                ),
              );
            } else {
              await auth.authenticate(
                  emailController.text, passwordController.text);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('User has been logged in successfully'),
                ),
              );
            }
          } catch (err) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(err),
              ),
            );
          }
        },
        child: Text(_registrationMode ? 'Sign up' : 'Login',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    final switchButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(radius),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => setState(() => _registrationMode = !_registrationMode),
        child: Text(_registrationMode ? 'Login instead' : 'Sign up',
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    List<Widget> fields() {
      List<Widget> w = [
        SizedBox(height: 45.0),
        emailField,
        SizedBox(height: 25.0),
        passwordField,
      ];

      if (_registrationMode) {
        w.add(SizedBox(height: 25.0));
        w.add(passwordConfirmField);
      }

      return w;
    }

    return Container(
      width: width - 800,
      //height: height - (_registrationMode ? 300 : 350),
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 75.0,
                    child: Image.asset(
                      "assets/images/logo-yellow-round.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  ...fields(),
                  SizedBox(height: 35.0),
                  actionButton,
                  SizedBox(height: 35.0),
                  switchButton,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showMaterialDialog(String title, BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => AlertDialog(
            title: Text(title),
            content: AuthForm(),
          ));
}

void _showCupertinoDialog(String title, BuildContext context) {
  showDialog(
      context: context,
      builder: (_) => new CupertinoAlertDialog(
            title: Text(title),
            content: AuthForm(),
          ));
}

void showAuthDialog(BuildContext context) {
  if (kIsWeb)
    _showMaterialDialog('Authentication', context);
  else if (Platform.isIOS)
    _showCupertinoDialog('Authentication', context);
  else
    _showMaterialDialog('Authentication', context);
}
