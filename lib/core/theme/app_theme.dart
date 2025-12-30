import 'package:flutter/material.dart';

// Classe responsável por definir a configuração de temas da aplicação
class AppTheme {
  // Cor primária: roxo
  static const primaryColor = Color(0xFF6A3AD3);
  // Cor de destaque: roxo mais claro
  static const accentColor = Color(0xFF8B5CF6);
  // Cor de fundo em tema claro: branco quase puro
  static const backgroundColor = Color(0xFFFAFAFA);
  // Cor de fundo em tema escuro: preto quase puro
  static const darkBackgroundColor = Color(0xFF121212);
  

  /// Gera um tema dinâmico baseado em uma cor semente e brilho
  static ThemeData getDynamicTheme(Color seedColor, Brightness brightness) {
    // Cria um esquema de cores a partir da cor semente e brilho fornecidos
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );

    // Retorna a configuração completa do tema
    return ThemeData(
      // Ativa Material Design 3
      useMaterial3: true,
      // Define o brilho (claro ou escuro)
      brightness: brightness,
      // Aplica o esquema de cores gerado
      colorScheme: colorScheme,
      // Define a cor de fundo do scaffold (claro ou escuro)
      scaffoldBackgroundColor: brightness == Brightness.light ? backgroundColor : darkBackgroundColor,
      
      // Configura a aparência da AppBar
      appBarTheme: AppBarTheme(
        // Remove sombra da AppBar
        elevation: 0,
        // Cor de fundo usa a cor primária do esquema
        backgroundColor: colorScheme.primary,
        // Cor do texto/ícones usa a cor "sobre primária" do esquema
        foregroundColor: colorScheme.onPrimary,
        // Centraliza o título
        centerTitle: true,
        // Estilo do texto do título
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colorScheme.onPrimary,
        ),
      ),

      // Configura o estilo dos botões elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // Cor de fundo do botão
          backgroundColor: colorScheme.primary,
          // Cor do texto do botão
          foregroundColor: colorScheme.onPrimary,
          // Espaçamento interno
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          // Cantos arredondados
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      
      // Configura a aparência dos cards
      cardTheme: CardThemeData(
        // Sombra do card
        elevation: 1,
        // Cantos arredondados
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        // Cor do card (branco em claro, cinza em escuro)
        color: brightness == Brightness.light ? Colors.white : const Color(0xFF1E1E1E),
      ),
      
      // Configura a barra de navegação inferior
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        // Cor de fundo (branco em claro, cinza em escuro)
        backgroundColor: brightness == Brightness.light ? Colors.white : const Color(0xFF1E1E1E),
        // Cor do item selecionado
        selectedItemColor: colorScheme.primary,
        // Cor do item não selecionado
        unselectedItemColor: Colors.grey,
        // Sombra da barra
        elevation: 8,
      ),
    );
  }

  /// Tema Light - Tema para modo claro
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    // Cria esquema de cores para tema claro
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: backgroundColor,
    
    // Configuração da AppBar para tema claro
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    
    
    // Configuração dos botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Configuração dos botões com borda
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Configuração dos botões de texto
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Configuração dos campos de entrada
    inputDecorationTheme: InputDecorationTheme(
      // Ativa cor de preenchimento
      filled: true,
      fillColor: Colors.white,
      // Espaçamento interno
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      // Borda padrão
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      // Borda quando habilitado
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      // Borda quando focado
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      // Cor do rótulo
      labelStyle: const TextStyle(color: Colors.grey),
    ),
    
    // Configuração dos cards
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
    ),
    
    // Configuração da barra de navegação
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
  );

  /// Tema Dark - Tema para modo escuro
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // Cria esquema de cores para tema escuro
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: darkBackgroundColor,
    
    // Configuração da AppBar para tema escuro
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    
    // Configuração dos botões elevados
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Configuração dos botões com borda (usa accentColor em tema escuro)
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    
    // Configuração dos botões de texto (usa accentColor em tema escuro)
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    ),
    
    // Configuração dos campos de entrada
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      // Cor de preenchimento mais clara que o fundo em tema escuro
      fillColor: const Color(0xFF1E1E1E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: const TextStyle(color: Colors.grey),
    ),
    
    // Configuração dos cards
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: const Color(0xFF1E1E1E),
    ),
    
    // Configuração da barra de navegação
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xFF1E1E1E),
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      elevation: 8,
    ),
  );
}
