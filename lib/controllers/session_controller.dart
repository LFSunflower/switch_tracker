import 'package:flutter/foundation.dart';

import '../core/utils/logger.dart';
import '../data/models/front_session.dart';
import '../data/repositories/session_repository.dart';

class SessionController extends ChangeNotifier {
  final SessionRepository _repository = SessionRepository();

  List<FrontSession> _allSessions = [];
  FrontSession? _activeSession;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<FrontSession> get allSessions => _allSessions;
  FrontSession? get activeSession => _activeSession;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carrega todas as sessões
  Future<void> loadSessions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allSessions = await _repository.getAllSessions();
      _activeSession = await _repository.getActiveSession();

      AppLogger.info('Sessões carregadas com sucesso: ${_allSessions.length}');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao carregar sessões: $e', StackTrace.current);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inicia uma nova sessão
  Future<void> startNewSession({
    required List<String> alterIds,
    required int intensity,
    List<String> triggers = const [],
    String? notes,
    bool isCoFront = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newSession = await _repository.createSession(
        alterIds: alterIds,
        intensity: intensity,
        triggers: triggers,
        notes: notes,
        isCofront: isCoFront,
      );

      _activeSession = newSession;
      _allSessions.insert(0, newSession);

      AppLogger.info('Nova sessão iniciada: ${newSession.id}');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao iniciar sessão: $e', StackTrace.current);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Atualiza uma sessão existente
  Future<bool> updateSession({
    required String sessionId,
    List<String>? alterIds,
    int? intensity,
    List<String>? triggers,
    String? notes,
    bool? isCofront,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedSession = await _repository.updateSession(
        sessionId: sessionId,
        alterIds: alterIds,
        intensity: intensity,
        triggers: triggers,
        notes: notes,
        isCofront: isCofront,
        startTime: startTime,
        endTime: endTime,
      );

      // Atualizar sessão ativa se for a mesma
      if (_activeSession?.id == sessionId) {
        _activeSession = updatedSession;
      }

      // Atualizar na lista
      final index = _allSessions.indexWhere((s) => s.id == sessionId);
      if (index != -1) {
        _allSessions[index] = updatedSession;
      }

      AppLogger.info('Sessão atualizada com sucesso: $sessionId');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao atualizar sessão: $e', StackTrace.current);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deleta uma sessão
  Future<bool> deleteSession(String sessionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteSession(sessionId);
      _allSessions.removeWhere((s) => s.id == sessionId);

      if (_activeSession?.id == sessionId) {
        _activeSession = null;
      }

      AppLogger.info('Sessão deletada com sucesso: $sessionId');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao deletar sessão: $e', StackTrace.current);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Finaliza a sessão ativa
  Future<void> endActiveSession() async {
    if (_activeSession == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final endedSession = await _repository.updateSession(
        sessionId: _activeSession!.id,
        endTime: DateTime.now(),
      );

      // Atualizar na lista
      final index = _allSessions.indexWhere((s) => s.id == _activeSession!.id);
      if (index != -1) {
        _allSessions[index] = endedSession;
      }

      _activeSession = null;

      AppLogger.info('Sessão finalizada com sucesso');
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao finalizar sessão: $e', StackTrace.current);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
