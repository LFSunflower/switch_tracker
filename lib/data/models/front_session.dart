class FrontSession {
  final String id;
  final String userId;
  final List<String> alterIds;
  final int intensity;
  final List<String> triggers;
  final String? notes;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isCoFront;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const FrontSession({
    required this.id,
    required this.userId,
    required this.alterIds,
    required this.intensity,
    this.triggers = const [],
    this.notes,
    required this.startTime,
    this.endTime,
    this.isCoFront = false,
    required this.createdAt,
    this.updatedAt,
  });

  /// Duração da sessão em minutos
  int get durationMinutes {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inMinutes;
  }

  /// Duração formatada
  String get durationFormatted {
    final minutes = durationMinutes;
    if (minutes < 60) {
      return '${minutes}m';
    } else if (minutes < 1440) {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      return '${hours}h ${remainingMinutes}m';
    } else {
      final days = minutes ~/ 1440;
      final remainingHours = (minutes % 1440) ~/ 60;
      return '${days}d ${remainingHours}h';
    }
  }

  /// Sessão ativa?
  bool get isActive => endTime == null;

  FrontSession copyWith({
    String? id,
    String? userId,
    List<String>? alterIds,
    int? intensity,
    List<String>? triggers,
    String? notes,
    DateTime? startTime,
    DateTime? endTime,
    bool? isCoFront,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FrontSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      alterIds: alterIds ?? this.alterIds,
      intensity: intensity ?? this.intensity,
      triggers: triggers ?? this.triggers,
      notes: notes ?? this.notes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isCoFront: isCoFront ?? this.isCoFront,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory FrontSession.fromMap(Map<String, dynamic> map) {
    return FrontSession(
      id: map['id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      alterIds: List<String>.from(map['alter_ids'] as List<dynamic>? ?? []),
      intensity: map['intensity'] as int? ?? 3,
      triggers: List<String>.from(map['triggers'] as List<dynamic>? ?? []),
      notes: map['notes'] as String?,
      startTime: DateTime.parse(
          map['start_time'] as String? ?? DateTime.now().toIso8601String()),
      endTime: map['end_time'] != null
          ? DateTime.parse(map['end_time'] as String)
          : null,
      isCoFront: map['is_co_front'] as bool? ?? false,
      createdAt: DateTime.parse(
          map['created_at'] as String? ?? DateTime.now().toIso8601String()),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'alter_ids': alterIds,
      'intensity': intensity,
      'triggers': triggers,
      'notes': notes,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'is_co_front': isCoFront,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'FrontSession(id: $id, alterIds: $alterIds, intensity: $intensity)';
}
