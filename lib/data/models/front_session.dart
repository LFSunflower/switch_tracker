class FrontSession {
  final String id;
  final List<String> versionIds;
  final List<String> triggerIds;
  final int intensity;
  final DateTime startTime;
  final DateTime? endTime;
  final String? notes;

  FrontSession({
    required this.id,
    required this.versionIds,
    required this.triggerIds,
    required this.intensity,
    required this.startTime,
    this.endTime,
    this.notes,
  });

  factory FrontSession.fromMap(Map<String, dynamic> map) {
    return FrontSession(
      id: map['id'],
      versionIds: List<String>.from(map['versions'] ?? []),
      triggerIds: List<String>.from(map['triggers'] ?? []),
      intensity: map['intensity'],
      startTime: DateTime.parse(map['start_time']),
      endTime:
          map['end_time'] != null ? DateTime.parse(map['end_time']) : null,
      notes: map['notes'],
    );
  }
}
