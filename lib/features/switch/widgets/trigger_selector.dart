import 'package:flutter/material.dart';

class TriggerSelector extends StatefulWidget {
  final List<String> selectedTriggers;
  final Function(List<String>) onSelectionChanged;

  const TriggerSelector({
    super.key,
    required this.selectedTriggers,
    required this.onSelectionChanged,
  });

  @override
  State<TriggerSelector> createState() => _TriggerSelectorState();
}

class _TriggerSelectorState extends State<TriggerSelector> {
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

  late TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController();
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _addCustomTrigger() {
    if (_customController.text.isNotEmpty) {
      final newTrigger = _customController.text.trim();
      if (!widget.selectedTriggers.contains(newTrigger)) {
        widget.onSelectionChanged([
          ...widget.selectedTriggers,
          newTrigger,
        ]);
      }
      _customController.clear();
    }
  }

  void _removeTrigger(String trigger) {
    widget.onSelectionChanged(
      widget.selectedTriggers.where((t) => t != trigger).toList(),
    );
  }

  void _toggleTrigger(String trigger) {
    if (widget.selectedTriggers.contains(trigger)) {
      _removeTrigger(trigger);
    } else {
      widget.onSelectionChanged([...widget.selectedTriggers, trigger]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected triggers
        if (widget.selectedTriggers.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.selectedTriggers
                    .map(
                      (trigger) => Chip(
                        label: Text(trigger),
                        onDeleted: () => _removeTrigger(trigger),
                        backgroundColor: Colors.blue.shade100,
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),

        // Common triggers
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonTriggers
              .map(
                (trigger) => FilterChip(
                  label: Text(trigger),
                  selected: widget.selectedTriggers.contains(trigger),
                  onSelected: (_) => _toggleTrigger(trigger),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),

        // Custom trigger input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _customController,
                onSubmitted: (_) => _addCustomTrigger(),
                decoration: InputDecoration(
                  hintText: 'Adicionar gatilho customizado',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _addCustomTrigger,
              tooltip: 'Adicionar gatilho',
            ),
          ],
        ),
      ],
    );
  }
}