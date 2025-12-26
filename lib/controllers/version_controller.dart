import 'package:flutter/foundation.dart';

import '../core/utils/logger.dart';
import '../data/models/version.dart';
import '../data/repositories/version_repository.dart';

class VersionController extends ChangeNotifier {
  final VersionRepository _repository = VersionRepository();

  List<Version> _allVersions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Version> get allVersions => _allVersions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Carrega todas as versões do usuário
  Future<void> loadVersions() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allVersions = await _repository.getAllVersions();
      AppLogger.info('Versões carregadas com sucesso: ${_allVersions.length}');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao carregar versões: $e', StackTrace.current);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cria uma nova versão
  Future<Version?> createVersion({
    required String name,
    String? pronoun,
    String? description,
    String? function,
    String? likes,
    String? dislikes,
    String? safetyInstructions,
    required String colorHex,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newVersion = await _repository.createVersion(
        name: name,
        pronoun: pronoun,
        description: description,
        function: function,
        likes: likes,
        dislikes: dislikes,
        safetyInstructions: safetyInstructions,
        colorHex: colorHex,
        avatarUrl: avatarUrl,
      );

      _allVersions.add(newVersion);
      AppLogger.info('Nova versão criada: ${newVersion.name}');
      notifyListeners();
      return newVersion;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao criar versão: $e', StackTrace.current);
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Atualiza uma versão
  Future<Version?> updateVersion({
    required String id,
    String? name,
    String? pronoun,
    String? description,
    String? function,
    String? likes,
    String? dislikes,
    String? safetyInstructions,
    String? colorHex,
    String? avatarUrl,
    bool? isActive,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedVersion = await _repository.updateVersion(
        versionId: id,
        name: name,
        pronoun: pronoun,
        description: description,
        function: function,
        likes: likes,
        dislikes: dislikes,
        safetyInstructions: safetyInstructions,
        colorHex: colorHex,
        avatarUrl: avatarUrl,
        isActive: isActive,
      );

      final index = _allVersions.indexWhere((v) => v.id == id);
      if (index != -1) {
        _allVersions[index] = updatedVersion;
      }

      AppLogger.info('Versão atualizada: ${updatedVersion.name}');
      notifyListeners();
      return updatedVersion;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao atualizar versão: $e', StackTrace.current);
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deleta uma versão
  Future<bool> deleteVersion(String versionId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteVersion(versionId);
      _allVersions.removeWhere((v) => v.id == versionId);

      AppLogger.info('Versão deletada com sucesso: $versionId');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao deletar versão: $e', StackTrace.current);
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Busca uma versão específica pelo ID
  Version? getVersionById(String versionId) {
    try {
      return _allVersions.firstWhere((v) => v.id == versionId);
    } catch (e) {
      AppLogger.warning('Versão não encontrada: $versionId');
      return null;
    }
  }
}