import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/session_controller.dart';
import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import '../alters/alters_page.dart';
import '../history/history_page.dart';
import '../switch/switch_record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late VersionController _versionController;
  late SessionController _sessionController;

  final List<Widget> _pages = const [
    SwitchRecordPage(),
    AltersPage(),
    HistoryPage(),
  ];

  @override
  void initState() {
    super.initState();
    _versionController = context.read<VersionController>();
    _sessionController = context.read<SessionController>();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      AppLogger.info('Carregando dados iniciais...');
      await _versionController.loadVersions();
      await _sessionController.loadSessions();
      AppLogger.info('Dados iniciais carregados com sucesso');
    } catch (e) {
      AppLogger.error('Erro ao carregar dados iniciais: $e', StackTrace.current);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Tracker'),
        centerTitle: true,
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Switch',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Alters',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),
        ],
      ),
    );
  }
}
