import 'package:flutter/material.dart';
import '../../../data/models/front_session.dart';
import '../../../core/utils/time_utils.dart';

class HistoryList extends StatelessWidget {
  final List<FrontSession> sessions;

  const HistoryList({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: sessions
          .map(
            (session) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Text(
                  session.alterIds.join(', '),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Início: ${TimeUtils.formatDateTime(session.startTime)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    if (session.endTime != null)
                      Text(
                        'Fim: ${TimeUtils.formatDateTime(session.endTime!)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    Text(
                      'Duração: ${session.durationFormatted}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (session.triggers.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Wrap(
                          spacing: 4,
                          children: session.triggers
                              .map(
                                (trigger) => Chip(
                                  label: Text(trigger),
                                  labelStyle: const TextStyle(fontSize: 10),
                                  padding: EdgeInsets.zero,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getIntensityColor(session.intensity),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Nv. ${session.intensity}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (session.isCoFront)
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Icon(
                          Icons.people,
                          size: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Color _getIntensityColor(int intensity) {
    switch (intensity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen.shade700;
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