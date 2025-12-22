import 'package:flutter/material.dart';
import '../data/models/front_session.dart';
import '../data/repositories/session_repository.dart';

class SessionController extends ChangeNotifier {
  final SessionRepository _repository;

  FrontSession? _activeSession;
  bool _isLoading = false;

  SessionController(this._repository);

  FrontSession? get activeSession => _activeSession;
  bool get isLoading => _isLoading;

  /// Carrega sessão ativa ao iniciar o app
  Future<void> loadActiveSession() async {
    _isLoading = true;
    notifyListeners();

    _activeSession = await _repository.fetchActiveSession();

    _isLoading = false;
    notifyListeners();
  }

  /// Inicia uma nova sessão
  Future<void> startSession({
    required List<String> versionIds,
    required int intensity,
    required List<String> triggerIds,
    String? notes,
  }) async {
    _isLoading = true;
    notifyListeners();

    // encerra sessão atual se existir
    if (_activeSession != null) {
      await _repository.endSession(_activeSession!.id);
    }

    final newSession = await _repository.createSession(
      versionIds: versionIds,
      intensity: intensity,
      triggerIds: triggerIds,
      notes: notes,
    );

    _activeSession = newSession;

    _isLoading = false;
    notifyListeners();
  }

  /// Encerra manualmente
  Future<void> endCurrentSession() async {
    if (_activeSession == null) return;

    _isLoading = true;
    notifyListeners();

    await _repository.endSession(_activeSession!.id);
    _activeSession = null;

    _isLoading = false;
    notifyListeners();
  }

  /// Atualiza intensidade
  Future<void> updateIntensity(int intensity) async {
    if (_activeSession == null) return;

    await _repository.updateIntensity(
      _activeSession!.id,
      intensity,
    );

    _activeSession = FrontSession(
      id: _activeSession!.id,
      versionIds: _activeSession!.versionIds,
      startTime: _activeSession!.startTime,
      endTime: _activeSession!.endTime,
      intensity: intensity,
      triggerIds: _activeSession!.triggerIds,
      notes: _activeSession!.notes,
    );

    notifyListeners();
  }
}
