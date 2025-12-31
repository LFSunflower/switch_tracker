import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/logger.dart';
import '../models/front_session.dart';

class SessionRepository {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _tableName = 'front_sessions';

  /// Buscar todas as sessões do usuário
  Future<List<FrontSession>> getAllSessions() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', currentUser.id)
          .order('start_time', ascending: false);

      AppLogger.debug('Resposta do banco (getAllSessions): $response');

      return (response as List<dynamic>)
          .map((session) =>
              FrontSession.fromMap(session as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao buscar sessões: ${e.message}');
      throw Exception('Erro ao buscar sessões: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao buscar sessões: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Buscar sessão ativa
  Future<FrontSession?> getActiveSession() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from(_tableName)
          .select()
          .eq('user_id', currentUser.id)
          .filter('end_time', 'is', null)
          .maybeSingle();

      AppLogger.debug('Resposta do banco (getActiveSession): $response');

      if (response == null) return null;
      return FrontSession.fromMap(response);
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao buscar sessão ativa: ${e.message}');
      throw Exception('Erro ao buscar sessão ativa: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao buscar sessão ativa: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Criar nova sessão
  Future<FrontSession> createSession({
    required List<String> alterIds,
    required int intensity,
    required List<String> triggers,
    String? notes,
    required bool isCofront,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final createData = <String, dynamic>{
        'user_id': currentUser.id,
        'alters': alterIds,
        'intensity': intensity,
        'triggers': triggers,
        'is_cofront': isCofront,
        'start_time': DateTime.now().toUtc().toIso8601String(),
      };

      if (notes != null && notes.isNotEmpty) {
        createData['notes'] = notes;
      }

      AppLogger.info('Criando sessão com dados: $createData');

      final response = await _client
          .from(_tableName)
          .insert(createData)
          .select()
          .single();

      AppLogger.debug('Resposta do banco (createSession): $response');

      final newSession = FrontSession.fromMap(response);
      AppLogger.info('Sessão criada com sucesso');
      return newSession;
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao criar sessão: ${e.message}');
      throw Exception('Erro ao criar sessão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao criar sessão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Atualizar sessão
  Future<FrontSession> updateSession({
    required String sessionId,
    List<String>? alterIds,
    int? intensity,
    List<String>? triggers,
    String? notes,
    bool? isCofront,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (alterIds != null) updateData['alters'] = alterIds;
      if (intensity != null) updateData['intensity'] = intensity;
      if (triggers != null) updateData['triggers'] = triggers;
      if (notes != null) updateData['notes'] = notes;
      if (isCofront != null) updateData['is_cofront'] = isCofront;
      if (startTime != null) updateData['start_time'] = startTime.toUtc().toIso8601String();
      if (endTime != null) updateData['end_time'] = endTime.toUtc().toIso8601String();

      if (updateData.isEmpty) {
        final currentSession = await _getSessionById(sessionId);
        if (currentSession == null) {
          throw Exception('Sessão não encontrada');
        }
        return currentSession;
      }

      AppLogger.info('Atualizando sessão $sessionId com dados: $updateData');

      final response = await _client
          .from(_tableName)
          .update(updateData)
          .eq('id', sessionId)
          .select()
          .single();

      AppLogger.debug('Resposta do banco (updateSession): $response');

      final updatedSession =
          FrontSession.fromMap(response);
      AppLogger.info('Sessão atualizada com sucesso');
      return updatedSession;
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao atualizar sessão: ${e.message}');
      throw Exception('Erro ao atualizar sessão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao atualizar sessão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Deletar sessão
  Future<void> deleteSession(String sessionId) async {
    try {
      AppLogger.info('Deletando sessão: $sessionId');

      await _client.from(_tableName).delete().eq('id', sessionId);

      AppLogger.info('Sessão deletada com sucesso: $sessionId');
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao deletar sessão: ${e.message}');
      throw Exception('Erro ao deletar sessão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao deletar sessão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Buscar sessão por ID (privado)
  Future<FrontSession?> _getSessionById(String sessionId) async {
    try {
      final response = await _client
          .from(_tableName)
          .select()
          .eq('id', sessionId)
          .maybeSingle();

      if (response == null) return null;
      return FrontSession.fromMap(response);
    } catch (e) {
      AppLogger.error('Erro ao buscar sessão por ID: $e', StackTrace.current);
      return null;
    }
  }
}
