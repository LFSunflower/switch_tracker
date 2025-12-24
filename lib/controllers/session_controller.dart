import 'package:flutter/material.dart';

import '../core/utils/logger.dart';
import '../data/models/front_session.dart';
import '../data/repositories/session_repository.dart';

class SessionController extends ChangeNotifier {
  final SessionRepository _repository;

  FrontSession? _activeSession;
  List<FrontSession> _allSessions = [];
  bool _isLoading = false;
  String? _errorMessage;

  FrontSession? get activeSession => _activeSession;
  List<FrontSession> get allSessions => _allSessions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SessionController({required SessionRepository repository})
      : _repository = repository;

  /// Carrega a sessão ativa
  Future<void> loadActiveSession() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _activeSession = await _repository.getActiveSession();
      AppLogger.debug('Sessão ativa carregada: ${_activeSession?.id}');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao carregar sessão', StackTrace.current);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Carrega todos os registros de sessão
  Future<void> loadAllSessions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allSessions = await _repository.getAllSessions();
      AppLogger.debug('${_allSessions.length} sessões carregadas');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao carregar sessões', StackTrace.current);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Inicia uma nova sessão (fecha a anterior)
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
      if (_activeSession != null) {
        await _repository.endSession(_activeSession!.id);
        AppLogger.debug('Sessão anterior encerrada');
      }

      _activeSession = await _repository.startSession(
        alterIds: alterIds,
        intensity: intensity,
        triggers: triggers,
        notes: notes,
        isCoFront: isCoFront,
      );

      AppLogger.info('Nova sessão iniciada: ${_activeSession?.id}');
      await loadAllSessions();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao iniciar sessão', StackTrace.current);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Finaliza a sessão ativa
  Future<void> endCurrentSession() async {
    if (_activeSession == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.endSession(_activeSession!.id);
      _activeSession = null;
      AppLogger.info('Sessão finalizada');
      await loadAllSessions();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao finalizar sessão', StackTrace.current);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Atualiza notas de uma sessão
  Future<void> updateSessionNotes(String sessionId, String notes) async {
    try {
      await _repository.updateSessionNotes(sessionId, notes);
      if (_activeSession?.id == sessionId) {
        _activeSession = _activeSession?.copyWith(notes: notes);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao atualizar notas', StackTrace.current);
    }
  }

  /// Atualiza gatilhos de uma sessão
  Future<void> updateSessionTriggers(
    String sessionId,
    List<String> triggers,
  ) async {
    try {
      await _repository.updateSessionTriggers(sessionId, triggers);
      if (_activeSession?.id == sessionId) {
        _activeSession = _activeSession?.copyWith(triggers: triggers);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao atualizar gatilhos', StackTrace.current);
    }
  }
}
