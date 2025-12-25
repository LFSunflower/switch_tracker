import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/session_controller.dart';
import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import '../../data/models/version.dart';
import '../home/widgets/current_front_card.dart';
import 'widgets/intensity_slider.dart';
import 'widgets/trigger_selector.dart';
import 'widgets/version_selector.dart';

class SwitchRecordPage extends StatefulWidget {
  const SwitchRecordPage({super.key});

  @override
  State<SwitchRecordPage> createState() => _SwitchRecordPageState();
}

class _SwitchRecordPageState extends State<SwitchRecordPage> {
  List<String> _selectedAlterIds = [];
  int _intensity = 3;
  List<String> _selectedTriggers = [];
  bool _isCoFront = false;
  String _notes = '';
  bool _isSubmitting = false;

  void _submitSwitch(BuildContext context) async {
    final sessionController = context.read<SessionController>();
    final versionController = context.read<VersionController>();

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

        // Resetar formulário
        setState(() {
          _selectedAlterIds = [];
          _intensity = 3;
          _selectedTriggers = [];
          _isCoFront = false;
          _notes = '';
        });
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
    return RefreshIndicator(
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

            // Formulário de novo switch
            const Text(
              'Registrar Novo Switch',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Seletor de Alters
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Qual alter está no controle?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Consumer<VersionController>(
                      builder: (context, versionController, _) {
                        final versions = versionController.allVersions;
                        if (versions.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.person_outline,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Nenhum alter disponível',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      DefaultTabController.of(context)
                                          .animateTo(1);
                                    },
                                    child: const Text('Criar Alter'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return VersionSelector(
                          versions: versions,
                          selectedIds: _selectedAlterIds,
                          onSelectionChanged: (selectedIds) {
                            setState(
                              () => _selectedAlterIds = selectedIds,
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Co-front checkbox
            Card(
              child: CheckboxListTile(
                title: const Text('É um co-front?'),
                subtitle: const Text('Mais de um alter no controle'),
                value: _isCoFront,
                onChanged: (value) {
                  setState(() => _isCoFront = value ?? false);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Intensidade
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Intensidade do fronting',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    IntensitySlider(
                      value: _intensity,
                      onChanged: (value) {
                        setState(() => _intensity = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Gatilhos
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Gatilhos (opcional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TriggerSelector(
                      selectedTriggers: _selectedTriggers,
                      onSelectionChanged: (selectedTriggers) {
                        setState(
                          () => _selectedTriggers = selectedTriggers,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Notas
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notas (opcional)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      maxLines: 4,
                      onChanged: (value) => _notes = value,
                      decoration: InputDecoration(
                        hintText:
                            'Adicione observações sobre este switch...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Botão de envio
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSubmitting ? null : () => _submitSwitch(context),
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.check),
                label: Text(
                  _isSubmitting ? 'Registrando...' : 'Registrar Switch',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}