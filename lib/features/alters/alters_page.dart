import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import 'version_form_page.dart';
import 'widgets/version_card.dart';

// Widget stateful que representa a página de alters
class AltersPage extends StatefulWidget {
  const AltersPage({super.key});

  @override
  State<AltersPage> createState() => _AltersPageState();
}

// Estado da página de alters
class _AltersPageState extends State<AltersPage> {
  @override
  void initState() {
    super.initState();
    // Não carregar aqui, deixar que a HomePage carregue
  }

  // Função assíncrona para carregar versões do controller
  Future<void> _loadVersions() async {
    try {
      // Obtém a instância do VersionController do provider
      final controller = context.read<VersionController>();
      // Carrega as versões de forma assíncrona
      await controller.loadVersions();
    } catch (e) {
      // Registra o erro no logger
      AppLogger.error('Erro ao carregar alters: $e', StackTrace.current);
      // Verifica se o widget ainda está montado antes de mostrar mensagem
      if (mounted) {
        // Exibe uma snackbar com mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold principal com AppBar e body
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Alters'),
        centerTitle: true,
        // Ações na AppBar
        actions: [
          // Botão de adicionar novo alter
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navega para a página de criação de novo alter
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VersionFormPage(),
                ),
              );
            },
          ),
        ],
      ),
      // Constrói a UI consumindo o VersionController do provider
      body: Consumer<VersionController>(
        builder: (context, controller, _) {
          // Exibe indicador de carregamento enquanto os dados estão sendo carregados
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Exibe mensagem quando não há alters criados
          if (controller.allVersions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícone de pessoa vazio
                  const Icon(
                    Icons.person_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  // Texto informando que não há alters
                  const Text(
                    'Nenhum alter criado',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  // Botão para criar o primeiro alter
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navega para a página de criação
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VersionFormPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Criar Primeiro Alter'),
                  ),
                ],
              ),
            );
          }

          // Exibe lista de alters com capacidade de refresh
          return RefreshIndicator(
            onRefresh: _loadVersions,
            // Lista de alters com suporte a deslizar para recarregar
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              // Quantidade de itens na lista
              itemCount: controller.allVersions.length,
              // Constrói cada item da lista
              itemBuilder: (context, index) {
                // Obtém o alter no índice atual
                final alter = controller.allVersions[index];
                // Widget de card para exibir o alter
                return VersionCard(
                  version: alter,
                  // Callback para editar o alter
                  onEdit: () {
                    // Navega para a página de edição com o alter selecionado
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VersionFormPage(versionToEdit: alter),
                      ),
                    );
                  },
                  // Callback para deletar o alter
                  onDelete: () {
                    // Mostra diálogo de confirmação para deletar
                    _showDeleteDialog(context, alter.name, alter.id);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Função que exibe um diálogo de confirmação para deletar um alter
  void _showDeleteDialog(
    BuildContext context,
    String alterName,
    String alterId,
  ) {
    // Mostra um AlertDialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Alter'),
        // Mensagem de confirmação com o nome do alter
        content: Text('Tem certeza que deseja deletar "$alterName"?'),
        // Botões de ação
        actions: [
          // Botão para cancelar
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          // Botão para confirmar deleção
          TextButton(
            onPressed: () {
              // Fecha o diálogo
              Navigator.pop(context);
              // Deleta o alter chamando o método do controller
              context.read<VersionController>().deleteVersion(alterId);
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}