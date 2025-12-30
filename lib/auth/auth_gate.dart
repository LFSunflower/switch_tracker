import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/user_controller.dart';
import '../controllers/version_controller.dart';
import '../controllers/session_controller.dart';
import 'auth_page.dart';
import '../features/home/home_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _loadUserData() async {
    final userController = context.read<UserController>();
    if (userController.isAuthenticated) {
      await userController.loadUserData();
      if (mounted) {
        context.read<VersionController>().loadVersions();
        context.read<SessionController>().loadSessions();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, _) {
        if (userController.isAuthenticated) {
          return const HomePage();
        } else {
          return const AuthPage();
        }
      },
    );
  }
}
