import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/session_controller.dart';
import '../../data/repositories/version_repository.dart';
import '../../data/models/version.dart';
import 'widgets/version_selector.dart';
import 'widgets/intensity_slider.dart';
import 'widgets/trigger_selector.dart';

class SwitchRecordPage extends StatefulWidget {
  const SwitchRecordPage({super.key});

  @override
  State<SwitchRecordPage> createState() => _SwitchRecordPageState();
}

class _SwitchRecordPageState extends State<SwitchRecordPage> {
  late SessionController _sessionController;
  late VersionRepository _versionRepository;

  List<Version> _allVersions = [];
  List<String> _selectedAlterIds = [];
  int _intensity = 3;
  List<String> _selectedTriggers = [];
  bool _isCoFront = false;
  String _notes = '';
  bool _isLoading = false;
  bool _isLoadingVersions = true;

  @override
  void initState() {
    super.initState();
    _sessionController = context.read<SessionController>();
    _versionRepository = VersionRepository();
    _loadVersions();
  }

  Future<void> _loadVersions() async {
    try {
      final versions = await _versionRepository.getAllVersions();
      setState(() {
        _allVersions = versions;
        _isLoadingVersions = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingVersions = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar alters: $e')),
        );
      }
    }
  }

  Future<void> _submitSwitch() async {
    if (_selectedAlterIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um alter')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _sessionController.startNewSession(
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
          SnackBar(content: Text('Erro ao registrar switch: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Switch'),
        centerTitle: true,
      ),
      body: _isLoadingVersions
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          VersionSelector(
                            versions: _allVersions,
                            selectedIds: _selectedAlterIds,
                            onSelectionChanged: (selectedIds) {
                              setState(() => _selectedAlterIds = selectedIds);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Co-Front toggle
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

                  // Intensity Slider
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

                  // Trigger Selector
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
                              setState(() => _selectedTriggers = selectedTriggers);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notes
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

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _submitSwitch,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(
                        _isLoading ? 'Registrando...' : 'Registrar Switch',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}