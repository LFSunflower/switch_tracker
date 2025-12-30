import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/user_controller.dart';
import '../../core/utils/logger.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar e Nome
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.withAlpha(200),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Consumer<UserController>(
                    builder: (context, userController, _) {
                      final profile = userController.currentUser;
                      final fullName = profile?['full_name'] as String? ?? 'Usuário';
                      final id = profile?['id'] as String? ?? '';
                      return Column(
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${id.isNotEmpty ? id.substring(0, 8) : ''}...',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Seção de Informações
            const Text(
              'Informações da Conta',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Nome Completo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nome',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer<UserController>(
                      builder: (context, userController, _) {
                        final fullName = userController.currentUser?['full_name'] as String? ?? 'Não informado';
                        return Text(
                          fullName,
                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Data de Criação
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Membro Desde',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer<UserController>(
                      builder: (context, userController, _) {
                        final createdAt = userController.currentUser?['created_at'];
                        final formattedDate = _formatCreatedDate(createdAt);
                        return Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Seção de Ações
            const Text(
              'Ações',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Botão Alterar Senha
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Vá para Configurações para alterar a senha'),
                    ),
                  );
                },
                icon: const Icon(Icons.lock),
                label: const Text('Alterar Senha'),
              ),
            ),
            const SizedBox(height: 12),

            // Botão Deletar Conta
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _showDeleteAccountDialog(context);
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Deletar Conta',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Informações
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sobre Switch Tracker',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Switch Tracker é um aplicativo para rastrear mudanças de alters em sistemas dissociativos.',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Versão: 1.0.0',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCreatedDate(dynamic createdAt) {
    if (createdAt == null) {
      return 'Não informado';
    }

    try {
      // Se for String, tentar fazer parsing
      if (createdAt is String) {
        final dateTime = DateTime.parse(createdAt);
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
      // Se for DateTime
      else if (createdAt is DateTime) {
        return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
      }
      return 'Não informado';
    } catch (e) {
      AppLogger.error('Erro ao formatar data: $e', StackTrace.current);
      return 'Não informado';
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Conta'),
        content: const Text(
          'Tem certeza que deseja deletar sua conta? Esta ação é irreversível e todos os seus dados serão perdidos.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Vá para Configurações para deletar a conta'),
                ),
              );
            },
            child: const Text(
              'Deletar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}