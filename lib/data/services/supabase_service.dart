import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static Future<void> init() async {
    await Supabase.initialize(
      url: 'https://hnmozwmncnlcatytctgq.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhubW96d21uY25sY2F0eXRjdGdxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjYyNjcyMTIsImV4cCI6MjA4MTg0MzIxMn0.sCcHBdCEcTqeXy21CvaORHeHyP4gheUCg4PWadocF-U',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
