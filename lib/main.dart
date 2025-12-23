import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/auth_gate.dart';
import 'controllers/session_controller.dart';
import 'controllers/user_controller.dart';
import 'data/repositories/session_repository.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hnmozwmncnlcatytctgq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhubW96d21uY25zY2F0eXRjdGdxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYyNjcyMTIsImV4cCI6MjA4MTg0MzIxMn0.sCcHBdCEcTqeXy21CvaORHeHyP4gheUCg4PWadocF-U',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // UserController deve ser o primeiro!
        ChangeNotifierProvider<UserController>(
          create: (_) => UserController(),
          lazy: false, // Inicializa imediatamente
        ),
        Provider<SessionRepository>(
          create: (_) => SessionRepository(),
          lazy: false,
        ),
        ChangeNotifierProxyProvider<UserController, SessionController>(
          create: (context) => SessionController(
            repository: context.read<SessionRepository>(),
          ),
          update: (context, userController, sessionController) {
            return sessionController ??
                SessionController(
                  repository: context.read<SessionRepository>(),
                );
          },
          lazy: false,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Switch Tracker',
        home: const AuthGate(),
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color.fromARGB(255, 103, 58, 183),
        ),
      ),
    );
  }
}