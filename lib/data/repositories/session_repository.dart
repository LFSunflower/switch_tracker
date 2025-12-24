import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/logger.dart';
import '../models/front_session.dart';

class SessionRepository {
  final SupabaseClient _client = Supabase.instance.client;
  static const String _tableName = 'front_sessions';

  /// Buscar sessão ativa (end_time == null)
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
          .isFilter('end_time', null)
          .order('start_time', ascending: false)
          .maybeSingle();

      if (response == null) return null;
      return FrontSession.fromMap(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao buscar sessão: ${e.message}');
      throw Exception('Erro ao buscar sessão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao buscar sessão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

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

  /// Iniciar nova sessão
  Future<FrontSession> startSession({
    required List<String> alterIds,
    required int intensity,
    List<String> triggers = const [],
    String? notes,
    bool isCoFront = false,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final createData = {
        'user_id': currentUser.id,
        'alters': alterIds,
        'intensity': intensity,
        'triggers': triggers,
        'notes': notes,
        'is_cofront': isCoFront,
        'start_time': DateTime.now().toIso8601String(),
        'end_time': null,
      };

      AppLogger.info('Iniciando sessão com dados: $createData');

      final response = await _client
          .from(_tableName)
          .insert(createData)
          .select()
          .single();

      AppLogger.debug('Resposta do banco (startSession): $response');

      return FrontSession.fromMap(response as Map<String, dynamic>);
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao criar sessão: ${e.message}');
      throw Exception('Erro ao criar sessão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao criar sessão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Encerrar sessão
  Future<void> endSession(String sessionId) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      AppLogger.info('Encerrando sessão: $sessionId');

      await _client
          .from(_tableName)
          .update({
            'end_time': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId)
          .eq('user_id', currentUser.id);

      AppLogger.info('Sessão encerrada com sucesso: $sessionId');
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao encerrar sessão: ${e.message}');
      throw Exception('Erro ao encerrar sessão: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao encerrar sessão: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Atualizar notas da sessão
  Future<void> updateSessionNotes(String sessionId, String notes) async {
    try {
      await _client
          .from(_tableName)
          .update({'notes': notes})
          .eq('id', sessionId);

      AppLogger.info('Notas da sessão atualizadas: $sessionId');
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao atualizar notas: ${e.message}');
      throw Exception('Erro ao atualizar notas: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao atualizar notas: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Atualizar gatilhos da sessão
  Future<void> updateSessionTriggers(
    String sessionId,
    List<String> triggers,
  ) async {
    try {
      await _client
          .from(_tableName)
          .update({'triggers': triggers})
          .eq('id', sessionId);

      AppLogger.info('Gatilhos da sessão atualizados: $sessionId');
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao atualizar gatilhos: ${e.message}');
      throw Exception('Erro ao atualizar gatilhos: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao atualizar gatilhos: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }

  /// Atualizar intensidade da sessão
  Future<void> updateSessionIntensity(String sessionId, int intensity) async {
    try {
      await _client
          .from(_tableName)
          .update({'intensity': intensity})
          .eq('id', sessionId);

      AppLogger.info('Intensidade da sessão atualizada: $sessionId');
    } on PostgrestException catch (e) {
      AppLogger.error('Erro PostgreSQL ao atualizar intensidade: ${e.message}');
      throw Exception('Erro ao atualizar intensidade: ${e.message}');
    } catch (e) {
      AppLogger.error('Erro desconhecido ao atualizar intensidade: $e', StackTrace.current);
      throw Exception('Erro desconhecido: $e');
    }
  }
}
