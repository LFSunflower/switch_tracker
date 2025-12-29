import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/session_controller.dart';
import '../../../controllers/version_controller.dart';
import '../../../core/utils/time_utils.dart';

class CurrentFrontCard extends StatelessWidget {
  final SessionController sessionController;

  const CurrentFrontCard({
    super.key,
    required this.sessionController,
  });

  @override
  Widget build(BuildContext context) {
    final activeSession = sessionController.activeSession;

    if (activeSession == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhuma sessão ativa',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Obter nomes dos alters pelos IDs
    final versionController = context.read<VersionController>();
    final alterNames = activeSession.alters
        .map((alterId) => versionController.getVersionById(alterId)?.name ?? 'Desconhecido')
        .join(', ');

    final duration = _calculateDuration(activeSession.startTime, activeSession.endTime);

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sessão Ativa',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              alterNames,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Intensidade: ${activeSession.intensity}/5',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tipo: ${activeSession.isCofront ? 'Co-front' : 'Simples'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Iniciado: ${TimeUtils.formatDateTime(activeSession.startTime)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Duração: $duration',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (activeSession.triggers.isNotEmpty) ...[
              const Text(
                'Gatilhos:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: activeSession.triggers
                    .map((trigger) => Chip(
                          label: Text(trigger),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showEndSessionDialog(context, sessionController);
                },
                icon: const Icon(Icons.check, size: 18),
                label: const Text('Finalizar Sessão'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEndSessionDialog(
    BuildContext context,
    SessionController sessionController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Sessão'),
        content: const Text('Tem certeza que deseja finalizar a sessão ativa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              sessionController.endActiveSession();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessão finalizada com sucesso')),
              );
            },
            child: const Text('Finalizar', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  String _calculateDuration(DateTime start, DateTime? end) {
    if (end == null) {
      final difference = DateTime.now().difference(start);
      final hours = difference.inHours;
      final minutes = difference.inMinutes.remainder(60);
      if (hours > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${minutes}m';
    }
    final difference = end.difference(start);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}