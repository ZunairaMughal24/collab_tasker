class Workspace {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final List<String> members;
  final DateTime createdAt;
  final double progress;

  const Workspace({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.members,
    required this.createdAt,
    this.progress = 0.0,
  });

  Workspace copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    List<String>? members,
    DateTime? createdAt,
    double? progress,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
      createdAt: createdAt ?? this.createdAt,
      progress: progress ?? this.progress,
    );
  }
}
