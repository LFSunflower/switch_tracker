import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/version_controller.dart';
import '../../core/utils/logger.dart';
import '../../data/models/version.dart';

// Widget stateful para formulário de criação/edição de versões (alters)
class VersionFormPage extends StatefulWidget {
  // Versão a ser editada (nulo se for criação)
  final Version? versionToEdit;

  const VersionFormPage({
    super.key,
    this.versionToEdit,
  });

  @override
  State<VersionFormPage> createState() => _VersionFormPageState();
}

// Estado do formulário de versão
class _VersionFormPageState extends State<VersionFormPage> {
  // Controlador para gerenciar operações de versão
  late VersionController _versionController;
  // Chave global para validar o formulário
  final _formKey = GlobalKey<FormState>();
  // Controladores de texto para cada campo do formulário
  late TextEditingController _nameController;
  late TextEditingController _pronounController;
  late TextEditingController _descriptionController;
  late TextEditingController _functionController;
  late TextEditingController _likesController;
  late TextEditingController _dislikesController;
  late TextEditingController _safetyInstructionsController;

  // Cor selecionada para identificação da versão
  late Color _selectedColor;
  // Flag para rastrear se o formulário está sendo enviado
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Obtém o controlador de versão do provider
    _versionController = context.read<VersionController>();

    // Se houver uma versão para editar, popula os campos com seus dados
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
      // Converte a cor hex da versão para um objeto Color
      _selectedColor = _hexStringToColor(widget.versionToEdit!.color);
    } else {
      // Caso contrário, cria controladores vazios e define cor padrão
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
    // Libera todos os controladores de texto
    _nameController.dispose();
    _pronounController.dispose();
    _descriptionController.dispose();
    _functionController.dispose();
    _likesController.dispose();
    _dislikesController.dispose();
    _safetyInstructionsController.dispose();
    super.dispose();
  }

  // Converte um objeto Color para string hexadecimal
  String _colorToHexString(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  // Converte uma string hexadecimal para um objeto Color
  Color _hexStringToColor(String hex) {
    try {
      // Se a string começa com #, remove-o e adiciona opacidade FF
      if (hex.startsWith('#')) {
        return Color(int.parse('FF${hex.substring(1)}', radix: 16));
      } 
      // Se começa com 0x, faz o parse direto
      else if (hex.startsWith('0x')) {
        return Color(int.parse(hex));
      } 
      // Caso contrário, adiciona opacidade FF
      else {
        return Color(int.parse('FF$hex', radix: 16));
      }
    } catch (e) {
      // Em caso de erro, registra aviso e retorna cor padrão
      AppLogger.warning('Erro ao parsear cor: $e');
      return Colors.purple;
    }
  }

  // Submete o formulário para criar ou atualizar uma versão
  Future<void> _submitForm() async {
    // Valida o formulário antes de enviar
    if (!_formKey.currentState!.validate()) return;

    // Define estado para mostrar carregamento
    setState(() => _isSubmitting = true);

    try {
      // Converte a cor selecionada para formato hexadecimal
      final colorHex = _colorToHexString(_selectedColor);
      AppLogger.info('Submetendo formulário com cor: $colorHex');

      // Se há versão para editar, executa atualização
      if (widget.versionToEdit != null) {
        AppLogger.info('Editando alter: ${widget.versionToEdit!.id}');
        // Chama o controlador para atualizar a versão
        final result = await _versionController.updateVersion(
          id: widget.versionToEdit!.id,
          name: _nameController.text.trim(),
          // Se o campo está vazio, passa null; senão, passa o valor trimado
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

        // Se a atualização foi bem-sucedida e o widget ainda está montado
        if (result != null && mounted) {
          // Mostra mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alter atualizado com sucesso!')),
          );
          // Volta à página anterior
          Navigator.pop(context);
        }
      } else {
        // Caso contrário, executa criação de nova versão
        AppLogger.info('Criando novo alter: ${_nameController.text.trim()}');
        // Chama o controlador para criar a versão
        final result = await _versionController.createVersion(
          name: _nameController.text.trim(),
          // Se o campo está vazio, passa null; senão, passa o valor trimado
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

        // Se a criação foi bem-sucedida e o widget ainda está montado
        if (result != null && mounted) {
          // Mostra mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alter criado com sucesso!')),
          );
          // Volta à página anterior
          Navigator.pop(context);
        } 
        // Se a criação falhou e o widget ainda está montado
        else if (mounted) {
          AppLogger.error(
            'Erro ao criar alter. Result é null',
            StackTrace.current,
          );
          // Mostra mensagem de erro com detalhes
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
      // Se uma exceção ocorrer durante a submissão
      if (mounted) {
        // Mostra mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
        // Registra o erro nos logs
        AppLogger.error('Erro ao salvar alter: $e', StackTrace.current);
      }
    } finally {
      // Após a submissão, remove o estado de carregamento se o widget ainda está montado
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Barra de aplicativo com título dinâmico
      appBar: AppBar(
        title: Text(
          // Mostra "Editar Alter" ou "Novo Alter" conforme contexto
          widget.versionToEdit != null ? 'Editar Alter' : 'Novo Alter',
        ),
        centerTitle: true,
      ),
      // Corpo da página com scroll para acomodar todos os campos
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        // Formulário para validação
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de Nome (obrigatório)
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Alter *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                // Validação do campo de nome
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

              // Campo de Pronome (opcional)
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

              // Campo de Descrição (opcional, 3 linhas)
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

              // Campo de Função (opcional, 2 linhas)
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

              // Campo de Gostos (opcional, 4 linhas)
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

              // Campo de Desgostos (opcional, 4 linhas)
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

              // Campo de Instruções de Segurança (opcional, 4 linhas)
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

              // Rótulo para seção de seleção de cor
              const Text(
                'Cor de Identificação',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              
              // Botão para abrir seletor de cor
              GestureDetector(
                onTap: () {
                  _showColorPicker();
                },
                // Container mostrando a cor selecionada
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _selectedColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 2),
                  ),
                  // Texto exibindo o valor hexadecimal da cor
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

              // Botão de envio do formulário
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  // Desabilita o botão durante o envio
                  onPressed: _isSubmitting ? null : _submitForm,
                  // Mostra spinner ou ícone dependendo do estado
                  icon: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  // Texto dinâmico do botão
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

  // Exibe o seletor de cor em um diálogo
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escolher Cor'),
        // Wrap com cores disponíveis em grid
        content: Wrap(
          spacing: 8,
          // Lista de cores disponíveis
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
              // Mapeia cada cor para um widget circular clicável
              .map(
                (color) => GestureDetector(
                  // Atualiza a cor selecionada ao tocar
                  onTap: () {
                    setState(() => _selectedColor = color);
                    // Fecha o diálogo
                    Navigator.pop(context);
                  },
                  // Círculo colorido representando a cor
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      // Borda preta se a cor está selecionada, senão transparente
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