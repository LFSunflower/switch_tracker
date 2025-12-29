import 'package:flutter/material.dart';

import '../../../data/models/version.dart';

class VersionCard extends StatelessWidget {
  final Version version;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const VersionCard({
    super.key,
    required this.version,
    required this.onEdit,
    required this.onDelete,
  });

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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _parseColor(version.color),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              version.name.isNotEmpty
                  ? version.name[0].toUpperCase()
                  : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        title: Text(version.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (version.pronoun != null && version.pronoun!.isNotEmpty)
              Text('Pronome: ${version.pronoun}'),
            if (version.description != null &&
                version.description!.isNotEmpty)
              Text(
                version.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: onEdit,
              child: const Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Editar'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: onDelete,
              child: const Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Deletar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
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