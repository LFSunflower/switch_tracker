// Importação do pacote Flutter Material para componentes de UI
import 'package:flutter/material.dart';
// Importação do pacote Provider para gerenciamento de estado
import 'package:provider/provider.dart';

// Importação do controlador de sessões
import '../../controllers/session_controller.dart';
// Importação do utilitário de logging
import '../../core/utils/logger.dart';
// Importação do widget de lista de histórico
import 'widgets/history_list.dart';

// Definição do widget HistoryPage como StatefulWidget
class HistoryPage extends StatefulWidget {
  // Construtor constante com chave opcional
  const HistoryPage({super.key});

  // Cria o estado associado a este widget
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

// Classe de estado para HistoryPage
class _HistoryPageState extends State<HistoryPage> {
  // Método chamado quando o widget é inicializado
  @override
  void initState() {
    super.initState();
    // Não carregar aqui, deixar que a HomePage carregue
  }

  // Método assíncrono para carregar as sessões
  Future<void> _loadSessions() async {
    try {
      // Obtém a instância do controlador de sessões do contexto
      final controller = context.read<SessionController>();
      // Aguarda o carregamento das sessões
      await controller.loadSessions();
    } catch (e) {
      // Registra o erro no logger
      AppLogger.error('Erro ao carregar histórico: $e', StackTrace.current);
      // Verifica se o widget ainda está montado na árvore
      if (mounted) {
        // Exibe uma mensagem de erro ao usuário
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar: $e')),
        );
      }
    }
  }

  // Constrói a interface do widget
  @override
  Widget build(BuildContext context) {
    // Scaffold é a estrutura base da página
    return Scaffold(
      // Consome o SessionController do Provider para reatividade
      body: Consumer<SessionController>(
        // Builder que reconstrói quando o controlador muda
        builder: (context, controller, _) {
          // Verifica se o controlador está carregando dados
          if (controller.isLoading) {
            // Exibe um indicador de carregamento no centro
            return const Center(child: CircularProgressIndicator());
          }

          // Verifica se não há sessões registradas
          if (controller.allSessions.isEmpty) {
            // Exibe mensagem quando não há histórico
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ícone de histórico
                  const Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  // Espaçamento vertical
                  const SizedBox(height: 16),
                  // Texto informando que não há switches registrados
                  const Text(
                    'Nenhum switch registrado',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  // Espaçamento vertical
                  const SizedBox(height: 24),
                  // Botão para registrar um novo switch
                  ElevatedButton.icon(
                    // Ação ao pressionar o botão
                    onPressed: () {
                      // Verifica se o contexto ainda está montado
                      if (context.mounted) {
                        // Exibe uma dica ao usuário
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vá para a aba Switch para registrar'),
                          ),
                        );
                      }
                    },
                    // Ícone do botão
                    icon: const Icon(Icons.add),
                    // Texto do botão
                    label: const Text('Registrar Switch'),
                  ),
                ],
              ),
            );
          }

          // Se há sessões, exibe a lista com funcionalidade de refresh
          return RefreshIndicator(
            // Função chamada ao fazer pull-to-refresh
            onRefresh: _loadSessions,
            // Widget que exibe a lista de histórico
            child: HistoryList(sessions: controller.allSessions),
          );
        },
      ),
    );
  }
}
