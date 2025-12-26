import 'package:flutter/foundation.dart';

import '../core/utils/logger.dart';
import '../data/models/front_session.dart';
import '../data/repositories/session_repository.dart';

class SessionController extends ChangeNotifier {
  final SessionRepository _repository = SessionRepository();

  FrontSession? _activeSession;
  List<FrontSession> _allSessions = [];
  bool _isLoading = false;
  String? _errorMessage;

  FrontSession? get activeSession => _activeSession;
  List<FrontSession> get allSessions => _allSessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasActiveSession => _activeSession != null;

  /// Carrega todas as sessões
  Future<void> loadSessions() async {
    // Não notificar se já está carregando
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allSessions = await _repository.getAllSessions();
      AppLogger.info('Sessões carregadas: ${_allSessions.length}');

      // Atualizar sessão ativa
      _activeSession = _allSessions.firstWhere(
        (s) => s.endTime == null,
        orElse: () => _createEmptySession(),
      );

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

  /// Carrega a sessão ativa
  Future<void> loadActiveSessions() async {
    // Não notificar se já está carregando
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeSession = await _repository.getActiveSession();
      AppLogger.info(
        _activeSession != null
            ? 'Sessão ativa encontrada: ${_activeSession!.id}'
            : 'Nenhuma sessão ativa',
      );
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao carregar sessão ativa: $e', StackTrace.current);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inicia nova sessão
  Future<bool> startNewSession({
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
      final newSession = await _repository.startSession(
        alterIds: alterIds,
        intensity: intensity,
        triggers: triggers,
        notes: notes,
        isCoFront: isCoFront,
      );

      _activeSession = newSession;
      _allSessions.insert(0, newSession);
      AppLogger.info('Sessão iniciada: ${newSession.id}');

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao iniciar sessão: $e', StackTrace.current);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Encerra a sessão ativa
  Future<bool> endActiveSession() async {
    if (_activeSession == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.endSession(_activeSession!.id);
      AppLogger.info('Sessão encerrada: ${_activeSession!.id}');

      _activeSession = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao encerrar sessão: $e', StackTrace.current);
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

  /// Método auxiliar para criar sessão vazia
  FrontSession _createEmptySession() {
    return FrontSession(
      id: '',
      userId: '',
      alters: [],
      intensity: 3,
      triggers: [],
      notes: null,
      startTime: DateTime.now(),
      endTime: null,
      isCofront: false,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
  }
}
