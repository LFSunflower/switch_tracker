import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import '../../data/models/version.dart';

class VersionFormPage extends StatefulWidget {
  final Version? versionToEdit;

  const VersionFormPage({
    super.key,
    this.versionToEdit,
  });

  @override
  State<VersionFormPage> createState() => _VersionFormPageState();
}

class _VersionFormPageState extends State<VersionFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _pronounController;
  late TextEditingController _descriptionController;
  late VersionController _versionController;

  Color _selectedColor = Colors.purple;
  bool _isSubmitting = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _versionController = context.read<VersionController>();
    _nameController = TextEditingController(text: widget.versionToEdit?.name);
    _pronounController =
        TextEditingController(text: widget.versionToEdit?.pronoun ?? '');
    _descriptionController =
        TextEditingController(text: widget.versionToEdit?.description ?? '');

    if (widget.versionToEdit != null) {
      try {
        final hexColor = widget.versionToEdit!.color;
        if (hexColor.startsWith('0x')) {
          _selectedColor = Color(int.parse(hexColor));
        } else if (hexColor.startsWith('#')) {
          _selectedColor =
              Color(int.parse('0xFF${hexColor.substring(1)}'));
        } else {
          _selectedColor = Color(int.parse('0xFF$hexColor'));
        }
      } catch (e) {
        AppLogger.warning('Erro ao parsear cor: $e');
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pronounController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String _colorToHexString(Color color) {
    return '0x${color.value.toRadixString(16).padLeft(8, '0')}';
  }

  Color _hexStringToColor(String hex) {
    try {
      if (hex.startsWith('0x')) {
        return Color(int.parse(hex));
      } else if (hex.startsWith('#')) {
        return Color(int.parse('0xFF${hex.substring(1)}'));
      } else {
        return Color(int.parse('0xFF$hex'));
      }
    } catch (e) {
      AppLogger.warning('Erro ao parsear cor: $e');
      return Colors.purple;
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final colorHex = _colorToHexString(_selectedColor);
      AppLogger.info('Submetendo formulário com cor: $colorHex');

      if (widget.versionToEdit != null) {
        // Editar
        await _versionController.updateVersion(
          id: widget.versionToEdit!.id,
          name: _nameController.text.trim(),
          pronoun: _pronounController.text.trim().isEmpty
              ? null
              : _pronounController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          colorHex: colorHex,
        );
      } else {
        // Criar
        await _versionController.createVersion(
          name: _nameController.text.trim(),
          pronoun: _pronounController.text.trim().isEmpty
              ? null
              : _pronounController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          colorHex: colorHex,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.versionToEdit != null
                  ? 'Alter atualizado com sucesso!'
                  : 'Alter criado com sucesso!',
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
        AppLogger.error('Erro ao salvar alter: $e', StackTrace.current);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _deleteVersion() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Alter?'),
        content: const Text(
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      setState(() => _isSubmitting = true);
      try {
        await _versionController.deleteVersion(widget.versionToEdit!.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Alter deletado com sucesso!'),
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: $e'),
            ),
          );
          AppLogger.error('Erro ao deletar versão: $e', StackTrace.current);
        }
      } finally {
        if (mounted) {
          setState(() => _isSubmitting = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.versionToEdit != null ? 'Editar Alter' : 'Criar Alter',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seletor de Cor
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Cor de Identificação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Escolha uma cor'),
                                content: SingleChildScrollView(
                                  child: ColorPicker(
                                    pickerColor: _selectedColor,
                                    onColorChanged: (color) {
                                      setState(
                                          () => _selectedColor = color);
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: _selectedColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withValues(alpha: 0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nome
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome do Alter *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'O nome é obrigatório';
                      }
                      if (value.trim().length < 2) {
                        return 'O nome deve ter pelo menos 2 caracteres';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Pronome
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _pronounController,
                    decoration: InputDecoration(
                      labelText: 'Pronome (opcional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.text_fields),
                      hintText: 'Ex: ele/dele, ela/dela, elu/delu',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Descrição
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      labelText: 'Descrição (opcional)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.description),
                      hintText:
                          'Adicione informações sobre este alter...',
                    ),
                    maxLines: 4,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botões de ação
              Row(
                children: [
                  if (widget.versionToEdit != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isSubmitting ? null : _deleteVersion,
                        icon: _isSubmitting
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.delete),
                        label: const Text('Deletar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  if (widget.versionToEdit != null)
                    const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitForm,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.check),
                      label: Text(
                        _isSubmitting
                            ? 'Salvando...'
                            : widget.versionToEdit != null
                                ? 'Atualizar'
                                : 'Criar',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}