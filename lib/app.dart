import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth/auth_gate.dart';
import 'controllers/session_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/version_controller.dart';
import 'core/theme/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => VersionController()),
        ChangeNotifierProvider(create: (_) => SessionController()),
      ],
      child: Consumer<UserController>(
        builder: (context, userController, _) {
          return MaterialApp(
            title: 'Switch Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: userController.darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
            home: const AuthGate(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
