// Importação do pacote Flutter Material Design
import 'package:flutter/material.dart';
// Importação do pacote Provider para gerenciamento de estado
import 'package:provider/provider.dart';

// Importação do controlador de sessão
import '../../controllers/session_controller.dart';
// Importação do controlador de usuário
import '../../controllers/user_controller.dart';
// Importação do controlador de versão
import '../../controllers/version_controller.dart';
// Importação do utilitário de logging
import '../../core/utils/logger.dart';
// Importação da página de alters
import '../alters/alters_page.dart';
// Importação da página de histórico
import '../history/history_page.dart';
// Importação da página de perfil
import '../profile/profile_page.dart';
// Importação da página de configurações
import '../settings/settings_page.dart';
// Importação da página de registro de switch
import '../switch/switch_record_page.dart';

// Definição do widget stateful HomePage
class HomePage extends StatefulWidget {
  // Construtor da HomePage
  const HomePage({super.key});

  // Criação do estado da HomePage
  @override
  State<HomePage> createState() => _HomePageState();
}

// Classe de estado da HomePage
class _HomePageState extends State<HomePage> {
  // Variável que armazena o índice da página selecionada
  int _selectedIndex = 0;

  // Lista de páginas que serão exibidas no corpo da aplicação
  final List<Widget> _pages = const [
    SwitchRecordPage(),
    AltersPage(),
    HistoryPage(),
  ];

  // Lista de títulos correspondentes a cada página
  final List<String> _titles = [
    'Switch Tracker',
    'Meus Alters',
    'Histórico',
  ];

  // Inicialização do estado do widget
  @override
  void initState() {
    // Chama o initState da classe pai
    super.initState();
    // Agenda o carregamento de dados após o primeiro frame ser renderizado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  // Método assíncrono para carregar dados iniciais
  Future<void> _loadInitialData() async {
    // Tenta executar o bloco de código
    try {
      // Obtém a instância do VersionController usando Provider
      final versionController = context.read<VersionController>();
      // Obtém a instância do SessionController usando Provider
      final sessionController = context.read<SessionController>();

      // Registra no log que está carregando dados iniciais
      AppLogger.info('Carregando dados iniciais...');

      // Aguarda o carregamento das versões
      await versionController.loadVersions();
      // Aguarda o carregamento das sessões
      await sessionController.loadSessions();

      // Registra no log que os dados foram carregados com sucesso
      AppLogger.info('Dados iniciais carregados com sucesso');
    } catch (e) {
      // Registra erro no log com stack trace
      AppLogger.error('Erro ao carregar dados iniciais: $e', StackTrace.current);
      // Verifica se o widget ainda está montado
      if (mounted) {
        // Exibe um SnackBar com mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  // Método para exibir o diálogo de logout
  void _showLogoutDialog() {
    // Exibe um diálogo de alerta
    showDialog(
      context: context,
      // Construtor do conteúdo do diálogo
      builder: (context) => AlertDialog(
        // Título do diálogo
        title: const Text('Sair'),
        // Conteúdo do diálogo
        content: const Text('Tem certeza que deseja sair?'),
        // Lista de ações do diálogo
        actions: [
          // Botão de cancelar
          TextButton(
            // Ação ao pressionar: fecha o diálogo
            onPressed: () => Navigator.pop(context),
            // Texto do botão
            child: const Text('Cancelar'),
          ),
          // Botão de confirmação de logout
          TextButton(
            // Ação ao pressionar: fecha o diálogo e faz logout
            onPressed: () {
              // Fecha o diálogo
              Navigator.pop(context);
              // Chama o método logout do UserController
              context.read<UserController>().logout();
            },
            // Texto do botão em vermelho
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Método de construção da interface
  @override
  Widget build(BuildContext context) {
    // Retorna um Scaffold (estrutura básica de layout)
    return Scaffold(
      // Barra de aplicação no topo
      appBar: AppBar(
        // Título da AppBar baseado no índice selecionado
        title: Text(_titles[_selectedIndex]),
        // Centraliza o título
        centerTitle: true,
        // Remove a sombra da AppBar
        elevation: 0,
        // Ações na AppBar (lado direito)
        actions: [
          // Menu popup com opções
          PopupMenuButton<String>(
            // Construtor dos itens do menu
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // Item de perfil
              PopupMenuItem<String>(
                // Valor do item
                value: 'profile',
                // Conteúdo do item (ícone e texto)
                child: const Row(
                  children: [
                    // Ícone de pessoa em azul
                    Icon(Icons.person, color: Colors.blue),
                    // Espaço horizontal
                    SizedBox(width: 12),
                    // Texto do item
                    Text('Perfil'),
                  ],
                ),
                // Ação ao tocar no item
                onTap: () {
                  // Navega para a página de perfil
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
              ),
              // Item de configurações
              PopupMenuItem<String>(
                // Valor do item
                value: 'settings',
                // Conteúdo do item (ícone e texto)
                child: const Row(
                  children: [
                    // Ícone de configurações em cinza
                    Icon(Icons.settings, color: Colors.grey),
                    // Espaço horizontal
                    SizedBox(width: 12),
                    // Texto do item
                    Text('Configurações'),
                  ],
                ),
                // Ação ao tocar no item
                onTap: () {
                  // Navega para a página de configurações
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              // Divisor do menu
              const PopupMenuDivider(),
              // Item de logout
              PopupMenuItem<String>(
                // Valor do item
                value: 'logout',
                // Ação ao tocar: abre o diálogo de logout
                onTap: _showLogoutDialog,
                // Conteúdo do item (ícone e texto em vermelho)
                child: const Row(
                  children: [
                    // Ícone de logout em vermelho
                    Icon(Icons.logout, color: Colors.red),
                    // Espaço horizontal
                    SizedBox(width: 12),
                    // Texto do item em vermelho
                    Text('Sair', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
          // Espaço horizontal para afastar do final da AppBar
          const SizedBox(width: 8),
        ],
      ),
      // Corpo da aplicação: página selecionada
      body: _pages[_selectedIndex],
      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        // Índice do item atualmente selecionado
        currentIndex: _selectedIndex,
        // Callback ao tocar em um item
        onTap: (index) {
          // Atualiza o estado com o novo índice selecionado
          setState(() => _selectedIndex = index);
        },
        // Itens da barra de navegação
        items: const [
          // Item de Switch
          BottomNavigationBarItem(
            // Ícone do item
            icon: Icon(Icons.swap_horiz),
            // Rótulo do item
            label: 'Switch',
          ),
          // Item de Alters
          BottomNavigationBarItem(
            // Ícone do item
            icon: Icon(Icons.person),
            // Rótulo do item
            label: 'Alters',
          ),
          // Item de Histórico
          BottomNavigationBarItem(
            // Ícone do item
            icon: Icon(Icons.history),
            // Rótulo do item
            label: 'Histórico',
          ),
        ],
      ),
    );
  }
}
