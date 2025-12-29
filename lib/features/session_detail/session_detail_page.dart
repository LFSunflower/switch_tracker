// Importa o pacote Material do Flutter para componentes de UI
import 'package:flutter/material.dart';
// Importa o pacote Provider para gerenciamento de estado
import 'package:provider/provider.dart';

// Importa o controlador de sessão
import '../../controllers/session_controller.dart';
// Importa o controlador de versão
import '../../controllers/version_controller.dart';
// Importa utilitários de tempo
import '../../core/utils/time_utils.dart';
// Importa o modelo de sessão frontal
import '../../data/models/front_session.dart';
// Importa a página de edição de sessão
import 'session_edit_page.dart';

// Define a classe do widget de detalhes da sessão como StatefulWidget
class SessionDetailPage extends StatefulWidget {
  // Declara a variável final de sessão
  final FrontSession session;

  // Define o construtor com a chave e a sessão obrigatória
  const SessionDetailPage({
    super.key,
    required this.session,
  });

  // Cria o estado do widget
  @override
  State<SessionDetailPage> createState() => _SessionDetailPageState();
}

// Define a classe de estado para SessionDetailPage
class _SessionDetailPageState extends State<SessionDetailPage> {
  // Declara uma variável tardia para armazenar a sessão
  late FrontSession _session;

  // Inicializa o estado do widget
  @override
  void initState() {
    super.initState();
    // Atribui a sessão do widget à variável local
    _session = widget.session;
  }

  // Constrói a interface do widget
  @override
  Widget build(BuildContext context) {
    // Obtém o controlador de versão do contexto
    final versionController = context.read<VersionController>();

    // Retorna um Scaffold com appBar e body
    return Scaffold(
      // Define a barra de aplicativo
      appBar: AppBar(
        // Define o título da appBar
        title: const Text('Detalhes da Sessão'),
        // Centraliza o título
        centerTitle: true,
        // Define as ações da appBar
        actions: [
          // Cria um botão de menu pop-up
          PopupMenuButton(
            // Define os itens do menu
            itemBuilder: (context) => [
              // Primeiro item: Editar
              PopupMenuItem(
                // Widget filho do item
                child: const Row(
                  children: [
                    // Ícone de edição em cor laranja
                    Icon(Icons.edit, color: Colors.orange),
                    // Espaçamento horizontal
                    SizedBox(width: 12),
                    // Texto do item
                    Text('Editar'),
                  ],
                ),
                // Callback quando o item é selecionado
                onTap: () {
                  // Navega para a página de edição
                  _navigateToEdit();
                },
              ),
              // Segundo item: Deletar
              PopupMenuItem(
                // Widget filho do item
                child: const Row(
                  children: [
                    // Ícone de deleção em cor vermelha
                    Icon(Icons.delete, color: Colors.red),
                    // Espaçamento horizontal
                    SizedBox(width: 12),
                    // Texto do item
                    Text('Deletar'),
                  ],
                ),
                // Callback quando o item é selecionado
                onTap: () {
                  // Mostra o diálogo de confirmação de deleção
                  _showDeleteDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
      // Define o corpo principal da página
      body: SingleChildScrollView(
        // Define o preenchimento interno
        padding: const EdgeInsets.all(16),
        // Define a coluna principal
        child: Column(
          // Alinha os filhos ao início horizontalmente
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Informações Gerais
            // Cria um card para informações básicas
            Card(
              child: Padding(
                // Define o preenchimento interno do card
                padding: const EdgeInsets.all(16),
                child: Column(
                  // Alinha os filhos ao início horizontalmente
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da seção
                    const Text(
                      'Informações Gerais',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Espaçamento vertical
                    const SizedBox(height: 16),
                    // Linha de informação dos alters
                    _buildInfoRow(
                      'Alters',
                      // Mapeia os IDs dos alters para seus nomes
                      _session.alters
                          .map((alterId) =>
                              versionController.getVersionById(alterId)?.name ??
                              'Desconhecido')
                          .join(', '),
                    ),
                    // Espaçamento vertical
                    const SizedBox(height: 12),
                    // Linha de informação do tipo
                    _buildInfoRow(
                      'Tipo',
                      _session.isCofront ? 'Co-front' : 'Simples',
                    ),
                    // Espaçamento vertical
                    const SizedBox(height: 12),
                    // Linha de informação da intensidade
                    _buildInfoRow(
                      'Intensidade',
                      '${_session.intensity}/5',
                    ),
                    // Espaçamento vertical
                    const SizedBox(height: 12),
                    // Linha de informação da data/hora de início
                    _buildInfoRow(
                      'Início',
                      TimeUtils.formatDateTime(_session.startTime),
                    ),
                    // Espaçamento vertical
                    const SizedBox(height: 12),
                    // Mostra a hora de fim se existir
                    if (_session.endTime != null)
                      _buildInfoRow(
                        'Fim',
                        TimeUtils.formatDateTime(_session.endTime!),
                      ),
                    // Espaçamento vertical condicional
                    if (_session.endTime != null) const SizedBox(height: 12),
                    // Mostra a duração se a sessão terminou
                    if (_session.endTime != null)
                      _buildInfoRow(
                        'Duração',
                        _calculateDuration(
                          _session.startTime,
                          _session.endTime,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Espaçamento vertical
            const SizedBox(height: 16),

            // Seção de Gatilhos
            // Mostra os gatilhos apenas se houver
            if (_session.triggers.isNotEmpty) ...[
              // Card para os gatilhos
              Card(
                child: Padding(
                  // Define o preenchimento interno do card
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    // Alinha os filhos ao início horizontalmente
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título da seção
                      const Text(
                        'Gatilhos',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Espaçamento vertical
                      const SizedBox(height: 12),
                      // Cria um layout envolvente para os chips
                      Wrap(
                        // Define o espaçamento entre chips
                        spacing: 8,
                        // Mapeia cada gatilho para um chip
                        children: _session.triggers
                            .map(
                              (trigger) => Chip(label: Text(trigger)),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
              // Espaçamento vertical
              const SizedBox(height: 16),
            ],

            // Seção de Notas
            // Mostra as notas apenas se houver
            if (_session.notes != null && _session.notes!.isNotEmpty)
              // Card para as notas
              Card(
                child: Padding(
                  // Define o preenchimento interno do card
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    // Alinha os filhos ao início horizontalmente
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título da seção
                      const Text(
                        'Notas',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Espaçamento vertical
                      const SizedBox(height: 12),
                      // Exibe o texto das notas
                      Text(_session.notes!),
                    ],
                  ),
                ),
              ),

            // Seção de Informações dos Alters
            // Espaçamento vertical
            const SizedBox(height: 16),
            // Título da seção
            const Text(
              'Informações dos Alters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Espaçamento vertical
            const SizedBox(height: 12),
            // Mapeia cada alter para um card
            ...(_session.alters.map((alterId) {
              // Obtém o alter pelo ID
              final alter = versionController.getVersionById(alterId);
              // Retorna um widget vazio se o alter não existe
              if (alter == null) return const SizedBox.shrink();

              // Card para cada alter
              return Card(
                // Define a margem do card
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  // Define o preenchimento interno do card
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    // Alinha os filhos ao início horizontalmente
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Linha com avatar e informações do alter
                      Row(
                        children: [
                          // Container para o avatar circular
                          Container(
                            width: 40,
                            height: 40,
                            // Define a decoração circular
                            decoration: BoxDecoration(
                              // Define a cor do fundo
                              color: _parseColor(alter.color),
                              // Define a forma como círculo
                              shape: BoxShape.circle,
                            ),
                            // Centraliza o conteúdo
                            child: Center(
                              // Exibe a primeira letra do nome em maiúscula
                              child: Text(
                                alter.name[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          // Espaçamento horizontal
                          const SizedBox(width: 12),
                          // Coluna com nome e pronome do alter
                          Column(
                            // Alinha os filhos ao início horizontalmente
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Exibe o nome do alter
                              Text(
                                alter.name,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Exibe o pronome se houver
                              if (alter.pronoun != null &&
                                  alter.pronoun!.isNotEmpty)
                                Text(
                                  alter.pronoun!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      // Espaçamento vertical
                      const SizedBox(height: 12),
                      // Seção de função do alter
                      if (alter.function != null &&
                          alter.function!.isNotEmpty) ...[
                        // Rótulo da função
                        const Text(
                          'Função',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        // Espaçamento vertical
                        const SizedBox(height: 4),
                        // Exibe a função
                        Text(alter.function!),
                        // Espaçamento vertical
                        const SizedBox(height: 12),
                      ],
                      // Seção de gostos do alter
                      if (alter.likes != null && alter.likes!.isNotEmpty) ...[
                        // Rótulo dos gostos
                        const Text(
                          'O que gosta',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        // Espaçamento vertical
                        const SizedBox(height: 4),
                        // Exibe os gostos
                        Text(alter.likes!),
                        // Espaçamento vertical
                        const SizedBox(height: 12),
                      ],
                      // Seção de desgostos do alter
                      if (alter.dislikes != null &&
                          alter.dislikes!.isNotEmpty) ...[
                        // Rótulo dos desgostos
                        const Text(
                          'O que desgosta',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        // Espaçamento vertical
                        const SizedBox(height: 4),
                        // Exibe os desgostos
                        Text(alter.dislikes!),
                      ],
                    ],
                  ),
                ),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  // Função para navegar para a página de edição
  void _navigateToEdit() {
    // Realiza a navegação para a página de edição
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SessionEditPage(session: _session),
      ),
    ).then((result) {
      // Verifica se a edição foi bem-sucedida
      if (result == true) {
        // Atualiza o estado da página
        setState(() {
          // Recarregar dados se necessário
        });
      }
    });
  }

  // Função para mostrar o diálogo de confirmação de deleção
  void _showDeleteDialog(BuildContext context) {
    // Exibe um diálogo de alerta
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // Título do diálogo
        title: const Text('Deletar Sessão'),
        // Conteúdo do diálogo
        content: const Text('Tem certeza que deseja deletar este registro?'),
        // Ações do diálogo
        actions: [
          // Botão de cancelamento
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          // Botão de confirmação de deleção
          TextButton(
            onPressed: () {
              // Fecha o diálogo
              Navigator.pop(context);
              // Chama o controlador para deletar a sessão
              context.read<SessionController>().deleteSession(_session.id);
              // Volta para a página anterior
              Navigator.pop(context);
              // Exibe uma mensagem de sucesso
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sessão deletada com sucesso')),
              );
            },
            child: const Text('Deletar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Função para calcular a duração da sessão
  String _calculateDuration(DateTime start, DateTime? end) {
    // Verifica se a sessão ainda está em andamento
    if (end == null) return 'Em andamento';
    // Calcula a diferença entre as datas
    final difference = end.difference(start);
    // Obtém o número de horas
    final hours = difference.inHours;
    // Obtém o número de minutos restantes
    final minutes = difference.inMinutes.remainder(60);
    // Formata o resultado com horas se houver
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    // Retorna apenas os minutos se não houver horas
    return '${minutes}m';
  }

  // Função para converter string de cor para objeto Color
  Color _parseColor(String colorString) {
    try {
      // Verifica se a string começa com #
      if (colorString.startsWith('#')) {
        // Converte de string hex para Color
        return Color(int.parse('FF${colorString.substring(1)}', radix: 16));
      } else if (colorString.startsWith('0x')) {
        // Converte de string 0x para Color
        return Color(int.parse(colorString));
      } else {
        // Tenta converter como hex sem prefixo
        return Color(int.parse('FF$colorString', radix: 16));
      }
    } catch (e) {
      // Retorna uma cor padrão em caso de erro
      return Colors.purple;
    }
  }

  // Função para construir uma linha de informação
  Widget _buildInfoRow(String label, String value) {
    // Retorna uma linha com rótulo e valor
    return Row(
      // Distribui o espaço entre os filhos
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Rótulo da informação
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        // Widget que pode encolher se necessário
        Flexible(
          // Exibe o valor da informação
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}