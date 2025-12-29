import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/version_controller.dart';
import '../../../data/models/front_session.dart';
import '../../session_detail/session_detail_page.dart';

class HistoryList extends StatelessWidget {
  final List<FrontSession> sessions;

  const HistoryList({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum histórico de sessões',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        return _HistoryCard(session: sessions[index]);
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final FrontSession session;

  const _HistoryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final versionController = context.read<VersionController>();
    final alterNames = session.alters
        .map((alterId) => versionController.getVersionById(alterId)?.name ?? 'Desconhecido')
        .join(', ');

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
        subtitle: Text(
          '${session.isCofront ? 'Co-front' : 'Simples'} • $duration',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.chevron_right),
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
        return Colors.orange;
      case 4:
        return Colors.deepOrange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}