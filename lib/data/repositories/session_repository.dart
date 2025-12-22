import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/front_session.dart';

class SessionRepository {
  final SupabaseClient _client;

  SessionRepository(this._client);

  /// Busca sessão ativa do usuário logado
  Future<FrontSession?> fetchActiveSession() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('front_sessions')
        .select()
        .eq('user_id', user.id)
        .filter('end_time', 'is', null)
        .limit(1)
        .maybeSingle();

    if (response == null) return null;

    return FrontSession.fromMap(response);
  }

  /// Cria nova sessão
  Future<FrontSession> createSession({
    required List<String> versionIds,
    required int intensity,
    required List<String> triggerIds,
    String? notes,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado');
    }

    final response = await _client
        .from('front_sessions')
        .insert({
          'user_id': user.id,
          'versions': versionIds,
          'triggers': triggerIds,
          'intensity': intensity,
          'notes': notes,
          'start_time': DateTime.now().toIso8601String(),
          'end_time': null,
        })
        .select()
        .single();

    return FrontSession.fromMap(response);
  }

  /// Encerra sessão ativa
  Future<void> endSession(String sessionId) async {
    await _client
        .from('front_sessions')
        .update({
          'end_time': DateTime.now().toIso8601String(),
        })
        .eq('id', sessionId);
  }

  /// Atualiza intensidade da sessão
  Future<void> updateIntensity(
    String sessionId,
    int intensity,
  ) async {
    await _client
        .from('front_sessions')
        .update({
          'intensity': intensity,
        })
        .eq('id', sessionId);
  }
}
