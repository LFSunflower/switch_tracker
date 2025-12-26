import 'package:flutter/material.dart';
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
  late VersionController _versionController;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _pronounController;
  late TextEditingController _descriptionController;
  late TextEditingController _functionController;
  late TextEditingController _likesController;
  late TextEditingController _dislikesController;
  late TextEditingController _safetyInstructionsController;

  late Color _selectedColor;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _versionController = context.read<VersionController>();

    if (widget.versionToEdit != null) {
      _nameController = TextEditingController(text: widget.versionToEdit!.name);
      _pronounController =
          TextEditingController(text: widget.versionToEdit!.pronoun ?? '');
      _descriptionController =
          TextEditingController(text: widget.versionToEdit!.description ?? '');
      _functionController =
          TextEditingController(text: widget.versionToEdit!.function ?? '');
      _likesController =
          TextEditingController(text: widget.versionToEdit!.likes ?? '');
      _dislikesController =
          TextEditingController(text: widget.versionToEdit!.dislikes ?? '');
      _safetyInstructionsController = TextEditingController(
          text: widget.versionToEdit!.safetyInstructions ?? '');
      _selectedColor = _hexStringToColor(widget.versionToEdit!.color);
    } else {
      _nameController = TextEditingController();
      _pronounController = TextEditingController();
      _descriptionController = TextEditingController();
      _functionController = TextEditingController();
      _likesController = TextEditingController();
      _dislikesController = TextEditingController();
      _safetyInstructionsController = TextEditingController();
      _selectedColor = Colors.purple;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pronounController.dispose();
    _descriptionController.dispose();
    _functionController.dispose();
    _likesController.dispose();
    _dislikesController.dispose();
    _safetyInstructionsController.dispose();
    super.dispose();
  }

  String _colorToHexString(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color _hexStringToColor(String hex) {
    try {
      if (hex.startsWith('#')) {
        return Color(int.parse('FF${hex.substring(1)}', radix: 16));
      } else if (hex.startsWith('0x')) {
        return Color(int.parse(hex));
      } else {
        return Color(int.parse('FF$hex', radix: 16));
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
        AppLogger.info('Editando alter: ${widget.versionToEdit!.id}');
        final result = await _versionController.updateVersion(
          id: widget.versionToEdit!.id,
          name: _nameController.text.trim(),
          pronoun: _pronounController.text.trim().isEmpty
              ? null
              : _pronounController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          function: _functionController.text.trim().isEmpty
              ? null
              : _functionController.text.trim(),
          likes: _likesController.text.trim().isEmpty
              ? null
              : _likesController.text.trim(),
          dislikes: _dislikesController.text.trim().isEmpty
              ? null
              : _dislikesController.text.trim(),
          safetyInstructions: _safetyInstructionsController.text.trim().isEmpty
              ? null
              : _safetyInstructionsController.text.trim(),
          colorHex: colorHex,
        );

        if (result != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alter atualizado com sucesso!')),
          );
          Navigator.pop(context);
        }
      } else {
        // Criar
        AppLogger.info('Criando novo alter: ${_nameController.text.trim()}');
        final result = await _versionController.createVersion(
          name: _nameController.text.trim(),
          pronoun: _pronounController.text.trim().isEmpty
              ? null
              : _pronounController.text.trim(),
          description: _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
          function: _functionController.text.trim().isEmpty
              ? null
              : _functionController.text.trim(),
          likes: _likesController.text.trim().isEmpty
              ? null
              : _likesController.text.trim(),
          dislikes: _dislikesController.text.trim().isEmpty
              ? null
              : _dislikesController.text.trim(),
          safetyInstructions: _safetyInstructionsController.text.trim().isEmpty
              ? null
              : _safetyInstructionsController.text.trim(),
          colorHex: colorHex,
        );

        if (result != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alter criado com sucesso!')),
          );
          Navigator.pop(context);
        } else if (mounted) {
          AppLogger.error(
            'Erro ao criar alter. Result é null',
            StackTrace.current,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Erro ao criar alter: ${_versionController.errorMessage ?? "Erro desconhecido"}',
              ),
            ),
          );
        }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.versionToEdit != null ? 'Editar Alter' : 'Novo Alter',
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
              // Nome
              TextFormField(
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
                    return 'Nome é obrigatório';
                  }
                  if (value.trim().length < 2) {
                    return 'Nome deve ter pelo menos 2 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Pronome
              TextFormField(
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
              const SizedBox(height: 16),

              // Descrição
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Descrição (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.description),
                  hintText: 'Breve descrição sobre este alter...',
                ),
              ),
              const SizedBox(height: 16),

              // Função
              TextFormField(
                controller: _functionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Função (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.work),
                  hintText: 'Ex: protetor, guardião, regressor, trauma holder...',
                ),
              ),
              const SizedBox(height: 16),

              // O que gosta
              TextFormField(
                controller: _likesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'O que gosta (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.favorite),
                  hintText: 'Descreva do que este alter gosta...',
                ),
              ),
              const SizedBox(height: 16),

              // O que desgosta
              TextFormField(
                controller: _dislikesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'O que desgosta (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.thumb_down),
                  hintText: 'Descreva do que este alter não gosta...',
                ),
              ),
              const SizedBox(height: 16),

              // Instruções de Segurança
              TextFormField(
                controller: _safetyInstructionsController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Instruções de Segurança (opcional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.security),
                  hintText: 'Como lidar com este alter para evitar crises...',
                ),
              ),
              const SizedBox(height: 16),

              // Seletor de Cor
              const Text(
                'Cor de Identificação',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  _showColorPicker();
                },
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _colorToHexString(_selectedColor),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Botão de Envio
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isSubmitting ? null : _submitForm,
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(
                    _isSubmitting
                        ? 'Salvando...'
                        : (widget.versionToEdit != null
                            ? 'Atualizar Alter'
                            : 'Criar Alter'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher Cor'),
        content: Wrap(
          spacing: 8,
          children: [
            Colors.red,
            Colors.pink,
            Colors.purple,
            Colors.deepPurple,
            Colors.indigo,
            Colors.blue,
            Colors.cyan,
            Colors.teal,
            Colors.green,
            Colors.lime,
            Colors.yellow,
            Colors.amber,
            Colors.orange,
            Colors.deepOrange,
            Colors.brown,
            Colors.grey,
          ]
              .map(
                (color) => GestureDetector(
                  onTap: () {
                    setState(() => _selectedColor = color);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _selectedColor == color ? Colors.black : Colors.transparent,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}