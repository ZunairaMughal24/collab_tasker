import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';

class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdBy,
    required super.members,
    required super.pendingMembers,
    required super.pendingInvites,
    required super.createdAt,
    super.lastActivityAt,
    super.progress,
    super.totalTasks,
    super.completedTasks,
  });

  factory WorkspaceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkspaceModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdBy: data['createdBy'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      pendingMembers: List<String>.from(data['pendingMembers'] ?? []),
      pendingInvites: List<String>.from(data['pendingInvites'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastActivityAt: data['lastActivityAt'] != null
          ? (data['lastActivityAt'] as Timestamp).toDate()
          : null,
      progress: (data['progress'] ?? 0.0).toDouble(),
      totalTasks: data['totalTasks'] ?? 0,
      completedTasks: data['completedTasks'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'members': members,
      'pendingMembers': pendingMembers,
      'pendingInvites': pendingInvites,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActivityAt': lastActivityAt != null
          ? Timestamp.fromDate(lastActivityAt!)
          : null,
      'progress': progress,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
    };
  }
}
