import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController extends ChangeNotifier {
  User? _currentUser;
  bool _isInitialized = false;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isInitialized => _isInitialized;

  UserController() {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _currentUser = Supabase.instance.client.auth.currentUser;
      _isInitialized = true;
      notifyListeners();

      Supabase.instance.client.auth.onAuthStateChange.listen((data) {
        _currentUser = data.session?.user;
        _isInitialized = true;
        notifyListeners();
      });
    } catch (e) {
      print('UserController - Erro na inicialização: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      print('UserController - Erro no logout: $e');
      rethrow;
    }
  }
}