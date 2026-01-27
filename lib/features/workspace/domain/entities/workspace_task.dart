enum TaskPriority { high, medium, low }

enum TaskStatus { pending, inProgress, completed }

class WorkspaceTask {
  final String id;
  final String title;
  final String description;
  final TaskPriority priority;
  final TaskStatus status;
  final String assignedTo;
  final String workspaceId;
  final DateTime? dueDate;
  final DateTime createdAt;

  const WorkspaceTask({
    required this.id,
    required this.title,
    required this.description,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    required this.assignedTo,
    required this.workspaceId,
    this.dueDate,
    required this.createdAt,
  });

  WorkspaceTask copyWith({
    String? id,
    String? title,
    String? description,
    TaskPriority? priority,
    TaskStatus? status,
    String? assignedTo,
    String? workspaceId,
    DateTime? dueDate,
    DateTime? createdAt,
  }) {
    return WorkspaceTask(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      workspaceId: workspaceId ?? this.workspaceId,
      dueDate: dueDate ?? this.dueDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
