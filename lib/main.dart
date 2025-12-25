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
      child: MaterialApp(
        title: 'Switch Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const AuthGate(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}