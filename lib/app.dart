import 'package:flutter/material.dart';
import 'features/home/home_page.dart';
import 'features/history/history_page.dart';
import 'features/switch/switch_page.dart';
import 'core/theme/app_theme.dart';

class SwitchTrackerApp extends StatefulWidget {
  const SwitchTrackerApp({super.key});

  @override
  State<SwitchTrackerApp> createState() => _SwitchTrackerAppState();
}

class _SwitchTrackerAppState extends State<SwitchTrackerApp> {
  int _index = 0;

  final _pages = const [
    HomePage(),
    HistoryPage(),
    SwitchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Switch Tracker',
      theme: AppTheme.light,
      home: Scaffold(
        body: _pages[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
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
              icon: Icon(Icons.swap_horiz),
              label: 'Switch',
            ),
          ],
        ),
      ),
    );
  }
}
