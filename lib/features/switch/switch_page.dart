import 'package:flutter/material.dart';

class SwitchPage extends StatelessWidget {
  const SwitchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo switch')),
      body: const Center(
        child: Text('Seleção de versões virá aqui'),
      ),
    );
  }
}
