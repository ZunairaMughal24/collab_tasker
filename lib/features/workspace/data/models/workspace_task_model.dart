import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';

class WorkspaceTaskModel extends WorkspaceTask {
  const WorkspaceTaskModel({
    required super.id,
    required super.title,
    required super.description,
    super.priority,
    super.status,
    required super.assignedTo,
    required super.workspaceId,
    super.dueDate,
    required super.createdAt,
  });

  factory WorkspaceTaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkspaceTaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      priority: TaskPriority.values.firstWhere(
        (e) => e.name == data['priority'],
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => TaskStatus.pending,
      ),
      assignedTo: data['assignedTo'] ?? '',
      workspaceId: data['workspaceId'] ?? '',
      dueDate: data['dueDate'] != null
          ? (data['dueDate'] as Timestamp).toDate()
          : null,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'priority': priority.name,
      'status': status.name,
      'assignedTo': assignedTo,
      'workspaceId': workspaceId,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
