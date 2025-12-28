import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/session_controller.dart';
import '../../../controllers/version_controller.dart';
import '../../../core/utils/time_utils.dart';
import '../../session_detail/session_detail_page.dart';
import '../../../data/models/front_session.dart';

class HistoryList extends StatelessWidget {
  final List<FrontSession> sessions;

  const HistoryList({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return const Center(
        child: Text('Nenhum registro de sessão'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return _SessionCard(session: session);
      },
    );
  }
}

class _SessionCard extends StatelessWidget {
  final FrontSession session;

  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final versionController = context.read<VersionController>();
    final alterNames = session.alterNames.isNotEmpty
        ? session.alterNames.join(', ')
        : session.alters.map((alterId) => 'ID: $alterId').join(', ');

    final duration = _calculateDuration(session.startTime, session.endTime);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getIntensityColor(session.intensity),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              session.intensity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          alterNames,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Início: ${TimeUtils.formatDateTime(session.startTime)}',
              style: const TextStyle(fontSize: 12),
            ),
            if (session.endTime != null)
              Text(
                'Duração: $duration',
                style: const TextStyle(fontSize: 12),
              ),
            if (session.isCofront)
              const Text(
                'Co-front',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text('Detalhes'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SessionDetailPage(session: session),
                  ),
                );
              },
            ),
            PopupMenuItem(
              child: const Text('Editar'),
              onTap: () {
                _showEditDialog(context);
              },
            ),
            PopupMenuItem(
              child: const Text(
                'Deletar',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                _showDeleteDialog(context);
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionDetailPage(session: session),
            ),
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Sessão'),
        content: const Text('Funcionalidade de edição em breve'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Sessão'),
        content: const Text('Tem certeza que deseja deletar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SessionController>().deleteSession(session.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessão deletada com sucesso')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _calculateDuration(DateTime start, DateTime? end) {
    if (end == null) return 'Em andamento';
    final difference = end.difference(start);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}