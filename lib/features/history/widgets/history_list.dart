// Importa pacotes necessários do Flutter e Provider
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importa o controlador de versão para acessar dados de alters
import '../../../controllers/version_controller.dart';
// Importa o modelo de sessão frontend
import '../../../data/models/front_session.dart';
// Importa a página de detalhes da sessão
import '../../session_detail/session_detail_page.dart';

// Widget stateless que exibe uma lista de sessões
class HistoryList extends StatelessWidget {
  // Lista de sessões a serem exibidas
  final List<FrontSession> sessions;

  // Construtor com chave e lista de sessões obrigatória
  const HistoryList({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    // Verifica se a lista de sessões está vazia
    if (sessions.isEmpty) {
      // Exibe uma tela vazia com ícone e mensagem
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícone de histórico cinzento
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey[400],
            ),
            // Espaçamento entre ícone e texto
            const SizedBox(height: 16),
            // Texto informando que não há histórico
            Text(
              'Nenhum histórico de sessões',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    // Constrói uma lista deslizável com os cartões de sessão
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // Define a quantidade de itens na lista
      itemCount: sessions.length,
      // Constrói cada item da lista
      itemBuilder: (context, index) {
        // Cria um cartão de histórico para cada sessão
        return _HistoryCard(session: sessions[index]);
      },
    );
  }
}

// Widget stateless que representa um cartão individual de sessão
class _HistoryCard extends StatelessWidget {
  // A sessão a ser exibida no cartão
  final FrontSession session;

  // Construtor com a sessão obrigatória
  const _HistoryCard({required this.session});

  @override
  Widget build(BuildContext context) {
    // Obtém a instância do controlador de versão do contexto
    final versionController = context.read<VersionController>();
    // Mapeia os IDs de alters para seus nomes, separados por vírgula
    final alterNames = session.alters
        .map((alterId) => versionController.getVersionById(alterId)?.name ?? 'Desconhecido')
        .join(', ');

    // Calcula a duração da sessão
    final duration = _calculateDuration(session.startTime, session.endTime);

    // Constrói um cartão com informações da sessão
    return Card(
      // Define margem inferior do cartão
      margin: const EdgeInsets.only(bottom: 12),
      // ListTile para exibir informações em formato de lista
      child: ListTile(
        // Widget à esquerda mostrando a intensidade
        leading: Container(
          // Dimensões do círculo
          width: 40,
          height: 40,
          // Decoração com cor baseada na intensidade
          decoration: BoxDecoration(
            color: _getIntensityColor(session.intensity),
            shape: BoxShape.circle,
          ),
          // Centraliza o número de intensidade dentro do círculo
          child: Center(
            child: Text(
              // Converte a intensidade para string
              session.intensity.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        // Título exibindo os nomes dos alters
        title: Text(
          alterNames,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // Subtítulo exibindo tipo de sessão e duração
        subtitle: Text(
          '${session.isCofront ? 'Co-front' : 'Simples'} • $duration',
          style: const TextStyle(fontSize: 12),
        ),
        // Ícone à direita indicando navegação
        trailing: const Icon(Icons.chevron_right),
        // Ação ao tocar no cartão
        onTap: () {
          // Navega para a página de detalhes da sessão
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SessionDetailPage(session: session),
            ),
          );
        },
      ),
    );
  }

  // Método que calcula a duração da sessão em horas e minutos
  String _calculateDuration(DateTime start, DateTime? end) {
    // Verifica se a sessão ainda está em andamento
    if (end == null) return 'Em andamento';
    // Calcula a diferença entre fim e início
    final difference = end.difference(start);
    // Extrai horas da diferença
    final hours = difference.inHours;
    // Extrai minutos restantes após as horas
    final minutes = difference.inMinutes.remainder(60);
    // Retorna formato com horas se houver
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    // Retorna apenas minutos se for menos de uma hora
    return '${minutes}m';
  }

  // Método que retorna a cor baseada no nível de intensidade
  Color _getIntensityColor(int intensity) {
    // Switch para definir cor conforme a intensidade (1-5)
    switch (intensity) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 4:
        return Colors.deepOrange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}