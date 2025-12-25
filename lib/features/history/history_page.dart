import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/session_controller.dart';
import '../../core/utils/logger.dart';
import 'widgets/history_list.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSessions();
    });
  }

  Future<void> _loadSessions() async {
    final controller = context.read<SessionController>();
    try {
      await controller.loadSessions();
    } catch (e) {
      AppLogger.error('Erro ao carregar histórico: $e', StackTrace.current);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Switches'),
        centerTitle: true,
      ),
      body: Consumer<SessionController>(
        builder: (context, controller, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.allSessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Nenhum switch registrado',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      DefaultTabController.of(context).animateTo(0);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Registrar Switch'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadSessions,
            child: HistoryList(sessions: controller.allSessions),
          );
        },
      ),
    );
  }
}
