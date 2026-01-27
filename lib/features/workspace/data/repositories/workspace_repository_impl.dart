import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collab_tasker/features/workspace/data/models/workspace_model.dart';
import 'package:collab_tasker/features/workspace/data/models/workspace_task_model.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:collab_tasker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<PaginatedResult<Workspace>> getWorkspaces(
    String userId, {
    int limit = 10,
    dynamic lastDoc,
  }) async {
    Query query = _firestore
        .collection('workspaces')
        .where('members', arrayContains: userId)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc as DocumentSnapshot);
    }

    final snapshot = await query.get();
    final workspaces = snapshot.docs
        .map((doc) => WorkspaceModel.fromFirestore(doc))
        .toList();

    return PaginatedResult(
      workspaces,
      snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
    );
  }

  @override
  Future<String> createWorkspace(Workspace workspace) async {
    final model = WorkspaceModel(
      id: workspace.id,
      name: workspace.name,
      description: workspace.description,
      createdBy: workspace.createdBy,
      members: workspace.members,
      createdAt: workspace.createdAt,
      progress: workspace.progress,
    );
    final docRef = await _firestore
        .collection('workspaces')
        .add(model.toFirestore());
    return docRef.id;
  }

  @override
  Stream<List<WorkspaceTask>> getTasks(String workspaceId) {
    return _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkspaceTaskModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Future<String> addTask(String workspaceId, WorkspaceTask task) async {
    final model = WorkspaceTaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      assignedTo: task.assignedTo,
      workspaceId: task.workspaceId,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
    );
    final docRef = await _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('tasks')
        .add(model.toFirestore());
    return docRef.id;
  }

  @override
  Future<void> updateTask(String workspaceId, WorkspaceTask task) async {
    final model = WorkspaceTaskModel(
      id: task.id,
      title: task.title,
      description: task.description,
      priority: task.priority,
      status: task.status,
      assignedTo: task.assignedTo,
      workspaceId: task.workspaceId,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
    );
    await _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('tasks')
        .doc(task.id)
        .update(model.toFirestore());
  }

  @override
  Future<void> addMember(String workspaceId, String email) async {
    try {
      final authRepo = AuthRepositoryImpl();
      final uid = await authRepo.getUIDByEmail(email);

      if (uid == null) {
        AppSnackbar.showError('No user found with this email.');
        return;
      }

      await _firestore.collection('workspaces').doc(workspaceId).update({
        'members': FieldValue.arrayUnion([uid]),
      });
    } catch (e) {
      AppSnackbar.showError('Failed to add member: ${e.toString()}');
    }
  }
}
