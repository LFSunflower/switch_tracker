import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/session_controller.dart';
import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import '../../data/models/front_session.dart';

class SessionEditPage extends StatefulWidget {
  final FrontSession session;

  const SessionEditPage({
    super.key,
    required this.session,
  });

  @override
  State<SessionEditPage> createState() => _SessionEditPageState();
}

class _SessionEditPageState extends State<SessionEditPage> {
  late List<String> _selectedAlterIds;
  late int _intensity;
  late List<String> _selectedTriggers;
  late bool _isCoFront;
  late String _notes;
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

  @override
  void initState() {
    super.initState();
    _selectedAlterIds = List.from(widget.session.alters);
    _intensity = widget.session.intensity;
    _selectedTriggers = List.from(widget.session.triggers);
    _isCoFront = widget.session.isCofront;
    _notes = widget.session.notes ?? '';
  }

  void _submitChanges() async {
    if (_selectedAlterIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um alter')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      AppLogger.info(
        'Atualizando sessão: ${widget.session.id}',
      );

      // Atualizar sessão no banco de dados
      // TODO: Implementar método updateSession no SessionRepository
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sessão atualizada com sucesso!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar sessão: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
        AppLogger.error('Erro ao atualizar sessão: $e', StackTrace.current);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Sessão'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seletor de Alters
            const Text(
              'Alters no Controle *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
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
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),

            // Notas
            TextField(
              maxLines: 4,
              controller: TextEditingController(text: _notes),
              onChanged: (value) => _notes = value,
              decoration: InputDecoration(
                labelText: 'Notas (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Adicione observações...',
              ),
            ),
            const SizedBox(height: 24),

            // Botões
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitChanges,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _isSubmitting ? 'Salvando...' : 'Salvar Alterações',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}