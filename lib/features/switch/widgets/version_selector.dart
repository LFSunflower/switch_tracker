// Importa o pacote Flutter Material Design
import 'package:flutter/material.dart';

// Importa o modelo de dados Version
import '../../../data/models/version.dart';

// Classe widget sem estado para seleção de versões
class VersionSelector extends StatelessWidget {
  // Lista de versões disponíveis
  final List<Version> versions;
  // Lista de IDs de versões selecionadas
  final List<String> selectedIds;
  // Callback para quando a seleção muda
  final Function(List<String>) onSelectionChanged;

  // Construtor com parâmetros nomeados obrigatórios
  const VersionSelector({
    super.key,
    required this.versions,
    required this.selectedIds,
    required this.onSelectionChanged,
  });

  // Método para alternar a seleção de uma versão
  void _toggleSelection(String versionId) {
    // Se a versão já está selecionada, remove-a
    if (selectedIds.contains(versionId)) {
      onSelectionChanged(
        selectedIds.where((id) => id != versionId).toList(),
      );
    } else {
      // Caso contrário, adiciona-a à seleção
      onSelectionChanged([...selectedIds, versionId]);
    }
  }

  // Método para converter string hexadecimal em Color
  Color _parseColorHex(String hexColor) {
    // Tenta fazer o parse da cor
    try {
      // Se começa com '0x', faz parse direto
      if (hexColor.startsWith('0x')) {
        return Color(int.parse(hexColor));
      } else if (hexColor.startsWith('#')) {
        // Se começa com '#', remove o # e adiciona 0xFF no início
        return Color(int.parse('0xFF${hexColor.substring(1)}'));
      }
      // Caso contrário, adiciona 0xFF no início e faz parse
      return Color(int.parse('0xFF$hexColor'));
    } catch (e) {
      // Se houver erro, retorna cor cinza padrão
      return Colors.grey;
    }
  }

  // Método que constrói o widget
  @override
  Widget build(BuildContext context) {
    // Se não há versões disponíveis, mostra mensagem vazia
    if (versions.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          // Coluna com ícone, mensagem e botão
          child: Column(
            children: [
              // Ícone de informação
              const Icon(Icons.info, color: Colors.grey),
              // Espaçamento
              const SizedBox(height: 8),
              // Texto informando que não há alters
              const Text('Nenhum alter registrado'),
              // Espaçamento
              const SizedBox(height: 16),
              // Botão para criar novo alter
              ElevatedButton.icon(
                onPressed: () {
                  // Navega para a rota de alters
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

    // Cria um grid view com as versões disponíveis
    return GridView.builder(
      // Faz o grid ocupar apenas o espaço necessário
      shrinkWrap: true,
      // Desabilita scroll dentro do grid
      physics: const NeverScrollableScrollPhysics(),
      // Configuração do grid com 2 colunas
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      // Número de itens igual ao número de versões
      itemCount: versions.length,
      // Builder para cada item do grid
      itemBuilder: (context, index) {
        // Obtém a versão atual
        final version = versions[index];
        // Verifica se a versão está selecionada
        final isSelected = selectedIds.contains(version.id);

        // GestureDetector para detectar toque
        return GestureDetector(
          // Alterna seleção ao tocar
          onTap: () => _toggleSelection(version.id),
          // Card contendo o conteúdo da versão
          child: Card(
            // Cor diferente se selecionado
            color: isSelected ? Colors.blue.shade100 : Colors.grey.shade100,
            // Stack para sobrepor elementos
            child: Stack(
              children: [
                // Padding para espaçamento interno
                Padding(
                  padding: const EdgeInsets.all(12),
                  // Coluna com os elementos da versão
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container circular com a cor da versão
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _parseColorHex(version.color),
                          shape: BoxShape.circle,
                        ),
                        // Centro com a primeira letra do nome
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
                      // Espaçamento
                      const SizedBox(height: 8),
                      // Nome da versão
                      Text(
                        version.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      // Pronome da versão, se disponível
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
                // Ícone de confirmação se selecionado
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    // Container circular azul com ícone de check
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      // Ícone de confirmação
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