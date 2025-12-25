import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/logger.dart';
import '../features/home/home_page.dart';
import 'auth_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    super.initState();
    // Adicionar listener para mudanças de estado de autenticação
    _authStateSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final session = data.session;

      AppLogger.info('Auth state changed: $event, User: ${session?.user.email}');
    });
  }

  @override
  void dispose() {
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Carregando
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Erro
        if (snapshot.hasError) {
          AppLogger.error('Erro ao verificar autenticação: ${snapshot.error}');
          return Scaffold(
            body: Center(
              child: Text('Erro: ${snapshot.error}'),
            ),
          );
        }

        // Verificar se há sessão ativa
        final session = snapshot.data?.session;

        if (session != null && session.user.emailConfirmedAt != null) {
          AppLogger.info('Usuário autenticado: ${session.user.email}');
          return const HomePage();
        } else {
          AppLogger.info('Usuário não autenticado');
          return const AuthPage();
        }
      },
    );
  }
}
