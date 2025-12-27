import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _timeFormat = '24h';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Notificações
            _buildSection(
              title: 'Notificações',
              children: [
                SwitchListTile(
                  title: const Text('Habilitar Notificações'),
                  subtitle: const Text(
                    'Receber alertas de switches e lembretes',
                  ),
                  value: _notificationsEnabled,
                  onChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
                if (_notificationsEnabled) ...[
                  const Divider(),
                  CheckboxListTile(
                    title: const Text('Switch Iniciado'),
                    subtitle: const Text('Notificar quando um novo switch começar'),
                    value: true,
                    onChanged: (value) {},
                  ),
                  CheckboxListTile(
                    title: const Text('Lembretes de Atividade'),
                    subtitle:
                        const Text('Lembretes periódicos para logar atividades'),
                    value: true,
                    onChanged: (value) {},
                  ),
                ],
              ],
            ),

            // Aparência
            _buildSection(
              title: 'Aparência',
              children: [
                SwitchListTile(
                  title: const Text('Modo Escuro'),
                  subtitle: const Text('Usar tema escuro em toda a aplicação'),
                  value: _darkModeEnabled,
                  onChanged: (value) {
                    setState(() => _darkModeEnabled = value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Formato de Hora'),
                  subtitle: Text(_timeFormat),
                  onTap: () {
                    _showTimeFormatDialog();
                  },
                ),
              ],
            ),

            // Dados
            _buildSection(
              title: 'Dados',
              children: [
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: const Text('Backup de Dados'),
                  subtitle: const Text('Fazer backup de seus dados'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Exportar Dados'),
                  subtitle: const Text('Exportar seus dados em JSON'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Privacidade
            _buildSection(
              title: 'Privacidade e Segurança',
              children: [
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Política de Privacidade'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Termos de Serviço'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Funcionalidade em desenvolvimento'),
                      ),
                    );
                  },
                ),
              ],
            ),

            // Sobre
            _buildSection(
              title: 'Sobre',
              children: [
                ListTile(
                  title: const Text('Versão da Aplicação'),
                  subtitle: const Text('1.0.0'),
                ),
                const Divider(),
                ListTile(
                  title: const Text('Verificar Atualizações'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Você está na versão mais recente'),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  void _showTimeFormatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Formato de Hora'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('24 horas'),
              value: '24h',
              groupValue: _timeFormat,
              onChanged: (value) {
                setState(() => _timeFormat = value ?? '24h');
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('12 horas (AM/PM)'),
              value: '12h',
              groupValue: _timeFormat,
              onChanged: (value) {
                setState(() => _timeFormat = value ?? '24h');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}