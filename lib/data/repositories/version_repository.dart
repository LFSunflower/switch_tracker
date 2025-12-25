import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/logger.dart';
import '../models/version.dart';

class VersionRepository {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _tableName = 'alters';

  /// Buscar todas as versões do usuário
  Future<List<Version>> getAllVersions() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: true);

      AppLogger.debug('Resposta do banco (getAllVersions): $response');

      return (response as List<dynamic>)
          .map((version) => Version.fromMap(version as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao buscar versões: ${e.message}');
      throw Exception('Erro ao buscar versões: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao buscar versões: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Buscar versão por ID
  Future<Version?> getVersionById(String versionId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', versionId)
          .maybeSingle();

      AppLogger.debug('Resposta do banco (getVersionById): $response');

      if (response == null) return null;
      return Version.fromMap(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao buscar versão: ${e.message}');
      throw Exception('Erro ao buscar versão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao buscar versão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Criar nova versão
  Future<Version> createVersion({
    required String name,
    String? pronoun,
    String? description,
    required String colorHex,
    String? avatarUrl,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final createData = {
        'user_id': currentUser.id,
        'name': name,
        'pronoun': pronoun,
        'description': description,
        'color': colorHex,
        'avatar_url': avatarUrl,
        'is_active': true,
      };

      AppLogger.info('Criando versão com dados: $createData');

      final response = await _client
          .from(_tableName)
          .insert(createData)
          .select()
          .single();

      AppLogger.debug('Resposta do banco (createVersion): $response');

      final newVersion = Version.fromMap(response as Map<String, dynamic>);
      AppLogger.info('Versão criada com sucesso: ${newVersion.name}');
      return newVersion;
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao criar versão: ${e.message}');
      throw Exception('Erro ao criar versão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao criar versão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Atualizar versão
  Future<Version> updateVersion({
    required String versionId,
    String? name,
    String? pronoun,
    String? description,
    String? colorHex,
    String? avatarUrl,
    bool? isActive,
  }) async {
    try {
      final updateData = <String, dynamic>{};
      if (name != null) updateData['name'] = name;
      if (pronoun != null) updateData['pronoun'] = pronoun;
      if (description != null) updateData['description'] = description;
      if (colorHex != null) updateData['color'] = colorHex;
      if (avatarUrl != null) updateData['avatar_url'] = avatarUrl;
      if (isActive != null) updateData['is_active'] = isActive;

      if (updateData.isEmpty) {
        final currentVersion = await getVersionById(versionId);
        if (currentVersion == null) {
          throw Exception('Versão não encontrada');
        }
        return currentVersion;
      }

      AppLogger.info('Atualizando versão $versionId com dados: $updateData');

      final response = await _client
          .from(_tableName)
          .update(updateData)
          .eq('id', versionId)
          .select()
          .single();

      AppLogger.debug('Resposta do banco (updateVersion): $response');

      final updatedVersion = Version.fromMap(response as Map<String, dynamic>);
      AppLogger.info('Versão atualizada com sucesso: ${updatedVersion.name}');
      return updatedVersion;
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao atualizar versão: ${e.message}');
      throw Exception('Erro ao atualizar versão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao atualizar versão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Deletar versão
  Future<void> deleteVersion(String versionId) async {
    try {
      AppLogger.info('Deletando versão: $versionId');

      await _client
          .from(_tableName)
          .delete()
          .eq('id', versionId);

      AppLogger.info('Versão deletada com sucesso: $versionId');
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao deletar versão: ${e.message}');
      throw Exception('Erro ao deletar versão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao deletar versão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }
}
