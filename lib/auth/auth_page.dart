import 'package:flutter/material.dart';

import 'login_page.dart';
import 'register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLogin = true;

  @override
  Widget build(BuildContext context) {
    return _isLogin
        ? LoginPage(
            onSwitchToRegister: () {
              setState(() => _isLogin = false);
            },
          )
        : RegisterPage(
            onSwitchToLogin: () {
              setState(() => _isLogin = true);
            },
          );
  }
}