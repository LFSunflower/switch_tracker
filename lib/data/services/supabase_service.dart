import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/utils/logger.dart';

class SupabaseService {
  static const String projectUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://hnmozwmncnlcatytctgq.supabase.co',
  );

  static const String projectAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhubW96d21uY25sY2F0eXRjdGdxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYyNjcyMTIsImV4cCI6MjA4MTg0MzIxMn0.sCcHBdCEcTqeXy21CvaORHeHyP4gheUCg4PWadocF-U',
  );

  static Future<void> initialize() async {
    try {
      await Supabase.initialize(
        url: projectUrl,
        anonKey: projectAnonKey,
        debug: true,
      );
      AppLogger.info('Supabase inicializado com sucesso');
    } catch (e) {
      AppLogger.error('Erro ao inicializar Supabase: $e', StackTrace.current);
      rethrow;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> signOut() async {
    try {
      await client.auth.signOut();
      AppLogger.info('Usuário desconectado com sucesso');
    } catch (e) {
      AppLogger.error('Erro ao desconectar: $e', StackTrace.current);
      rethrow;
    }
  }
}
