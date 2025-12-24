import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/user_controller.dart';
import 'features/alters/alters_page.dart';
import 'features/home/home_page.dart';
import 'features/history/history_page.dart';
import 'features/switch/switch_record_page.dart';

class SwitchTrackerApp extends StatefulWidget {
  const SwitchTrackerApp({super.key});

  @override
  State<SwitchTrackerApp> createState() => _SwitchTrackerAppState();
}

class _SwitchTrackerAppState extends State<SwitchTrackerApp> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    HistoryPage(),
    AltersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Tracker'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showProfileMenu(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.circle),
            label: 'Status',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: 'Histórico',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Alters',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToSwitchRecord(context),
        tooltip: 'Registrar novo switch',
        child: const Icon(Icons.swap_horiz),
      ),
    );
  }

  void _navigateToSwitchRecord(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SwitchRecordPage(),
        fullscreenDialog: true,
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (buildContext) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(buildContext);
              // TODO: Navegar para página de perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(buildContext);
              // TODO: Navegar para página de configurações
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            onTap: () async {
              Navigator.pop(buildContext);
              if (mounted) {
                await context.read<UserController>().logout();
              }
            },
          ),
        ],
      ),
    );
  }
}
