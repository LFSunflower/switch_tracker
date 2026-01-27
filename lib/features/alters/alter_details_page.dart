import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/version_controller.dart';
import '../../data/models/version.dart';
import 'version_form_page.dart';

class AlterDetailsPage extends StatelessWidget {
  final Version alter;

  const AlterDetailsPage({super.key, required this.alter});

  @override
  Widget build(BuildContext context) {
    final color = _parseColor(alter.color);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            backgroundColor: color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                alter.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black45, blurRadius: 8)],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withOpacity(0.7),
                      color,
                    ],
                  ),
                ),
                child: Center(
                  child: Hero(
                    tag: 'alter-avatar-${alter.id}',
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white24,
                      child: Text(
                        alter.name[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VersionFormPage(versionToEdit: alter),
                    ),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (alter.pronoun != null && alter.pronoun!.isNotEmpty)
                    _buildInfoSection(
                      context,
                      'Pronomes',
                      alter.pronoun!,
                      Icons.person_outline,
                    ),
                  if (alter.function != null && alter.function!.isNotEmpty)
                    _buildInfoSection(
                      context,
                      'Função no Sistema',
                      alter.function!,
                      Icons.assignment_ind_outlined,
                    ),
                  if (alter.description != null && alter.description!.isNotEmpty)
                    _buildInfoSection(
                      context,
                      'Descrição',
                      alter.description!,
                      Icons.description_outlined,
                    ),
                  if (alter.likes != null && alter.likes!.isNotEmpty)
                    _buildInfoSection(
                      context,
                      'Gosta de',
                      alter.likes!,
                      Icons.thumb_up_outlined,
                      color: Colors.green,
                    ),
                  if (alter.dislikes != null && alter.dislikes!.isNotEmpty)
                    _buildInfoSection(
                      context,
                      'Não gosta de',
                      alter.dislikes!,
                      Icons.thumb_down_outlined,
                      color: Colors.red,
                    ),
                  if (alter.safetyInstructions != null &&
                      alter.safetyInstructions!.isNotEmpty)
                    _buildInfoSection(
                      context,
                      'Instruções de Segurança',
                      alter.safetyInstructions!,
                      Icons.warning_amber_rounded,
                      color: Colors.orange,
                      isImportant: true,
                    ),
                  const SizedBox(height: 24),
                  _buildStatusCard(context),
                  const SizedBox(height: 80), // Espaço para o FAB se houver
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context,
    String title,
    String content,
    IconData icon, {
    Color? color,
    bool isImportant = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: color ?? Theme.of(context).primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: color ?? Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isImportant
                  ? (color ?? Colors.orange).withOpacity(0.1)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
              border: isImportant
                  ? Border.all(color: (color ?? Colors.orange).withOpacity(0.5))
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      elevation: 0,
      color: alter.isActive
          ? Colors.green.withOpacity(0.1)
          : Colors.grey.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: alter.isActive ? Colors.green : Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              alter.isActive ? Icons.check_circle : Icons.pause_circle,
              color: alter.isActive ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 12),
            Text(
              alter.isActive ? 'Alter Ativo no Sistema' : 'Alter Inativo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: alter.isActive ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse('FF${colorString.substring(1)}', radix: 16));
      } else if (colorString.startsWith('0x')) {
        return Color(int.parse(colorString));
      } else {
        return Color(int.parse('FF$colorString', radix: 16));
      }
    } catch (e) {
      return Colors.purple;
    }
  }
}
