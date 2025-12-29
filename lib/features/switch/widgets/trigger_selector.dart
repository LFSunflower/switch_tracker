// Importa o pacote Material Design do Flutter
import 'package:flutter/material.dart';

// Define o widget TriggerSelector como um StatefulWidget
class TriggerSelector extends StatefulWidget {
  // Lista de gatilhos já selecionados
  final List<String> selectedTriggers;
  // Função callback para notificar mudanças na seleção
  final Function(List<String>) onSelectionChanged;

  // Construtor const do widget
  const TriggerSelector({
    super.key,
    required this.selectedTriggers,
    required this.onSelectionChanged,
  });

  // Cria a instância do estado do widget
  @override
  State<TriggerSelector> createState() => _TriggerSelectorState();
}

// Classe de estado que gerencia o comportamento do TriggerSelector
class _TriggerSelectorState extends State<TriggerSelector> {
  // Lista dos gatilhos comuns predefinidos
  final List<String> _commonTriggers = [
    'Estresse',
    'Ansiedade',
    'Sono',
    'Cansaço',
    'Fome',
    'Barulho',
    'Multidão',
    'Interação social',
    'Memória',
    'Dor física',
    'Emoção intensa',
    'Música',
    'Cheiro',
    'Outro',
  ];

  // Controlador para gerenciar o texto do campo de entrada customizado
  late TextEditingController _customController;

  // Inicializa o estado e o controlador de texto
  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
  }

  // Libera os recursos do controlador quando o widget é destruído
  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  // Adiciona um novo gatilho customizado à lista de selecionados
  void _addCustomTrigger() {
    // Verifica se o campo de texto não está vazio
    if (_customController.text.isNotEmpty) {
      // Remove espaços em branco do início e fim
      final newTrigger = _customController.text.trim();
      // Verifica se o gatilho não está duplicado
      if (!widget.selectedTriggers.contains(newTrigger)) {
        // Chama o callback com a lista atualizada
        widget.onSelectionChanged([
          ...widget.selectedTriggers,
          newTrigger,
        ]);
      }
      // Limpa o campo de texto
      _customController.clear();
    }
  }

  // Remove um gatilho específico da lista de selecionados
  void _removeTrigger(String trigger) {
    // Filtra a lista removendo o gatilho desejado
    widget.onSelectionChanged(
      widget.selectedTriggers.where((t) => t != trigger).toList(),
    );
  }

  // Alterna o estado de um gatilho (adiciona ou remove)
  void _toggleTrigger(String trigger) {
    // Se o gatilho já está selecionado, remove-o
    if (widget.selectedTriggers.contains(trigger)) {
      _removeTrigger(trigger);
    } else {
      // Caso contrário, adiciona-o à lista
      widget.onSelectionChanged([...widget.selectedTriggers, trigger]);
    }
  }

  // Constrói a interface do widget
  @override
  Widget build(BuildContext context) {
    // Coluna principal contendo todos os elementos
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Seção de gatilhos já selecionados
        if (widget.selectedTriggers.isNotEmpty)
          // Coluna que exibe os chips dos gatilhos selecionados
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wrap para exibir os chips em múltiplas linhas
              Wrap(
                spacing: 8,
                runSpacing: 8,
                // Mapeia cada gatilho selecionado em um Chip
                children: widget.selectedTriggers
                    .map(
                      (trigger) => Chip(
                        label: Text(trigger),
                        // Função executada ao clicar no X do chip
                        onDeleted: () => _removeTrigger(trigger),
                        // Define a cor de fundo do chip
                        backgroundColor: Colors.blue.shade100,
                      ),
                    )
                    .toList(),
              ),
              // Espaço vertical entre seções
              const SizedBox(height: 16),
            ],
          ),

        // Seção de gatilhos comuns predefinidos
        // Wrap para exibir os chips em múltiplas linhas
        Wrap(
          spacing: 8,
          runSpacing: 8,
          // Mapeia cada gatilho comum em um FilterChip
          children: _commonTriggers
              .map(
                (trigger) => FilterChip(
                  label: Text(trigger),
                  // Define se o chip está selecionado
                  selected: widget.selectedTriggers.contains(trigger),
                  // Função executada ao clicar no chip
                  onSelected: (_) => _toggleTrigger(trigger),
                ),
              )
              .toList(),
        ),
        // Espaço vertical entre seções
        const SizedBox(height: 16),

        // Seção de entrada para gatilho customizado
        // Linha contendo o campo de texto e o botão de adicionar
        Row(
          children: [
            // Campo de texto que ocupa o espaço disponível
            Expanded(
              child: TextField(
                controller: _customController,
                // Função executada ao pressionar Enter
                onSubmitted: (_) => _addCustomTrigger(),
                // Configurações de aparência do campo de texto
                decoration: InputDecoration(
                  hintText: 'Adicionar gatilho customizado',
                  // Define a borda do campo de texto
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Remove o preenchimento padrão
                  isDense: true,
                  // Define o espaço interno do campo de texto
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            // Espaço horizontal entre o campo de texto e o botão
            const SizedBox(width: 8),
            // Botão para adicionar o gatilho customizado
            IconButton(
              icon: const Icon(Icons.add),
              // Função executada ao clicar no botão
              onPressed: _addCustomTrigger,
              // Texto exibido ao passar o mouse sobre o botão
              tooltip: 'Adicionar gatilho',
            ),
          ],
        ),
      ],
    );
  }
}