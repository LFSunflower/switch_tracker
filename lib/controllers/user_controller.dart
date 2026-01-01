import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/logger.dart';

class UserController extends ChangeNotifier {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Map<String, dynamic>? _currentUser;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  Map<String, dynamic>? get currentUser => _currentUser;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _supabaseClient.auth.currentUser != null;

  /// Carregar dados do usuário
  Future<void> loadUserData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Tentar buscar perfil do usuário
      var response = await _supabaseClient
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      // Se não encontrar, criar novo perfil
      if (response == null) {
        AppLogger.info('Criando novo perfil de usuário');
        response = await _createUserProfile(user);
      }

      if (response != null) {
        _currentUser = response as Map<String, dynamic>;
        _loadPreferences();
      }

      AppLogger.info('Dados do usuário carregados com sucesso');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao carregar dados do usuário: $e', StackTrace.current);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Criar novo perfil de usuário
  Future<Map<String, dynamic>?> _createUserProfile(User user) async {
    try {
      final response = await _supabaseClient
          .from('profiles')
          .insert({
            'id': user.id,
            'username': user.email?.split('@').first ?? 'Usuário',
            'notifications_enabled': true,
            'dark_mode_enabled': false,
          })
          .select()
          .single();

      AppLogger.info('Novo perfil de usuário criado');
      return response as Map<String, dynamic>;
    } catch (e) {
      AppLogger.error('Erro ao criar perfil de usuário: $e', StackTrace.current);
      return null;
    }
  }

  /// Carregar preferências do usuário
  void _loadPreferences() {
    if (_currentUser == null) return;

    _notificationsEnabled = _currentUser!['notifications_enabled'] as bool? ?? true;
    _darkModeEnabled = _currentUser!['dark_mode_enabled'] as bool? ?? false;
  }

  /// Salvar preferência do usuário
  Future<bool> saveUserPreference(String key, dynamic value) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      final updateData = {key: value};

      await _supabaseClient
          .from('profiles')
          .update(updateData)
          .eq('id', user.id);

      // Atualizar localmente
      if (key == 'notifications_enabled') {
        _notificationsEnabled = value as bool;
      } else if (key == 'dark_mode_enabled') {
        _darkModeEnabled = value as bool;
      }

      if (_currentUser != null) {
        _currentUser![key] = value;
      }

      AppLogger.info('Preferência salva: $key = $value');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao salvar preferência: $e', StackTrace.current);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Alterar senha
  Future<bool> changePassword(String oldPassword, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Verificar senha atual
      try {
        await _supabaseClient.auth.signInWithPassword(
          email: user.email!,
          password: oldPassword,
        );
      } catch (e) {
        throw Exception('Senha atual incorreta');
      }

      // Alterar para nova senha
      await _supabaseClient.auth.updateUser(
        UserAttributes(password: newPassword),
      );

      AppLogger.info('Senha alterada com sucesso');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao alterar senha: $e', StackTrace.current);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpar cache da aplicação
  Future<bool> clearAppCache() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Aqui você pode adicionar lógica para limpar cache
      // Por exemplo, limpar SharedPreferences, banco de dados local, etc.

      AppLogger.info('Cache da aplicação limpo');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao limpar cache: $e', StackTrace.current);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Exportar dados do usuário
  Future<bool> exportUserData() async {
    _isLoading = true;
    _errorMessage = 'Função em desenvolvimento. Em breve você poderá exportar seus dados em JSON/CSV.';
    notifyListeners();
    
    // Simula um pequeno delay para o usuário ver o loading
    await Future.delayed(const Duration(seconds: 1));
    
    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Deletar conta do usuário (Soft Delete temporário)
  Future<bool> deleteAccount(String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Verificar senha
      try {
        await _supabaseClient.auth.signInWithPassword(
          email: user.email!,
          password: password,
        );
      } catch (e) {
        throw Exception('Senha incorreta');
      }

      // Implementação de Soft Delete como solução temporária
      // Marcamos o perfil como inativo em vez de deletar via admin (que requer Edge Function)
      await _supabaseClient
          .from('profiles')
          .update({
            'is_active': false,
            'deleted_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('id', user.id);

      // Fazer logout após marcar como deletado
      await _supabaseClient.auth.signOut();

      AppLogger.info('Conta marcada para deleção (Soft Delete)');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao deletar conta: $e', StackTrace.current);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fazer logout
  Future<void> logout() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _supabaseClient.auth.signOut();
      _currentUser = null;
      _notificationsEnabled = true;
      _darkModeEnabled = false;

      AppLogger.info('Logout realizado com sucesso');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao fazer logout: $e', StackTrace.current);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}