import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/version_controller.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VersionController>().loadVersions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VersionController>(
      builder: (context, versionController, _) {
        final versions = versionController.allVersions;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: versions.length + 1, // +1 para o botão de adicionar
          itemBuilder: (context, index) {
            // Primeiro item é o botão de adicionar
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const VersionFormPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Novo Alter'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              );
            }

            // Restante dos items são os alters
            final versionIndex = index - 1;
            final version = versions[versionIndex];

            return VersionCard(
              version: version,
              onEdit: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VersionFormPage(versionToEdit: version),
                  ),
                );
              },
              onDelete: () {
                _showDeleteDialog(context, version.id, versionController);
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    String versionId,
    VersionController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Alter'),
        content: const Text('Tem certeza que deseja deletar este alter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteVersion(versionId);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Alter deletado com sucesso')),
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