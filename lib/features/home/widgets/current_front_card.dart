import 'package:flutter/material.dart';

import '/../controllers/session_controller.dart';
import '/../core/utils/time_utils.dart';

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
      return Card(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(
                Icons.swap_horiz,
                size: 48,
                color: Colors.grey[600],
              ),
              const SizedBox(height: 16),
              const Text(
                'Nenhuma sessão ativa',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Inicie um novo switch para começar',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[400]!, Colors.purple[600]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sessão Ativa',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activeSession.alters.isNotEmpty
                  ? activeSession.alters.join(', ')
                  : 'Sem identificação',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Duração',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      TimeUtils.formatDuration(
                        DateTime.now().difference(activeSession.startTime),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Intensidade',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${activeSession.intensity}/5',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    sessionController.endActiveSession();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Encerrar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}