// Importa o pacote Flutter Material para componentes de UI
import 'package:flutter/material.dart';
// Importa o pacote Provider para gerenciamento de estado
import 'package:provider/provider.dart';

// Importa o controlador de sessões
import '../../controllers/session_controller.dart';
// Importa o controlador de versões (alters)
import '../../controllers/version_controller.dart';
// Importa o utilitário de logging
import '../../core/utils/logger.dart';
// Importa o modelo de sessão
import '../../data/models/front_session.dart';

// Define a página de edição de sessão como um StatefulWidget
class SessionEditPage extends StatefulWidget {
  // Propriedade que armazena a sessão a ser editada
  final FrontSession session;

  // Construtor da página
  const SessionEditPage({
    super.key,
    required this.session,
  });

  // Cria o estado da página
  @override
  State<SessionEditPage> createState() => _SessionEditPageState();
}

// Classe de estado que gerencia os dados e a lógica da página
class _SessionEditPageState extends State<SessionEditPage> {
  // Lista dos IDs dos alters selecionados
  late List<String> _selectedAlterIds;
  // Nível de intensidade da sessão (1-5)
  late int _intensity;
  // Lista de gatilhos selecionados
  late List<String> _selectedTriggers;
  // Indica se é um co-front (mais de um alter no controle)
  late bool _isCoFront;
  // Notas adicionais da sessão
  late String _notes;
  // Data e hora de início da sessão
  late DateTime _startTime;
  // Data e hora de fim da sessão (opcional)
  late DateTime? _endTime;
  // Flag para indicar se está enviando os dados
  bool _isSubmitting = false;

  // Lista com todos os gatilhos disponíveis
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

  // Método chamado quando o widget é inserido na árvore
  @override
  void initState() {
    // Chama o initState da classe pai
    super.initState();
    // Inicializa a lista de alters selecionados com os dados da sessão
    _selectedAlterIds = List.from(widget.session.alters);
    // Inicializa a intensidade com o valor da sessão
    _intensity = widget.session.intensity;
    // Inicializa os gatilhos selecionados com os dados da sessão
    _selectedTriggers = List.from(widget.session.triggers);
    // Inicializa o flag de co-front com o valor da sessão
    _isCoFront = widget.session.isCofront;
    // Inicializa as notas com o valor da sessão ou string vazia
    _notes = widget.session.notes ?? '';
    // Inicializa a hora de início com o valor da sessão
    _startTime = widget.session.startTime;
    // Inicializa a hora de fim com o valor da sessão
    _endTime = widget.session.endTime;
  }

  // Método que submete as alterações da sessão
  void _submitChanges() async {
    // Valida se pelo menos um alter foi selecionado
    if (_selectedAlterIds.isEmpty) {
      // Mostra mensagem de erro se nenhum alter foi selecionado
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione pelo menos um alter')),
      );
      // Retorna sem continuar a execução
      return;
    }

    // Define o estado de carregamento como ativo
    setState(() => _isSubmitting = true);

    // Bloco try para tratamento de erros
    try {
      // Obtém o controlador de sessões do contexto
      final sessionController = context.read<SessionController>();

      // Registra no log que está atualizando a sessão
      AppLogger.info(
        'Atualizando sessão: ${widget.session.id}',
      );

      // Chama o método de atualização de sessão no controlador
      final success = await sessionController.updateSession(
        // ID da sessão a ser atualizada
        sessionId: widget.session.id,
        // Lista de IDs dos alters
        alterIds: _selectedAlterIds,
        // Nível de intensidade
        intensity: _intensity,
        // Gatilhos selecionados
        triggers: _selectedTriggers,
        // Notas (null se vazio)
        notes: _notes.isEmpty ? null : _notes,
        // Flag de co-front
        isCofront: _isCoFront,
        // Hora de início
        startTime: _startTime,
        // Hora de fim
        endTime: _endTime,
      );

      // Verifica se o widget ainda está montado na árvore
      if (mounted) {
        // Se a atualização foi bem-sucedida
        if (success) {
          // Mostra mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sessão atualizada com sucesso!')),
          );
          // Volta para a página anterior e retorna true
          Navigator.pop(context, true);
        } else {
          // Se houve erro, mostra mensagem com a descrição do erro
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro: ${sessionController.errorMessage}'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Captura qualquer exceção durante a execução
      if (mounted) {
        // Mostra mensagem de erro ao usuário
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar sessão: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
        // Registra o erro no log com o stack trace
        AppLogger.error('Erro ao atualizar sessão: $e', StackTrace.current);
      }
    } finally {
      // Sempre executado ao final, mesmo se houver erro
      if (mounted) {
        // Define o estado de carregamento como inativo
        setState(() => _isSubmitting = false);
      }
    }
  }

  // Método para selecionar a data e hora de início
  Future<void> _selectStartTime() async {
    // Abre o seletor de data
    final selectedDate = await showDatePicker(
      context: context,
      // Data inicial é a data de início atual
      initialDate: _startTime,
      // Data mínima permitida
      firstDate: DateTime(2020),
      // Data máxima permitida é hoje
      lastDate: DateTime.now(),
    );

    // Se uma data foi selecionada e o widget está montado
    if (selectedDate != null && mounted) {
      // Abre o seletor de hora
      final selectedTime = await showTimePicker(
        context: context,
        // Hora inicial é a hora de início atual
        initialTime: TimeOfDay.fromDateTime(_startTime),
      );

      // Se uma hora foi selecionada
      if (selectedTime != null) {
        // Atualiza o estado com a data e hora selecionadas
        setState(() {
          // Combina a data selecionada com a hora selecionada
          _startTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  // Método para selecionar a data e hora de fim
  Future<void> _selectEndTime() async {
    // Abre o seletor de data
    final selectedDate = await showDatePicker(
      context: context,
      // Data inicial é a data de fim ou hoje
      initialDate: _endTime ?? DateTime.now(),
      // Data mínima permitida
      firstDate: DateTime(2020),
      // Data máxima permitida é hoje
      lastDate: DateTime.now(),
    );

    // Se uma data foi selecionada e o widget está montado
    if (selectedDate != null && mounted) {
      // Abre o seletor de hora
      final selectedTime = await showTimePicker(
        context: context,
        // Hora inicial é a hora de fim ou hora atual
        initialTime: TimeOfDay.fromDateTime(_endTime ?? DateTime.now()),
      );

      // Se uma hora foi selecionada
      if (selectedTime != null) {
        // Atualiza o estado com a data e hora de fim selecionadas
        setState(() {
          // Combina a data selecionada com a hora selecionada
          _endTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  // Método que constrói a interface da página
  @override
  Widget build(BuildContext context) {
    // Retorna um Scaffold que é a estrutura base de uma página
    return Scaffold(
      // Define o app bar (barra superior)
      appBar: AppBar(
        // Título da página
        title: const Text('Editar Sessão'),
        // Centraliza o título
        centerTitle: true,
      ),
      // Define o corpo da página com scroll
      body: SingleChildScrollView(
        // Define o padding em todos os lados
        padding: const EdgeInsets.all(16),
        // Define uma coluna com os elementos da página
        child: Column(
          // Alinha os filhos ao início horizontal
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== SEÇÃO: SELETOR DE ALTERS =====
            // Texto do título da seção
            const Text(
              'Alters no Controle *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Espaçamento vertical
            const SizedBox(height: 8),
            // Consumer que observa mudanças no VersionController
            Consumer<VersionController>(
              // Builder que reconstrói quando há mudanças
              builder: (context, versionController, _) {
                // Obtém a lista de todas as versões (alters)
                final versions = versionController.allVersions;
                // Se não há versões disponíveis
                if (versions.isEmpty) {
                  // Mostra mensagem informando que não há alters
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nenhum alter disponível'),
                  );
                }

                // Cria um widget Wrap para mostrar os alters como chips
                return Wrap(
                  // Espaçamento entre os chips
                  spacing: 8,
                  // Mapeia cada versão para um FilterChip
                  children: versions
                      .map(
                        (version) => FilterChip(
                          // Define se o chip está selecionado
                          selected: _selectedAlterIds.contains(version.id),
                          // Texto do chip
                          label: Text(version.name),
                          // Callback quando o chip é selecionado/deselcionado
                          onSelected: (isSelected) {
                            // Atualiza o estado
                            setState(() {
                              // Se foi selecionado, adiciona à lista
                              if (isSelected) {
                                _selectedAlterIds.add(version.id);
                              } else {
                                // Se foi deselcionado, remove da lista
                                _selectedAlterIds.remove(version.id);
                              }
                            });
                          },
                        ),
                      )
                      // Converte o mapa para lista
                      .toList(),
                );
              },
            ),
            // Espaçamento vertical
            const SizedBox(height: 24),

            // ===== SEÇÃO: CO-FRONT =====
            // Checkbox para indicar se é um co-front
            CheckboxListTile(
              // Título do checkbox
              title: const Text('É um co-front?'),
              // Subtítulo explicativo
              subtitle: const Text('Mais de um alter no controle'),
              // Valor atual do checkbox
              value: _isCoFront,
              // Callback quando o checkbox é alterado
              onChanged: (value) {
                // Atualiza o estado com o novo valor
                setState(() => _isCoFront = value ?? false);
              },
            ),
            // Espaçamento vertical
            const SizedBox(height: 16),

            // ===== SEÇÃO: INTENSIDADE =====
            // Texto mostrando a intensidade atual
            Text(
              'Intensidade: $_intensity/5',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            // Slider para selecionar a intensidade
            Slider(
              // Valor atual do slider
              value: _intensity.toDouble(),
              // Valor mínimo
              min: 1,
              // Valor máximo
              max: 5,
              // Número de divisões (4 passos entre 1-5)
              divisions: 4,
              // Callback quando o slider é movido
              onChanged: (value) {
                // Atualiza o estado com o novo valor convertido para int
                setState(() => _intensity = value.toInt());
              },
            ),
            // Espaçamento vertical
            const SizedBox(height: 24),

            // ===== SEÇÃO: HORÁRIO DE INÍCIO =====
            // Card contendo o seletor de hora de início
            Card(
              child: ListTile(
                // Ícone de relógio
                leading: const Icon(Icons.access_time),
                // Título do tile
                title: const Text('Hora de Início'),
                // Subtítulo mostrando a data e hora formatadas
                subtitle: Text(
                  '${_startTime.day}/${_startTime.month}/${_startTime.year} ${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
                ),
                // Callback quando o tile é tocado
                onTap: _selectStartTime,
              ),
            ),
            // Espaçamento vertical
            const SizedBox(height: 12),

            // ===== SEÇÃO: HORÁRIO DE FIM =====
            // Card contendo o seletor de hora de fim
            Card(
              child: ListTile(
                // Ícone de relógio
                leading: const Icon(Icons.access_time),
                // Título do tile
                title: const Text('Hora de Fim'),
                // Subtítulo mostrando a data e hora ou "Não definido"
                subtitle: _endTime != null
                    ? Text(
                        '${_endTime!.day}/${_endTime!.month}/${_endTime!.year} ${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}',
                      )
                    : const Text('Não definido'),
                // Ícone de limpeza se uma hora foi definida
                trailing: _endTime != null
                    ? IconButton(
                        // Ícone de fechar
                        icon: const Icon(Icons.clear),
                        // Callback para limpar a hora de fim
                        onPressed: () {
                          // Atualiza o estado removendo a hora de fim
                          setState(() => _endTime = null);
                        },
                      )
                    : null,
                // Callback quando o tile é tocado
                onTap: _selectEndTime,
              ),
            ),
            // Espaçamento vertical
            const SizedBox(height: 24),

            // ===== SEÇÃO: SELETOR DE GATILHOS =====
            // Texto do título da seção
            const Text(
              'Gatilhos (opcional)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            // Espaçamento vertical
            const SizedBox(height: 8),
            // Widget Wrap para mostrar os gatilhos como chips
            Wrap(
              // Espaçamento entre os chips
              spacing: 8,
              // Mapeia cada gatilho para um FilterChip
              children: _availableTriggers
                  .map(
                    (trigger) => FilterChip(
                      // Define se o chip está selecionado
                      selected: _selectedTriggers.contains(trigger),
                      // Texto do chip
                      label: Text(trigger),
                      // Callback quando o chip é selecionado/deselcionado
                      onSelected: (isSelected) {
                        // Atualiza o estado
                        setState(() {
                          // Se foi selecionado, adiciona à lista
                          if (isSelected) {
                            _selectedTriggers.add(trigger);
                          } else {
                            // Se foi deselcionado, remove da lista
                            _selectedTriggers.remove(trigger);
                          }
                        });
                      },
                    ),
                  )
                  // Converte o mapa para lista
                  .toList(),
            ),
            // Espaçamento vertical
            const SizedBox(height: 24),

            // ===== SEÇÃO: NOTAS =====
            // Campo de texto para editar as notas
            TextField(
              // Número máximo de linhas
              maxLines: 4,
              // Controller com o texto inicial das notas
              controller: TextEditingController(text: _notes),
              // Callback quando o texto é alterado
              onChanged: (value) => _notes = value,
              // Decoração do campo de texto
              decoration: InputDecoration(
                // Label do campo
                labelText: 'Notas (opcional)',
                // Borda do campo
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // Texto de dica
                hintText: 'Adicione observações...',
              ),
            ),
            // Espaçamento vertical
            const SizedBox(height: 24),

            // ===== SEÇÃO: BOTÕES =====
            // Row contendo os botões de ação
            Row(
              children: [
                // Botão de cancelar
                Expanded(
                  child: OutlinedButton.icon(
                    // Callback para voltar sem salvar
                    onPressed: () => Navigator.pop(context),
                    // Ícone do botão
                    icon: const Icon(Icons.close),
                    // Texto do botão
                    label: const Text('Cancelar'),
                  ),
                ),
                // Espaçamento horizontal entre os botões
                const SizedBox(width: 12),
                // Botão de salvar alterações
                Expanded(
                  child: ElevatedButton.icon(
                    // Callback para salvar, desabilitado se está enviando
                    onPressed: _isSubmitting ? null : _submitChanges,
                    // Ícone que muda dependendo do estado de carregamento
                    icon: _isSubmitting
                        ? const SizedBox(
                            // Se está enviando, mostra um indicador de progresso
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    // Texto que muda dependendo do estado de carregamento
                    label: Text(
                      _isSubmitting ? 'Salvando...' : 'Salvar Alterações',
                    ),
                  ),
                ),
              ],
            ),
            // Espaçamento vertical final
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}