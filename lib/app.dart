import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/user_controller.dart';
import 'features/home/home_page.dart';
import 'features/history/history_page.dart';
import 'features/alters/alters_page.dart';
import 'features/switch/switch_record_page.dart';

class SwitchTrackerApp extends StatefulWidget {
  const SwitchTrackerApp({super.key});

  @override
  State<SwitchTrackerApp> createState() => _SwitchTrackerAppState();
}

class _SwitchTrackerAppState extends State<SwitchTrackerApp> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = const [
      HomePage(),
      HistoryPage(),
      AltersPage(),
    ];
  }

  void _navigateToSwitchRecord(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SwitchRecordPage(),
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navegar para página de perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pop(context);
              // TODO: Navegar para página de configurações
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sair'),
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: () async {
              Navigator.pop(context);
              await context.read<UserController>().logout();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Switch Tracker'),
        centerTitle: true,
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
}
