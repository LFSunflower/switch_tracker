import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/user_controller.dart';
import 'auth_page.dart';
import '../features/home/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Aguardando conexão com a stream
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Verifica se há erro
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Erro: ${snapshot.error}'),
            ),
          );
        }

        // Obtém o estado de autenticação
        final session = snapshot.data?.session;
        final isAuthenticated = session != null;

        // Se autenticado, carrega dados do usuário
        if (isAuthenticated) {
          // Carrega os dados do usuário quando autenticado
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<UserController>().loadUserData();
          });
          return const HomePage();
        }

        // Se não autenticado, mostra página de login
        return const AuthPage();
      },
    );
  }
}
