import 'package:flutter/foundation.dart';

class FrontSession {
  final String id;
  final String userId;
  final List<String> alters;
  final int intensity;
  final DateTime startTime;
  final DateTime? endTime;
  final List<String> triggers;
  final String? notes;
  final bool isCofront;
  final DateTime createdAt;

  FrontSession({
    required this.id,
    required this.userId,
    required this.alters,
    required this.intensity,
    required this.startTime,
    this.endTime,
    required this.triggers,
    this.notes,
    required this.isCofront,
    required this.createdAt,
  });

  factory FrontSession.fromMap(Map<String, dynamic> map) {
    return FrontSession(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      alters: List<String>.from(map['alters'] as List<dynamic>? ?? []),
      intensity: map['intensity'] as int? ?? 3,
      startTime: DateTime.parse(map['start_time'] as String).toLocal(),
      endTime: map['end_time'] != null ? DateTime.parse(map['end_time'] as String).toLocal() : null,
      triggers: List<String>.from(map['triggers'] as List<dynamic>? ?? []),
      notes: map['notes'] as String?,
      isCofront: map['is_cofront'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String).toLocal(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'alters': alters,
      'intensity': intensity,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'triggers': triggers,
      'notes': notes,
      'is_cofront': isCofront,
      'created_at': createdAt.toIso8601String(),
    };
  }

  FrontSession copyWith({
    String? id,
    String? userId,
    List<String>? alters,
    int? intensity,
    DateTime? startTime,
    DateTime? endTime,
    List<String>? triggers,
    String? notes,
    bool? isCofront,
    DateTime? createdAt,
  }) {
    return FrontSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      alters: alters ?? this.alters,
      intensity: intensity ?? this.intensity,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      triggers: triggers ?? this.triggers,
      notes: notes ?? this.notes,
      isCofront: isCofront ?? this.isCofront,
      createdAt: createdAt ?? this.createdAt,
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
