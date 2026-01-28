class Workspace {
  final String id;
  final String name;
  final String description;
  final String createdBy;
  final List<String> members;
  final List<String> pendingMembers;
  final List<String> pendingInvites;
  final DateTime createdAt;
  final DateTime? lastActivityAt;
  final double progress;
  final int totalTasks;
  final int completedTasks;

  const Workspace({
    required this.id,
    required this.name,
    required this.description,
    required this.createdBy,
    required this.members,
    required this.createdAt,
    this.lastActivityAt,
    this.pendingMembers = const [],
    this.pendingInvites = const [],
    this.progress = 0.0,
    this.totalTasks = 0,
    this.completedTasks = 0,
  });

  Workspace copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    List<String>? members,
    List<String>? pendingMembers,
    List<String>? pendingInvites,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    double? progress,
    int? totalTasks,
    int? completedTasks,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
      pendingMembers: pendingMembers ?? this.pendingMembers,
      pendingInvites: pendingInvites ?? this.pendingInvites,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      progress: progress ?? this.progress,
      totalTasks: totalTasks ?? this.totalTasks,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }
}
