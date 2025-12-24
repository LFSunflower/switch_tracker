import 'package:flutter/material.dart';

import '../../../data/models/version.dart';

class VersionSelector extends StatelessWidget {
  final List<Version> versions;
  final List<String> selectedIds;
  final Function(List<String>) onSelectionChanged;

  const VersionSelector({
    super.key,
    required this.versions,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  void _toggleSelection(String versionId) {
    if (selectedIds.contains(versionId)) {
      onSelectionChanged(
        selectedIds.where((id) => id != versionId).toList(),
      );
    } else {
      onSelectionChanged([...selectedIds, versionId]);
    }
  }

  Color _parseColorHex(String hexColor) {
    try {
      if (hexColor.startsWith('0x')) {
        return Color(int.parse(hexColor));
      } else if (hexColor.startsWith('#')) {
        return Color(int.parse('0xFF${hexColor.substring(1)}'));
      }
      return Color(int.parse('0xFF$hexColor'));
    } catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (versions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Icon(Icons.info, color: Colors.grey),
              const SizedBox(height: 8),
              const Text('Nenhum alter registrado'),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed('/alters');
                },
                icon: const Icon(Icons.add),
                label: const Text('Criar Alter'),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: versions.length,
      itemBuilder: (context, index) {
        final version = versions[index];
        final isSelected = selectedIds.contains(version.id);

        return GestureDetector(
          onTap: () => _toggleSelection(version.id),
          child: Card(
            color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _parseColorHex(version.color),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            version.name.isNotEmpty
                                ? version.name[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        version.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (version.pronoun != null)
                        Text(
                          version.pronoun!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}