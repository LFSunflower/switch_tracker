import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/logger.dart';

class UserController extends ChangeNotifier {
  User? _currentUser;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;
  String? get userEmail => _currentUser?.email;

  UserController() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      _currentUser = user;
      _isInitialized = true;
      notifyListeners();

      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        _currentUser = data.session?.user;
        _isInitialized = true;
        notifyListeners();
      });
    } catch (e) {
      AppLogger.error('Erro na inicialização do UserController', StackTrace.current);
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      _currentUser = null;
      notifyListeners();
      AppLogger.info('Logout realizado');
    } catch (e) {
      AppLogger.error('Erro no logout', StackTrace.current);
      rethrow;
    }
  }
}