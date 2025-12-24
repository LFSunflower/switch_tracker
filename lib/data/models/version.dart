class Version {
  final String id;
  final String userId;
  final String name;
  final String? pronoun;
  final String? description;
  final String color;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Version({
    required this.id,
    required this.userId,
    required this.name,
    this.pronoun,
    this.description,
    required this.color,
    required this.createdAt,
    this.updatedAt,
  });

  Version copyWith({
    String? id,
    String? userId,
    String? name,
    String? pronoun,
    String? description,
    String? color,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Version(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      pronoun: pronoun ?? this.pronoun,
      description: description ?? this.description,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Version.fromMap(Map<String, dynamic> map) {
    return Version(
      id: map['id'] as String? ?? '',
      userId: map['user_id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      pronoun: map['pronoun'] as String?,
      description: map['description'] as String?,
      color: map['color'] as String? ?? '0xFF6A3AD3',
      createdAt: DateTime.parse(
        map['created_at'] as String? ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'pronoun': pronoun,
      'description': description,
      'color': color,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() => 'Version(id: $id, name: $name, pronoun: $pronoun)';
}
