class Version {
  final String id;
  final String name;
  final String color; // hex ou nome
  final String? description;

  Version({
    required this.id,
    required this.name,
    required this.color,
    this.description,
  });

  factory Version.fromMap(Map<String, dynamic> map) {
    return Version(
      id: map['id'],
      name: map['name'],
      color: map['color'],
      description: map['description'],
    );
  }
}
