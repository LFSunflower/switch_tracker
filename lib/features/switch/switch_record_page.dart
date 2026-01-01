// Importa o pacote Material do Flutter para componentes de UI
import 'package:flutter/material.dart';
// Importa o pacote Provider para gerenciamento de estado
import 'package:provider/provider.dart';

// Importa o controller de sessão
import '../../controllers/session_controller.dart';
// Importa o controller de versão (alters)
import '../../controllers/version_controller.dart';
// Importa a utilidade de logger
import '../../core/utils/logger.dart';
// Importa o widget de card do alter atual
import '../home/widgets/current_front_card.dart';

// Classe principal da página de registro de switches (StatefulWidget)
class SwitchRecordPage extends StatefulWidget {
  // Construtor com super.key
  const SwitchRecordPage({super.key});

  // Cria o estado associado
  @override
  State<SwitchRecordPage> createState() => _SwitchRecordPageState();
}

// Classe de estado para SwitchRecordPage
class _SwitchRecordPageState extends State<SwitchRecordPage> {
  // Método build que constrói a interface
  @override
  Widget build(BuildContext context) {
    // Retorna um Scaffold como base da página
    return Scaffold(
      // Corpo da página com RefreshIndicator para atualizar
      body: RefreshIndicator(
        // Função chamada ao fazer pull-to-refresh
        onRefresh: () async {
          // Obtém o controller de sessão
          final sessionController = context.read<SessionController>();
          // Recarrega as sessões
          await sessionController.loadSessions();
        },
        // Widget filho que será recarregável
        child: SingleChildScrollView(
          // Permite scroll mesmo que o conteúdo seja menor que a tela
          physics: const AlwaysScrollableScrollPhysics(),
          // Espaçamento interno
          padding: const EdgeInsets.all(16),
          // Coluna para organizar elementos verticalmente
          child: Column(
            // Alinha elementos ao início horizontalmente
            crossAxisAlignment: CrossAxisAlignment.start,
            // Lista de widgets filhos
            children: [
              // Card que mostra a sessão atual (alter na frente)
              Consumer<SessionController>(
                // Builder que reconstrói quando SessionController muda
                builder: (context, sessionController, _) {
                  // Retorna o card com informações do alter atual
                  return CurrentFrontCard(
                    // Passa o controller para o widget
                    sessionController: sessionController,
                  );
                },
              ),
              // Espaçamento vertical de 24 pixels
              const SizedBox(height: 24),

              // Seção de informações sobre os alters ativos
              Consumer2<SessionController, VersionController>(
                // Builder que reconstrói quando ambos controllers mudam
                builder: (context, sessionController, versionController, _) {
                  // Obtém a sessão ativa
                  final activeSession = sessionController.activeSession;
                  // Se não houver sessão ativa ou não houver alters, retorna vazio
                  if (activeSession == null || activeSession.alters.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  // Mapeia os IDs dos alters para suas informações completas
                  final alterInfos = activeSession.alters
                      // Mapeia cada ID de alter para suas informações
                      .map((alterId) => versionController.getVersionById(alterId))
                      // Filtra apenas elementos válidos (não nulos)
                      .whereType<dynamic>()
                      // Converte para lista
                      .toList();

                  // Se não houver informações de alters, retorna vazio
                  if (alterInfos.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  // Retorna coluna com informações dos alters
                  return Column(
                    // Alinha elementos ao início horizontalmente
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Lista de widgets filhos
                    children: [
                      // Título da seção
                      const Text(
                        'Informações do Alter',
                        // Estilo do título
                        style: TextStyle(
                          // Tamanho da fonte
                          fontSize: 18,
                          // Peso da fonte em negrito
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Espaçamento vertical de 16 pixels
                      const SizedBox(height: 16),
                      // Mapeia cada alter para um card
                      ...alterInfos.map((alter) {
                        // Retorna um Card para cada alter
                        return Card(
                          // Conteúdo do card com padding
                          child: Padding(
                            // Espaçamento interno de 16 pixels
                            padding: const EdgeInsets.all(16),
                            // Coluna com informações do alter
                            child: Column(
                              // Alinha elementos ao início horizontalmente
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // Lista de widgets filhos
                              children: [
                                // Seção de nome e pronome do alter
                                Row(
                                  // Lista de widgets filhos
                                  children: [
                                    // Container com avatar circular
                                    Container(
                                      // Largura do container
                                      width: 40,
                                      // Altura do container
                                      height: 40,
                                      // Decoração do container
                                      decoration: BoxDecoration(
                                        // Cor de fundo baseada na cor do alter
                                        color: _parseColor(alter.color),
                                        // Forma circular
                                        shape: BoxShape.circle,
                                      ),
                                      // Widget para centralizar o conteúdo
                                      child: Center(
                                        // Texto com primeira letra do nome
                                        child: Text(
                                          // Pega primeira letra do nome em maiúscula
                                          alter.name[0].toUpperCase(),
                                          // Estilo do texto
                                          style: const TextStyle(
                                            // Cor do texto em branco
                                            color: Colors.white,
                                            // Peso da fonte em negrito
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Espaçamento horizontal de 12 pixels
                                    const SizedBox(width: 12),
                                    // Coluna com nome e pronome
                                    Column(
                                      // Alinha elementos ao início horizontalmente
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // Lista de widgets filhos
                                      children: [
                                        // Texto com nome do alter
                                        Text(
                                          // Nome do alter
                                          alter.name,
                                          // Estilo do texto
                                          style: const TextStyle(
                                            // Tamanho da fonte
                                            fontSize: 16,
                                            // Peso da fonte em negrito
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        // Verifica se pronome existe e não é vazio
                                        if (alter.pronoun != null &&
                                            alter.pronoun!.isNotEmpty)
                                          // Texto com pronome do alter
                                          Text(
                                            // Pronome do alter
                                            alter.pronoun!,
                                            // Estilo do texto
                                            style: const TextStyle(
                                              // Tamanho da fonte
                                              fontSize: 12,
                                              // Cor cinzenta
                                              color: Colors.grey,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                                // Espaçamento vertical de 16 pixels
                                const SizedBox(height: 16),

                                // Seção de descrição do alter
                                // Verifica se descrição existe e não é vazia
                                if (alter.description != null &&
                                    alter.description!.isNotEmpty) ...[
                                  // Título da seção
                                  const Text(
                                    'Descrição',
                                    // Estilo do título
                                    style: TextStyle(
                                      // Tamanho da fonte
                                      fontSize: 12,
                                      // Peso da fonte em negrito
                                      fontWeight: FontWeight.bold,
                                      // Cor cinzenta
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // Espaçamento vertical de 4 pixels
                                  const SizedBox(height: 4),
                                  // Texto com descrição
                                  Text(alter.description!),
                                  // Espaçamento vertical de 12 pixels
                                  const SizedBox(height: 12),
                                ],

                                // Seção de função do alter
                                // Verifica se função existe e não é vazia
                                if (alter.function != null &&
                                    alter.function!.isNotEmpty) ...[
                                  // Título da seção
                                  const Text(
                                    'Função',
                                    // Estilo do título
                                    style: TextStyle(
                                      // Tamanho da fonte
                                      fontSize: 12,
                                      // Peso da fonte em negrito
                                      fontWeight: FontWeight.bold,
                                      // Cor cinzenta
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // Espaçamento vertical de 4 pixels
                                  const SizedBox(height: 4),
                                  // Texto com função
                                  Text(alter.function!),
                                  // Espaçamento vertical de 12 pixels
                                  const SizedBox(height: 12),
                                ],

                                // Seção de gostos do alter
                                // Verifica se gostos existem e não estão vazios
                                if (alter.likes != null &&
                                    alter.likes!.isNotEmpty) ...[
                                  // Título da seção com emoji
                                  const Text(
                                    'O que gosta 💚',
                                    // Estilo do título
                                    style: TextStyle(
                                      // Tamanho da fonte
                                      fontSize: 12,
                                      // Peso da fonte em negrito
                                      fontWeight: FontWeight.bold,
                                      // Cor cinzenta
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // Espaçamento vertical de 4 pixels
                                  const SizedBox(height: 4),
                                  // Texto com gostos
                                  Text(alter.likes!),
                                  // Espaçamento vertical de 12 pixels
                                  const SizedBox(height: 12),
                                ],

                                // Seção de desgostos do alter
                                // Verifica se desgostos existem e não estão vazios
                                if (alter.dislikes != null &&
                                    alter.dislikes!.isNotEmpty) ...[
                                  // Título da seção com emoji
                                  const Text(
                                    'O que desgosta 💔',
                                    // Estilo do título
                                    style: TextStyle(
                                      // Tamanho da fonte
                                      fontSize: 12,
                                      // Peso da fonte em negrito
                                      fontWeight: FontWeight.bold,
                                      // Cor cinzenta
                                      color: Colors.grey,
                                    ),
                                  ),
                                  // Espaçamento vertical de 4 pixels
                                  const SizedBox(height: 4),
                                  // Texto com desgostos
                                  Text(alter.dislikes!),
                                  // Espaçamento vertical de 12 pixels
                                  const SizedBox(height: 12),
                                ],

                                // Seção de instruções de segurança
                                // Verifica se instruções existem e não estão vazias
                                if (alter.safetyInstructions != null &&
                                    alter.safetyInstructions!.isNotEmpty) ...[
                                  // Título da seção com emoji de aviso
                                  const Text(
                                    '⚠️ Instruções de Segurança',
                                    // Estilo do título
                                    style: TextStyle(
                                      // Tamanho da fonte
                                      fontSize: 12,
                                      // Peso da fonte em negrito
                                      fontWeight: FontWeight.bold,
                                      // Cor vermelha
                                      color: Colors.red,
                                    ),
                                  ),
                                  // Espaçamento vertical de 4 pixels
                                  const SizedBox(height: 4),
                                  // Container com instruções destacadas
                                  Container(
                                    // Espaçamento interno de 8 pixels
                                    padding: const EdgeInsets.all(8),
                                    // Decoração do container
                                    decoration: BoxDecoration(
                                      // Cor de fundo vermelha semi-transparente
                                      color: Colors.red.withOpacity(0.1),
                                      // Borda vermelha
                                      border: Border.all(color: Colors.red),
                                      // Bordas arredondadas
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    // Texto com instruções de segurança
                                    child: Text(
                                      // Instruções de segurança
                                      alter.safetyInstructions!,
                                      // Estilo do texto
                                      style: const TextStyle(
                                        // Cor vermelha
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // Botão flutuante para criar novo switch
      floatingActionButton: FloatingActionButton(
        // Função chamada ao pressionar o botão
        onPressed: () async {
          final sessionController = context.read<SessionController>();
          
          if (sessionController.activeSession != null) {
            final decision = await showDialog<String>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Sessão em andamento'),
                content: const Text('Já existe uma sessão ativa. O que deseja fazer?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'new'),
                    child: const Text('Nova Sessão Simples'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'cofront'),
                    child: const Text('Transformar em Co-front'),
                  ),
                ],
              ),
            );

            if (decision == null) return;

            if (decision == 'cofront') {
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (context) => _SwitchFormDialog(
                    initialAlters: sessionController.activeSession!.alters,
                    isCoFront: true,
                  ),
                );
              }
            } else {
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (context) => const _SwitchFormDialog(),
                );
              }
            }
          } else {
            showDialog(
              context: context,
              builder: (context) => const _SwitchFormDialog(),
            );
          }
        },
        // Texto que aparece ao manter pressionado
        tooltip: 'Novo Switch',
        // Ícone do botão (mais)
        child: const Icon(Icons.add),
      ),
    );
  }

  // Método que converte string de cor para objeto Color
  Color _parseColor(String colorString) {
    // Tenta fazer o parsing da cor
    try {
      // Verifica se a string começa com #
      if (colorString.startsWith('#')) {
        // Converte formato #RRGGBB para Color
        return Color(int.parse('FF${colorString.substring(1)}', radix: 16));
      } else if (colorString.startsWith('0x')) {
        // Converte formato 0xAARRGGBB para Color
        return Color(int.parse(colorString));
      } else {
        // Converte formato RRGGBB para Color
        return Color(int.parse('FF$colorString', radix: 16));
      }
    } catch (e) {
      // Retorna cor padrão (roxo) em caso de erro
      return Colors.purple;
    }
  }
}

// Classe do diálogo para registrar novo switch (StatefulWidget)
class _SwitchFormDialog extends StatefulWidget {
  final List<String>? initialAlters;
  final bool isCoFront;

  // Construtor
  const _SwitchFormDialog({this.initialAlters, this.isCoFront = false});

  // Cria o estado associado
  @override
  State<_SwitchFormDialog> createState() => _SwitchFormDialogState();
}

// Classe de estado para _SwitchFormDialog
class _SwitchFormDialogState extends State<_SwitchFormDialog> {
  // Lista de IDs dos alters selecionados
  late final List<String> _selectedAlterIds;
  // Intensidade do switch de 1 a 5
  int _intensity = 3;
  // Lista de gatilhos selecionados
  final List<String> _selectedTriggers = [];
  // Indica se é um co-front (mais de um alter)
  late bool _isCoFront;

  @override
  void initState() {
    super.initState();
    _selectedAlterIds = widget.initialAlters != null ? List.from(widget.initialAlters!) : [];
    _isCoFront = widget.isCoFront;
  }
  // Notas adicionais do switch
  String _notes = '';
  // Indica se está enviando dados
  bool _isSubmitting = false;

  // Lista de gatilhos disponíveis para seleção
  final List<String> _availableTriggers = [
    'Stress',
    'Trauma',
    'Ansiedade',
    'Atividade Específica',
    'Interação Social',
    'Mudança de Ambiente',
    'Cansaço',
    'Ruídos Altos',
    'Luz Intensa',
    'Contato Físico',
    'Conversas Difíceis',
    'Horários Específicos',
  ];

  // Método que submete o novo switch
  void _submitSwitch() async {
    final sessionController = context.read<SessionController>();

    if (_selectedAlterIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um alter')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      await sessionController.startNewSession(
        alterIds: _selectedAlterIds,
        intensity: _intensity,
        triggers: _selectedTriggers,
        notes: _notes.isEmpty ? null : _notes,
        isCoFront: _isCoFront,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Switch registrado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      // Trata erros
      if (mounted) {
        // Mostra mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            // Conteúdo da mensagem
            content: Text('Erro ao registrar switch: $e'),
            // Duração da mensagem
            duration: const Duration(seconds: 3),
          ),
        );
        // Log de erro com stack trace
        AppLogger.error('Erro ao registrar switch: $e', StackTrace.current);
      }
    } finally {
      // Finaliza o carregamento
      if (mounted) {
        // Atualiza estado para parar de carregar
        setState(() => _isSubmitting = false);
      }
    }
  }



  // Método build que constrói o diálogo
  @override
  Widget build(BuildContext context) {
    // Retorna um Dialog
    return Dialog(
      // Conteúdo do diálogo com scroll
      child: SingleChildScrollView(
        // Padding interno
        child: Padding(
          // Espaçamento interno de 16 pixels
          padding: const EdgeInsets.all(16),
          // Coluna com conteúdo do formulário
          child: Column(
            // Reduz o tamanho ao mínimo necessário
            mainAxisSize: MainAxisSize.min,
            // Alinha elementos ao início horizontalmente
            crossAxisAlignment: CrossAxisAlignment.start,
            // Lista de widgets filhos
            children: [
              // Título do formulário
              const Text(
                'Registrar Novo Switch',
                // Estilo do título
                style: TextStyle(
                  // Tamanho da fonte
                  fontSize: 18,
                  // Peso da fonte em negrito
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Espaçamento vertical de 16 pixels
              const SizedBox(height: 16),

              // Seção de seleção de alters
              // Rótulo da seção
              const Text(
                'Qual alter está no controle? *',
                // Estilo do rótulo
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Espaçamento vertical de 8 pixels
              const SizedBox(height: 8),
              // Consumer que ouve mudanças no VersionController
              Consumer<VersionController>(
                // Builder que reconstrói quando VersionController muda
                builder: (context, versionController, _) {
                  // Obtém todos os alters disponíveis
                  final versions = versionController.allVersions;
                  // Verifica se não há alters disponíveis
                  if (versions.isEmpty) {
                    // Retorna mensagem informando que não há alters
                    return const Padding(
                      // Espaçamento interno
                      padding: EdgeInsets.all(16),
                      // Texto informativo
                      child: Text('Nenhum alter disponível'),
                    );
                  }

                  // Retorna wrap com chips para cada alter
                  return Wrap(
                    // Espaçamento entre chips
                    spacing: 8,
                    // Lista de chips para cada alter
                    children: versions
                        .map(
                          // Cria FilterChip para cada alter
                          (version) => FilterChip(
                            // Verifica se o alter está selecionado
                            selected: _selectedAlterIds.contains(version.id),
                            // Rótulo com nome do alter
                            label: Text(version.name),
                            // Função chamada ao selecionar/desselecionar
                            onSelected: (isSelected) {
                              // Atualiza estado
                              setState(() {
                                // Se foi selecionado, adiciona à lista
                                if (isSelected) {
                                  _selectedAlterIds.add(version.id);
                                } else {
                                  // Senão, remove da lista
                                  _selectedAlterIds.remove(version.id);
                                }
                              });
                            },
                          ),
                        )
                        // Converte para lista
                        .toList(),
                  );
                },
              ),
              // Espaçamento vertical de 16 pixels
              const SizedBox(height: 16),

              // Seção de co-front
              CheckboxListTile(
                // Rótulo principal
                title: const Text('É um co-front?'),
                // Subrótulo explicativo
                subtitle: const Text('Mais de um alter no controle'),
                // Estado do checkbox
                value: _isCoFront,
                // Função chamada ao mudar o estado
                onChanged: (value) {
                  // Atualiza estado
                  setState(() => _isCoFront = value ?? false);
                },
              ),
              // Espaçamento vertical de 16 pixels
              const SizedBox(height: 16),

              // Seção de intensidade
              // Texto mostrando intensidade selecionada
              Text(
                'Intensidade: $_intensity/5',
                // Estilo do texto
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              // Slider para selecionar intensidade
              Slider(
                // Valor atual
                value: _intensity.toDouble(),
                // Valor mínimo
                min: 1,
                // Valor máximo
                max: 5,
                // Número de divisões (4 para 5 valores)
                divisions: 4,
                // Função chamada ao mudar o slider
                onChanged: (value) {
                  // Atualiza estado com novo valor
                  setState(() => _intensity = value.toInt());
                },
              ),
              // Espaçamento vertical de 16 pixels
              const SizedBox(height: 16),

              // Seção de seleção de gatilhos
              // Rótulo da seção
              const Text(
                'Gatilhos (opcional)',
                // Estilo do rótulo
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              // Espaçamento vertical de 8 pixels
              const SizedBox(height: 8),
              // Wrap com chips para cada gatilho
              Wrap(
                // Espaçamento entre chips
                spacing: 8,
                // Lista de chips para cada gatilho disponível
                children: _availableTriggers
                    .map(
                      // Cria FilterChip para cada gatilho
                      (trigger) => FilterChip(
                        // Verifica se o gatilho está selecionado
                        selected: _selectedTriggers.contains(trigger),
                        // Rótulo com nome do gatilho
                        label: Text(trigger),
                        // Função chamada ao selecionar/desselecionar
                        onSelected: (isSelected) {
                          // Atualiza estado
                          setState(() {
                            // Se foi selecionado, adiciona à lista
                            if (isSelected) {
                              _selectedTriggers.add(trigger);
                            } else {
                              // Senão, remove da lista
                              _selectedTriggers.remove(trigger);
                            }
                          });
                        },
                      ),
                    )
                    // Converte para lista
                    .toList(),
              ),
              // Espaçamento vertical de 16 pixels
              const SizedBox(height: 16),

              // Seção de notas
              TextField(
                // Número máximo de linhas
                maxLines: 3,
                // Função chamada ao mudar o texto
                onChanged: (value) => _notes = value,
                // Decoração do campo
                decoration: InputDecoration(
                  // Rótulo do campo
                  labelText: 'Notas (opcional)',
                  // Borda do campo
                  border: OutlineInputBorder(
                    // Bordas arredondadas
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Placeholder do campo
                  hintText: 'Adicione observações...',
                ),
              ),
              // Espaçamento vertical de 16 pixels
              const SizedBox(height: 16),

              // Seção de botões
              Row(
                // Alinha botões à direita
                mainAxisAlignment: MainAxisAlignment.end,
                // Lista de widgets filhos
                children: [
                  // Botão de cancelar
                  TextButton(
                    // Função ao pressionar
                    onPressed: () => Navigator.pop(context),
                    // Rótulo do botão
                    child: const Text('Cancelar'),
                  ),
                  // Espaçamento horizontal de 8 pixels
                  const SizedBox(width: 8),
                  // Botão de registrar
                  ElevatedButton.icon(
                    // Desabilita botão se está submetendo
                    onPressed: _isSubmitting ? null : _submitSwitch,
                    // Ícone do botão (muda se está carregando)
                    icon: _isSubmitting
                        // Circular loading enquanto submete
                        ? const SizedBox(
                            // Largura do spinner
                            width: 16,
                            // Altura do spinner
                            height: 16,
                            // Spinner circular
                            child: CircularProgressIndicator(
                              // Largura do traço
                              strokeWidth: 2,
                            ),
                          )
                        // Ícone de check quando não está submetendo
                        : const Icon(Icons.check),
                    // Rótulo do botão (muda se está carregando)
                    label: Text(
                      // Texto muda se está submetendo
                      _isSubmitting ? 'Registrando...' : 'Registrar',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}