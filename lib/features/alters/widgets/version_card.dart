import 'package:flutter/material.dart';

import '../../../data/models/version.dart';

// Widget stateless que exibe um card com informações de uma versão
class VersionCard extends StatelessWidget {
  // Modelo de dados da versão a ser exibida
  final Version version;
  // Callback executado quando o usuário clica em editar
  final VoidCallback onEdit;
  // Callback executado quando o usuário clica em deletar
  final VoidCallback onDelete;

  // Construtor com parâmetros obrigatórios
  const VersionCard({
    super.key,
    required this.version,
    required this.onEdit,
    required this.onDelete,
  });

  // Método para converter string de cor hexadecimal em objeto Color
  Color _parseColorHex(String hexColor) {
    try {
      // Se a string começa com '0x', converte diretamente
      if (hexColor.startsWith('0x')) {
        return Color(int.parse(hexColor));
      } 
      // Se a string começa com '#', remove a '#' e adiciona 'FF' no início
      else if (hexColor.startsWith('#')) {
        return Color(int.parse('0xFF${hexColor.substring(1)}'));
      }
      // Caso contrário, adiciona 'FF' no início da string
      return Color(int.parse('0xFF$hexColor'));
    } 
    // Se houver erro na conversão, retorna cinza
    catch (e) {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Card com espaço inferior de 12 pixels
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      // ListTile para exibir o conteúdo de forma estruturada
      child: ListTile(
        // Widget inicial do ListTile - círculo com inicial do nome
        leading: Container(
          width: 50,
          height: 50,
          // Decoração circular com cor parseada
          decoration: BoxDecoration(
            color: _parseColor(version.color),
            shape: BoxShape.circle,
          ),
          // Centraliza a inicial dentro do círculo
          child: Center(
            child: Text(
              // Exibe primeira letra do nome ou '?' se vazio
              version.name.isNotEmpty
                  ? version.name[0].toUpperCase()
                  : '?',
              // Estilo do texto: branco, negrito, tamanho 20
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
        // Título principal com o nome da versão
        title: Text(version.name),
        // Subtítulo com pronome e descrição
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Exibe pronome se não for nulo ou vazio
            if (version.pronoun != null && version.pronoun!.isNotEmpty)
              Text('Pronome: ${version.pronoun}'),
            // Exibe descrição com truncagem se não for nulo ou vazio
            if (version.description != null &&
                version.description!.isNotEmpty)
              Text(
                version.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        // Menu popup com opções de editar e deletar
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            // Opção de editar
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
            // Opção de deletar com ícone e texto em vermelho
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

  // Método para converter string de cor em objeto Color
  Color _parseColor(String colorString) {
    try {
      // Se a string começa com '#', remove '#' e converte com radix 16
      if (colorString.startsWith('#')) {
        return Color(int.parse('FF${colorString.substring(1)}', radix: 16));
      } 
      // Se a string começa com '0x', converte diretamente
      else if (colorString.startsWith('0x')) {
        return Color(int.parse(colorString));
      } 
      // Caso contrário, adiciona 'FF' no início e converte
      else {
        return Color(int.parse('FF$colorString', radix: 16));
      }
    } 
    // Se houver erro na conversão, retorna roxo
    catch (e) {
      return Colors.purple;
    }
  }
}