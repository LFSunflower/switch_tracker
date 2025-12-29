import 'package:flutter/material.dart';
// Importa o pacote provider para gerenciamento de estado
import 'package:provider/provider.dart';

// Importa o controlador de usuário
import '../../controllers/user_controller.dart';
// Importa o utilitário de logging
import '../../core/utils/logger.dart';

// Define a classe ProfilePage como um StatelessWidget
class ProfilePage extends StatelessWidget {
  // Construtor da classe com chave opcional
  const ProfilePage({super.key});

  // Sobrescreve o método build para construir a interface
  @override
  Widget build(BuildContext context) {
    // Retorna um Scaffold como estrutura principal da página
    return Scaffold(
      // Define a barra de aplicativo
      appBar: AppBar(
        // Define o título da barra de aplicativo
        title: const Text('Meu Perfil'),
        // Centraliza o título
        centerTitle: true,
      ),
      // Define o corpo com scroll vertical
      body: SingleChildScrollView(
        // Define o espaçamento interno como 16
        padding: const EdgeInsets.all(16),
        // Define uma coluna como filho do scroll
        child: Column(
          // Alinha os filhos ao início horizontal
          crossAxisAlignment: CrossAxisAlignment.start,
          // Define a lista de widgets filhos
          children: [
            // Comentário indicando a seção de avatar e nome
            // Avatar e Nome
            // Define um Center como container para centralizar o avatar
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.2),
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
                      final user = userController.currentUser;
                      return Column(
                        children: [
                          Text(
                            user?.email ?? 'Usuário',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'ID: ${user?.id.substring(0, 8)}...',
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

            // Email
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Consumer<UserController>(
                      builder: (context, userController, _) {
                        return Text(
                          userController.currentUser?.email ?? 'Não informado',
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
                        final createdAt = userController.currentUser?.createdAt;
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
                      content: Text('Funcionalidade em desenvolvimento'),
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
                color: Colors.blue.withOpacity(0.1),
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
              // TODO: Implementar deleção de conta
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Funcionalidade em desenvolvimento'),
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