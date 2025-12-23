import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/user_controller.dart';
import '../app.dart';
import 'login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, _) {
        // Aguarde a inicialização do UserController
        if (!userController.isInitialized) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Se não houver usuário, mostra login
        if (!userController.isAuthenticated) {
          return const LoginPage();
        }

        // Se houver usuário, mostra o app principal
        return const SwitchTrackerApp();
      },
    );
  }
}
