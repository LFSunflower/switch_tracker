import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/version_controller.dart';
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
    Future.microtask(() =>
        context.read<VersionController>().loadAllVersions());
  }

  Future<void> _navigateToForm() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const VersionFormPage(),
        fullscreenDialog: true,
      ),
    );

    if (result == true && mounted) {
      await context.read<VersionController>().loadAllVersions();
    }
  }

  Future<void> _navigateToEditForm(int index) async {
    final versionController = context.read<VersionController>();
    final versionToEdit = versionController.allVersions[index];

    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            VersionFormPage(versionToEdit: versionToEdit),
        fullscreenDialog: true,
      ),
    );

    if (result == true && mounted) {
      await versionController.loadAllVersions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VersionController>(
        builder: (context, versionController, _) {
          if (versionController.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (versionController.allVersions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Nenhum alter registrado',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Crie seu primeiro alter para começar',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _navigateToForm,
                      icon: const Icon(Icons.add),
                      label: const Text('Criar Alter'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Seus Alters',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${versionController.allVersions.length} alter(s)',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  FloatingActionButton.small(
                    onPressed: _navigateToForm,
                    tooltip: 'Criar novo alter',
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ...List.generate(
                versionController.allVersions.length,
                (index) => VersionCard(
                  version: versionController.allVersions[index],
                  onEdit: () => _navigateToEditForm(index),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}