import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/auth_gate.dart';
import 'controllers/session_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/version_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Supabase.initialize(
      url: 'https://hnmozwmncnlcatytctgq.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhubW96d21uY25sY2F0eXRjdGdxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYyNjcyMTIsImV4cCI6MjA4MTg0MzIxMn0.sCcHBdCEcTqeXy21CvaORHeHyP4gheUCg4PWadocF-U',
    );
    AppLogger.info('Supabase inicializado com sucesso');
  } catch (e) {
    AppLogger.error('Erro ao inicializar Supabase: $e', StackTrace.current);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (_) => VersionController(),
        ),
        ChangeNotifierProvider(
          create: (_) => SessionController(),
        ),
      ],
      child: Consumer3<UserController, VersionController, SessionController>(
        builder: (context, userController, versionController, sessionController, _) {
          final activeSession = sessionController.activeSession;
          final darkMode = userController.darkModeEnabled;

          Color themeSeedColor = AppTheme.primaryColor;

          // Lógica de Tema Dinâmico
          if (activeSession != null) {
            // Regra de Alerta: Co-front + Intensidade >= 4
            if (activeSession.isCofront && activeSession.intensity >= 4) {
              themeSeedColor = Colors.red;
            } else if (activeSession.alters.isNotEmpty) {
              // Cor do primeiro alter em fronting
              final firstAlter = versionController.getVersionById(activeSession.alters.first);
              if (firstAlter != null) {
                themeSeedColor = _parseColor(firstAlter.color);
              }
            }
          }

          return MaterialApp(
            title: 'Switch Tracker',
            theme: AppTheme.getDynamicTheme(themeSeedColor, Brightness.light),
            darkTheme: AppTheme.getDynamicTheme(themeSeedColor, Brightness.dark),
            themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
            home: const AuthGate(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return AppTheme.primaryColor;
    }
  }
}