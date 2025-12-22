class Trigger {
  final String id;
  final String label;

  Trigger({
    required this.id,
    required this.label,
  });

  factory Trigger.fromMap(Map<String, dynamic> map) {
    return Trigger(
      id: map['id'],
      label: map['label'],
    );
  }
}
