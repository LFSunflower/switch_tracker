import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/front_session.dart';

class SessionRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<FrontSession?> getActiveSession() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('front_sessions')
          .select()
          .eq('user_id', currentUser.id)
          .isFilter('end_time', null)
          .order('start_time', ascending: false)
          .maybeSingle();

      if (response == null) return null;
      return FrontSession.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao buscar sessão: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

  Future<List<FrontSession>> getAllSessions() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('front_sessions')
          .select()
          .eq('user_id', currentUser.id)
          .order('start_time', ascending: false);

      return (response as List<dynamic>)
          .map((session) =>
              FrontSession.fromMap(session as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Erro ao buscar sessões: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

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

      final response = await _client
          .from('front_sessions')
          .insert({
            'user_id': currentUser.id,
            'alter_ids': alterIds,
            'intensity': intensity,
            'triggers': triggers,
            'notes': notes,
            'is_co_front': isCoFront,
            'start_time': DateTime.now().toIso8601String(),
            'end_time': null,
          })
          .select()
          .single();

      return FrontSession.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao criar sessão: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

  Future<void> endSession(String sessionId) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      await _client
          .from('front_sessions')
          .update({
            'end_time': DateTime.now().toIso8601String(),
          })
          .eq('id', sessionId)
          .eq('user_id', currentUser.id);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao encerrar sessão: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

  Future<void> updateSessionNotes(String sessionId, String notes) async {
    try {
      await _client
          .from('front_sessions')
          .update({'notes': notes})
          .eq('id', sessionId);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao atualizar notas: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

  Future<void> updateSessionTriggers(
    String sessionId,
    List<String> triggers,
  ) async {
    try {
      await _client
          .from('front_sessions')
          .update({'triggers': triggers})
          .eq('id', sessionId);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao atualizar gatilhos: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }
}
