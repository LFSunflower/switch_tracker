import 'package:flutter/foundation.dart';
import '../../../core/utils/time_utils.dart';

class FrontSession {
  final String id;
  final String userId;
  final List<String> alters;
  final int intensity;
  final List<String> triggers;
  final String? notes;
  final bool isCofront;
  final DateTime startTime;
  final DateTime? endTime;
  final DateTime createdAt;
  final DateTime updatedAt;

  FrontSession({
    required this.id,
    required this.userId,
    required this.alters,
    required this.intensity,
    required this.triggers,
    this.notes,
    required this.isCofront,
    required this.startTime,
    this.endTime,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calcula a duração da sessão
  Duration getDuration() {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime);
  }

  /// Retorna a duração formatada
  String getFormattedDuration() {
    return TimeUtils.formatDuration(getDuration());
  }

  /// Verifica se a sessão está ativa
  bool get isActive => endTime == null;

  /// Converte para Map (para Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'alters': alters,
      'intensity': intensity,
      'triggers': triggers,
      'notes': notes,
      'is_cofront': isCofront,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Cria um FrontSession a partir de um Map (do Supabase)
  factory FrontSession.fromMap(Map<String, dynamic> map) {
    return FrontSession(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      alters: List<String>.from(map['alters'] ?? []),
      intensity: map['intensity'] ?? 3,
      triggers: List<String>.from(map['triggers'] ?? []),
      notes: map['notes'],
      isCofront: map['is_cofront'] ?? false,
      startTime: DateTime.parse(map['start_time']),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  /// Cria uma cópia da sessão com alguns campos alterados
  FrontSession copyWith({
    String? id,
    String? userId,
    List<String>? alters,
    int? intensity,
    List<String>? triggers,
    String? notes,
    bool? isCofront,
    DateTime? startTime,
    DateTime? endTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FrontSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      alters: alters ?? this.alters,
      intensity: intensity ?? this.intensity,
      triggers: triggers ?? this.triggers,
      notes: notes ?? this.notes,
      isCofront: isCofront ?? this.isCofront,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrontSession &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
