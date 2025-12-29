import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/session_controller.dart';
import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import '../home/widgets/current_front_card.dart';

class SwitchRecordPage extends StatefulWidget {
  const SwitchRecordPage({super.key});

  @override
  State<SwitchRecordPage> createState() => _SwitchRecordPageState();
}

class _SwitchRecordPageState extends State<SwitchRecordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          final sessionController = context.read<SessionController>();
          await sessionController.loadSessions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card da sessão atual
              Consumer<SessionController>(
                builder: (context, sessionController, _) {
                  return CurrentFrontCard(
                    sessionController: sessionController,
                  );
                },
              ),
              const SizedBox(height: 24),

              // Informações sobre o Alter Ativo
              Consumer2<SessionController, VersionController>(
                builder: (context, sessionController, versionController, _) {
                  final activeSession = sessionController.activeSession;
                  if (activeSession == null || activeSession.alters.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  // Buscar informações dos alters ativos
                  final alterInfos = activeSession.alters
                      .map((alterId) => versionController.getVersionById(alterId))
                      .whereType<dynamic>()
                      .toList();

                  if (alterInfos.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Informações do Alter',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...alterInfos.map((alter) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nome e pronome
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          alter.name,
                                          style: const TextStyle(
                                            fontSize: 16,
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
                                const SizedBox(height: 16),

                                // Descrição
                                if (alter.description != null &&
                                    alter.description!.isNotEmpty) ...[
                                  const Text(
                                    'Descrição',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(alter.description!),
                                  const SizedBox(height: 12),
                                ],

                                // Função
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

                                // O que gosta
                                if (alter.likes != null &&
                                    alter.likes!.isNotEmpty) ...[
                                  const Text(
                                    'O que gosta 💚',
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

                                // O que desgosta
                                if (alter.dislikes != null &&
                                    alter.dislikes!.isNotEmpty) ...[
                                  const Text(
                                    'O que desgosta 💔',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(alter.dislikes!),
                                  const SizedBox(height: 12),
                                ],

                                // Instruções de Segurança
                                if (alter.safetyInstructions != null &&
                                    alter.safetyInstructions!.isNotEmpty) ...[
                                  const Text(
                                    '⚠️ Instruções de Segurança',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      border: Border.all(color: Colors.red),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      alter.safetyInstructions!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _SwitchFormDialog(),
          );
        },
        tooltip: 'Novo Switch',
        child: const Icon(Icons.add),
      ),
    );
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
}

class _SwitchFormDialog extends StatefulWidget {
  const _SwitchFormDialog();

  @override
  State<_SwitchFormDialog> createState() => _SwitchFormDialogState();
}

class _SwitchFormDialogState extends State<_SwitchFormDialog> {
  final List<String> _selectedAlterIds = [];
  int _intensity = 3;
  final List<String> _selectedTriggers = [];
  bool _isCoFront = false;
  String _notes = '';
  bool _isSubmitting = false;

  final List<String> _availableTriggers = [
    'Stress',
    'Trauma',
    'Ansiedade',
    'Atividade Específica',
    'Interação Social',
    'Mudança de Ambiente',
    'Cansaço',
    'Ruídos Altos',
    'Luz Intensa',
    'Contato Físico',
    'Conversas Difíceis',
    'Horários Específicos',
  ];

  void _submitSwitch() async {
    final sessionController = context.read<SessionController>();

    if (_selectedAlterIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um alter')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      AppLogger.info(
        'Iniciando switch com alters: $_selectedAlterIds, intensity: $_intensity',
      );

      await sessionController.startNewSession(
        alterIds: _selectedAlterIds,
        intensity: _intensity,
        triggers: _selectedTriggers,
        notes: _notes.isEmpty ? null : _notes,
        isCoFront: _isCoFront,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Switch registrado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar switch: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
        AppLogger.error('Erro ao registrar switch: $e', StackTrace.current);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registrar Novo Switch',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Seletor de Alters
              const Text(
                'Qual alter está no controle? *',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Consumer<VersionController>(
                builder: (context, versionController, _) {
                  final versions = versionController.allVersions;
                  if (versions.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Nenhum alter disponível'),
                    );
                  }

                  return Wrap(
                    spacing: 8,
                    children: versions
                        .map(
                          (version) => FilterChip(
                            selected: _selectedAlterIds.contains(version.id),
                            label: Text(version.name),
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  _selectedAlterIds.add(version.id);
                                } else {
                                  _selectedAlterIds.remove(version.id);
                                }
                              });
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              ),
              const SizedBox(height: 16),

              // Co-front
              CheckboxListTile(
                title: const Text('É um co-front?'),
                subtitle: const Text('Mais de um alter no controle'),
                value: _isCoFront,
                onChanged: (value) {
                  setState(() => _isCoFront = value ?? false);
                },
              ),
              const SizedBox(height: 16),

              // Intensidade
              Text(
                'Intensidade: $_intensity/5',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Slider(
                value: _intensity.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                onChanged: (value) {
                  setState(() => _intensity = value.toInt());
                },
              ),
              const SizedBox(height: 16),

              // Seletor de Gatilhos
              const Text(
                'Gatilhos (opcional)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableTriggers
                    .map(
                      (trigger) => FilterChip(
                        selected: _selectedTriggers.contains(trigger),
                        label: Text(trigger),
                        onSelected: (isSelected) {
                          setState(() {
                            if (isSelected) {
                              _selectedTriggers.add(trigger);
                            } else {
                              _selectedTriggers.remove(trigger);
                            }
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),

              // Notas
              TextField(
                maxLines: 3,
                onChanged: (value) => _notes = value,
                decoration: InputDecoration(
                  labelText: 'Notas (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: 'Adicione observações...',
                ),
              ),
              const SizedBox(height: 16),

              // Botões
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitSwitch,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(
                      _isSubmitting ? 'Registrando...' : 'Registrar',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}