import 'package:flutter/material.dart';

import '../core/utils/logger.dart';
import '../data/models/version.dart';
import '../data/repositories/version_repository.dart';

class VersionController extends ChangeNotifier {
  final VersionRepository _repository;

  List<Version> _allVersions = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Version> get allVersions => _allVersions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  VersionController({required VersionRepository repository})
      : _repository = repository;

  /// Carrega todas as versões
  Future<void> loadAllVersions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _allVersions = await _repository.getAllVersions();
      AppLogger.debug('${_allVersions.length} versões carregadas');
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao carregar versões', StackTrace.current);
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
    required String colorHex,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newVersion = await _repository.createVersion(
        name: name,
        pronoun: pronoun,
        description: description,
        colorHex: colorHex,
      );

      _allVersions.add(newVersion);
      AppLogger.info('Nova versão criada: ${newVersion.name}');
      notifyListeners();
      return newVersion;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao criar versão', StackTrace.current);
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
    String? colorHex,
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
        colorHex: colorHex,
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
      AppLogger.error('Erro ao atualizar versão', StackTrace.current);
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deleta uma versão
  Future<bool> deleteVersion(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.deleteVersion(id);
      _allVersions.removeWhere((v) => v.id == id);
      AppLogger.info('Versão deletada: $id');
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      AppLogger.error('Erro ao deletar versão', StackTrace.current);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}