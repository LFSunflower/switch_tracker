import 'package:flutter/material.dart';

import '../../../data/models/version.dart';

class VersionCard extends StatelessWidget {
  final Version version;
  final VoidCallback onEdit;

  const VersionCard({
    super.key,
    required this.version,
    required this.onEdit,
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
    final color = _parseColorHex(version.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              version.name.isNotEmpty ? version.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        title: Text(
          version.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (version.pronoun != null)
              Text(
                'Pronome: ${version.pronoun}',
                style: const TextStyle(fontSize: 12),
              ),
            if (version.description != null)
              Text(
                version.description!,
                style: const TextStyle(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
          tooltip: 'Editar alter',
        ),
      ),
    );
  }
}