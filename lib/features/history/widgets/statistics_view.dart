import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/session_controller.dart';
import '../../../controllers/version_controller.dart';
import '../../../data/models/front_session.dart';
import '../../../data/models/version.dart';

class StatisticsView extends StatelessWidget {
  const StatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionController = context.watch<SessionController>();
    final versionController = context.watch<VersionController>();
    final sessions = sessionController.filteredSessions;
    final versions = versionController.allVersions;

    if (sessions.isEmpty) {
      return const Center(child: Text('Sem dados para estatísticas no período selecionado.'));
    }

    // Calcular tempo total por alter
    final Map<String, Duration> frontingTime = {};
    final Map<String, int> triggerCount = {};
    int totalSwitches = sessions.length;

    for (var session in sessions) {
      if (session.endTime != null) {
        final duration = session.endTime!.difference(session.startTime);
        for (var alterId in session.alters) {
          frontingTime[alterId] = (frontingTime[alterId] ?? Duration.zero) + duration;
        }
      }
      for (var trigger in session.triggers) {
        triggerCount[trigger] = (triggerCount[trigger] ?? 0) + 1;
      }
    }

    // Ordenar fronting time
    final sortedFronting = frontingTime.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Ordenar gatilhos
    final sortedTriggers = triggerCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCard(
            'Resumo do Período',
            Column(
              children: [
                _buildStatRow('Total de Switches', totalSwitches.toString()),
                _buildStatRow('Média de Switches/Dia', _calculateAverageSwitches(sessions).toStringAsFixed(1)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text('Tempo de Fronting (Top 5)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...sortedFronting.take(5).map((entry) {
            final version = versionController.getVersionById(entry.key);
            final name = version?.name ?? 'Desconhecido';
            final color = _parseColor(version?.color);
            final totalMinutes = entry.value.inMinutes;
            final hours = totalMinutes ~/ 60;
            final minutes = totalMinutes % 60;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name),
                      Text('${hours}h ${minutes}m'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: entry.value.inSeconds / sortedFronting.first.value.inSeconds,
                    backgroundColor: Colors.grey[200],
                    color: color,
                    minHeight: 8,
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
          const Text('Principais Gatilhos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          if (sortedTriggers.isEmpty)
            const Text('Nenhum gatilho registrado.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sortedTriggers.take(10).map((entry) {
                return Chip(
                  label: Text('${entry.key} (${entry.value})'),
                    backgroundColor: Colors.deepOrangeAccent.withAlpha(600),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, Widget content) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const Divider(),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  double _calculateAverageSwitches(List<FrontSession> sessions) {
    if (sessions.isEmpty) return 0;
    final first = sessions.last.startTime;
    final last = sessions.first.startTime;
    final days = last.difference(first).inDays + 1;
    return sessions.length / days;
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) return Colors.blue;
    try {
      final hex = hexColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      return Colors.blue;
    }
  }
}
