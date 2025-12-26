import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import 'version_form_page.dart';
import 'widgets/version_card.dart';

class AltersPage extends StatefulWidget {
  const AltersPage({super.key});

  @override
  State<AltersPage> createState() => _AltersPageState();
}

class _AltersPageState extends State<AltersPage> {
  @override
  void initState() {
    super.initState();
    // Não carregar aqui, deixar que a HomePage carregue
  }

  Future<void> _loadVersions() async {
    try {
      final controller = context.read<VersionController>();
      await controller.loadVersions();
    } catch (e) {
      AppLogger.error('Erro ao carregar alters: $e', StackTrace.current);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Alters'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
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
      body: Consumer<VersionController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.allVersions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.person_outline,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum alter criado',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
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

          return RefreshIndicator(
            onRefresh: _loadVersions,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: controller.allVersions.length,
              itemBuilder: (context, index) {
                final alter = controller.allVersions[index];
                return VersionCard(
                  version: alter,
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VersionFormPage(versionToEdit: alter),
                      ),
                    );
                  },
                  onDelete: () {
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

  void _showDeleteDialog(
    BuildContext context,
    String alterName,
    String alterId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Alter'),
        content: Text('Tem certeza que deseja deletar "$alterName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<VersionController>().deleteVersion(alterId);
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}