import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/version.dart';

class VersionRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Version>> getAllVersions() async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('versions')
          .select()
          .eq('user_id', currentUser.id)
          .order('created_at', ascending: false);

      return (response as List<dynamic>)
          .map((version) => Version.fromMap(version as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw Exception('Erro ao buscar versões: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

  Future<Version> createVersion({
    required String name,
    String? pronoun,
    String? description,
    required String colorHex,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      final response = await _client
          .from('versions')
          .insert({
            'user_id': currentUser.id,
            'name': name,
            'pronoun': pronoun,
            'description': description,
            'color_hex': colorHex,
          })
          .select()
          .single();

      return Version.fromMap(response);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao criar versão: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

  Future<void> updateVersion({
    required String id,
    String? name,
    String? pronoun,
    String? description,
    String? colorHex,
  }) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      await _client
          .from('versions')
          .update({
            if (name != null) 'name': name,
            if (pronoun != null) 'pronoun': pronoun,
            if (description != null) 'description': description,
            if (colorHex != null) 'color_hex': colorHex,
          })
          .eq('id', id)
          .eq('user_id', currentUser.id);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao atualizar versão: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }

  Future<void> deleteVersion(String id) async {
    try {
      final currentUser = _client.auth.currentUser;
      if (currentUser == null) {
        throw Exception('Usuário não autenticado');
      }

      await _client
          .from('versions')
          .delete()
          .eq('id', id)
          .eq('user_id', currentUser.id);
    } on PostgrestException catch (e) {
      throw Exception('Erro ao deletar versão: ${e.message}');
    } catch (e) {
      throw Exception('Erro desconhecido: $e');
    }
  }
}
