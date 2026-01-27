import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';

class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.createdBy,
    required super.members,
    required super.createdAt,
    super.progress,
  });

  factory WorkspaceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return WorkspaceModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      createdBy: data['createdBy'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      progress: (data['progress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'members': members,
      'createdAt': Timestamp.fromDate(createdAt),
      'progress': progress,
    };
  }
}
