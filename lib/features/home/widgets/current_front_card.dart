// Importação do pacote Flutter Material Design
import 'package:flutter/material.dart';
// Importação do pacote Provider para gerenciamento de estado
import 'package:provider/provider.dart';

// Importação do controller de sessão
import '../../../controllers/session_controller.dart';
// Importação do controller de versão
import '../../../controllers/version_controller.dart';
// Importação de utilitários para manipulação de datas e horas
import '../../../core/utils/time_utils.dart';

// Definição da classe CurrentFrontCard como um StatelessWidget
class CurrentFrontCard extends StatelessWidget {
  // Declaração da propriedade sessionController
  final SessionController sessionController;

  // Construtor da classe com parâmetro nomeado obrigatório
  const CurrentFrontCard({
    super.key,
    required this.sessionController,
  });

  // Método build que constrói a interface do widget
  @override
  Widget build(BuildContext context) {
    // Obtém a sessão ativa do controller
    final activeSession = sessionController.activeSession;

    // Verifica se não há sessão ativa
    if (activeSession == null) {
      // Retorna um widget centralizado com ícone e texto
      return Center(
        child: Column(
          // Centraliza os filhos na vertical
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone de pessoa desconectada
            Icon(
              Icons.person_off,
              size: 64,
              color: Colors.grey[400],
            ),
            // Espaçador vertical
            const SizedBox(height: 16),
            // Texto informando que não há sessão ativa
            Text(
              'Nenhuma sessão ativa',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Obtém o VersionController do contexto
    final versionController = context.read<VersionController>();
    // Mapeia os IDs dos alters para seus nomes, separados por vírgula
    final alterNames = activeSession.alters
        .map((alterId) => versionController.getVersionById(alterId)?.name ?? 'Desconhecido')
        .join(', ');

    // Calcula a duração da sessão
    final duration = _calculateDuration(activeSession.startTime, activeSession.endTime);

    // Retorna um Card com a sessão ativa
    return Card(
      // Define a elevação do card
      elevation: 4,
      child: Padding(
        // Define o padding interno do card
        padding: const EdgeInsets.all(16),
        child: Column(
          // Alinha os filhos ao início (esquerda)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Texto do título "Sessão Ativa"
            const Text(
              'Sessão Ativa',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            // Espaçador vertical
            const SizedBox(height: 12),
            // Texto com os nomes dos alters
            Text(
              alterNames,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Espaçador vertical
            const SizedBox(height: 12),
            // Row que contém informações da sessão
            Row(
              // Distribui o espaço entre os filhos
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Coluna esquerda com intensidade e tipo
                Column(
                  // Alinha os filhos ao início (esquerda)
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Texto da intensidade
                    Text(
                      'Intensidade: ${activeSession.intensity}/5',
                      style: const TextStyle(fontSize: 12),
                    ),
                    // Espaçador vertical
                    const SizedBox(height: 4),
                    // Texto do tipo de sessão
                    Text(
                      'Tipo: ${activeSession.isCofront ? 'Co-front' : 'Simples'}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                // Coluna direita com data de início e duração
                Column(
                  // Alinha os filhos ao fim (direita)
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Texto da data e hora de início
                    Text(
                      'Iniciado: ${TimeUtils.formatDateTime(activeSession.startTime)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    // Espaçador vertical
                    const SizedBox(height: 4),
                    // Texto da duração da sessão
                    Text(
                      'Duração: $duration',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Espaçador vertical
            const SizedBox(height: 12),
            // Verifica se há gatilhos e exibe-os
            if (activeSession.triggers.isNotEmpty) ...[
              // Texto do título "Gatilhos"
              const Text(
                'Gatilhos:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              // Espaçador vertical
              const SizedBox(height: 8),
              // Widget Wrap para exibir os gatilhos como chips
              Wrap(
                // Define o espaçamento entre os chips
                spacing: 8,
                // Mapeia cada gatilho para um Chip
                children: activeSession.triggers
                    .map((trigger) => Chip(
                          // Exibe o texto do gatilho
                          label: Text(trigger),
                          // Define uma densidade visual compacta
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
            ],
            // Espaçador vertical
            const SizedBox(height: 16),
            // SizedBox que ocupará toda a largura disponível
            SizedBox(
              // Define a largura máxima
              width: double.infinity,
              // Botão elevado para finalizar a sessão
              child: ElevatedButton.icon(
                // Define a ação ao pressionar o botão
                onPressed: () {
                  _showEndSessionDialog(context, sessionController);
                },
                // Ícone do botão
                icon: const Icon(Icons.check, size: 18),
                // Texto do botão
                label: const Text('Finalizar Sessão'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método que exibe um diálogo de confirmação para finalizar a sessão
  void _showEndSessionDialog(
    BuildContext context,
    SessionController sessionController,
  ) {
    // Exibe um diálogo
    showDialog(
      context: context,
      // Builder que constrói o conteúdo do diálogo
      builder: (context) => AlertDialog(
        // Título do diálogo
        title: const Text('Finalizar Sessão'),
        // Conteúdo do diálogo
        content: const Text('Tem certeza que deseja finalizar a sessão ativa?'),
        // Lista de ações do diálogo
        actions: [
          // Botão de cancelamento
          TextButton(
            // Fecha o diálogo ao pressionar
            onPressed: () => Navigator.pop(context),
            // Texto do botão
            child: const Text('Cancelar'),
          ),
          // Botão de confirmação
          TextButton(
            // Define a ação ao pressionar
            onPressed: () {
              // Fecha o diálogo
              Navigator.pop(context);
              // Finaliza a sessão ativa
              sessionController.endActiveSession();
              // Exibe uma mensagem de sucesso
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessão finalizada com sucesso')),
              );
            },
            // Texto do botão com cor laranja
            child: const Text('Finalizar', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    );
  }

  // Método que calcula a duração de uma sessão
  String _calculateDuration(DateTime start, DateTime? end) {
    // Verifica se a sessão ainda está ativa (sem data de término)
    if (end == null) {
      // Calcula a diferença entre agora e o início
      final difference = DateTime.now().difference(start);
      // Obtém o número de horas
      final hours = difference.inHours;
      // Obtém o número de minutos restantes
      final minutes = difference.inMinutes.remainder(60);
      // Se houver horas, retorna o formato com horas e minutos
      if (hours > 0) {
        return '${hours}h ${minutes}m';
      }
      // Retorna apenas os minutos
      return '${minutes}m';
    }
    // Calcula a diferença entre o término e o início
    final difference = end.difference(start);
    // Obtém o número de horas
    final hours = difference.inHours;
    // Obtém o número de minutos restantes
    final minutes = difference.inMinutes.remainder(60);
    // Se houver horas, retorna o formato com horas e minutos
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    // Retorna apenas os minutos
    return '${minutes}m';
  }
}