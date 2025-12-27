import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/session_controller.dart';
import '../../controllers/version_controller.dart';
import '../../core/utils/time_utils.dart';
import '../../data/models/front_session.dart';
import 'session_edit_page.dart';

class SessionDetailPage extends StatefulWidget {
  final FrontSession session;

  const SessionDetailPage({
    super.key,
    required this.session,
  });

  @override
  State<SessionDetailPage> createState() => _SessionDetailPageState();
}

class _SessionDetailPageState extends State<SessionDetailPage> {
  late FrontSession _session;

  @override
  void initState() {
    super.initState();
    _session = widget.session;
  }

  @override
  Widget build(BuildContext context) {
    final versionController = context.read<VersionController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Sessão'),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.edit, color: Colors.orange),
                    SizedBox(width: 12),
                    Text('Editar'),
                  ],
                ),
                onTap: () {
                  _navigateToEdit();
                },
              ),
              PopupMenuItem(
                child: const Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Deletar'),
                  ],
                ),
                onTap: () {
                  _showDeleteDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações Básicas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações Gerais',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      'Alters',
                      _session.alters
                          .map((alterId) =>
                              versionController.getVersionById(alterId)?.name ??
                              'Desconhecido')
                          .join(', '),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Tipo',
                      _session.isCofront ? 'Co-front' : 'Simples',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Intensidade',
                      '${_session.intensity}/5',
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      'Início',
                      TimeUtils.formatDateTime(_session.startTime),
                    ),
                    const SizedBox(height: 12),
                    if (_session.endTime != null)
                      _buildInfoRow(
                        'Fim',
                        TimeUtils.formatDateTime(_session.endTime!),
                      ),
                    if (_session.endTime != null) const SizedBox(height: 12),
                    if (_session.endTime != null)
                      _buildInfoRow(
                        'Duração',
                        _calculateDuration(
                          _session.startTime,
                          _session.endTime,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gatilhos
            if (_session.triggers.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gatilhos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        children: _session.triggers
                            .map(
                              (trigger) => Chip(label: Text(trigger)),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Notas
            if (_session.notes != null && _session.notes!.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(_session.notes!),
                    ],
                  ),
                ),
              ),

            // Informações dos Alters
            const SizedBox(height: 16),
            const Text(
              'Informações dos Alters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...(_session.alters.map((alterId) {
              final alter = versionController.getVersionById(alterId);
              if (alter == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _parseColor(alter.color),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                alter.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alter.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (alter.pronoun != null &&
                                  alter.pronoun!.isNotEmpty)
                                Text(
                                  alter.pronoun!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (alter.function != null &&
                          alter.function!.isNotEmpty) ...[
                        const Text(
                          'Função',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(alter.function!),
                        const SizedBox(height: 12),
                      ],
                      if (alter.likes != null && alter.likes!.isNotEmpty) ...[
                        const Text(
                          'O que gosta',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(alter.likes!),
                        const SizedBox(height: 12),
                      ],
                      if (alter.dislikes != null &&
                          alter.dislikes!.isNotEmpty) ...[
                        const Text(
                          'O que desgosta',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(alter.dislikes!),
                      ],
                    ],
                  ),
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  void _navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionEditPage(session: _session),
      ),
    ).then((result) {
      if (result == true) {
        setState(() {
          // Recarregar dados se necessário
        });
      }
    });
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Sessão'),
        content: const Text('Tem certeza que deseja deletar este registro?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<SessionController>().deleteSession(_session.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessão deletada com sucesso')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _calculateDuration(DateTime start, DateTime? end) {
    if (end == null) return 'Em andamento';
    final difference = end.difference(start);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse('FF${colorString.substring(1)}', radix: 16));
      } else if (colorString.startsWith('0x')) {
        return Color(int.parse(colorString));
      } else {
        return Color(int.parse('FF$colorString', radix: 16));
      }
    } catch (e) {
      return Colors.purple;
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}