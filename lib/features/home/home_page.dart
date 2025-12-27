import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/session_controller.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import '../alters/alters_page.dart';
import '../history/history_page.dart';
import '../profile/profile_page.dart';
import '../settings/settings_page.dart';
import '../switch/switch_record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    SwitchRecordPage(),
    AltersPage(),
    HistoryPage(),
  ];

  final List<String> _titles = [
    'Switch Tracker',
    'Meus Alters',
    'Histórico',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    try {
      final versionController = context.read<VersionController>();
      final sessionController = context.read<SessionController>();

      AppLogger.info('Carregando dados iniciais...');

      await versionController.loadVersions();
      await sessionController.loadSessions();

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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Tem certeza que deseja sair?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<UserController>().logout();
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'profile',
                child: const Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue),
                    SizedBox(width: 12),
                    Text('Perfil'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: const Row(
                  children: [
                    Icon(Icons.settings, color: Colors.grey),
                    SizedBox(width: 12),
                    Text('Configurações'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              const PopupMenuDivider(),
              PopupMenuItem<String>(
                value: 'logout',
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Sair', style: TextStyle(color: Colors.red)),
                  ],
                ),
                onTap: _showLogoutDialog,
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
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
