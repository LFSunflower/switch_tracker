import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/user_controller.dart';
import '../features/home/home_page.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _isLoginPage = true;

  void _switchToRegister() {
    setState(() => _isLoginPage = false);
  }

  void _switchToLogin() {
    setState(() => _isLoginPage = true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, _) {
        // Se está autenticado, mostrar HomePage
        if (userController.isAuthenticated) {
          return const HomePage();
        }

        // Caso contrário, mostrar LoginPage ou RegisterPage
        return _isLoginPage
            ? LoginPage(onSwitchToRegister: _switchToRegister)
            : RegisterPage(onSwitchToLogin: _switchToLogin);
      },
    );
  }
}
