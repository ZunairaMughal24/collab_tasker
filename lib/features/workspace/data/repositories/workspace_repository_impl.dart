import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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
  Stream<List<Workspace>> watchWorkspaces(String userId) {
    return _firestore
        .collection('workspaces')
        .where('members', arrayContains: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => WorkspaceModel.fromFirestore(doc))
              .toList(),
        );
  }

  @override
  Stream<Workspace> watchWorkspace(String workspaceId) {
    return _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .snapshots()
        .map((doc) => WorkspaceModel.fromFirestore(doc));
  }

  @override
  Future<String> createWorkspace(Workspace workspace) async {
    final model = WorkspaceModel(
      id: workspace.id,
      name: workspace.name,
      description: workspace.description,
      createdBy: workspace.createdBy,
      members: workspace.members,
      pendingMembers: workspace.pendingMembers,
      pendingInvites: workspace.pendingInvites,
      createdAt: workspace.createdAt,
      lastActivityAt: workspace.createdAt,
      progress: workspace.progress,
      totalTasks: workspace.totalTasks,
      completedTasks: workspace.completedTasks,
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

    await _firestore.collection('workspaces').doc(workspaceId).update({
      'lastActivityAt': FieldValue.serverTimestamp(),
    });

    await _updateWorkspaceStats(workspaceId);

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

    await _firestore.collection('workspaces').doc(workspaceId).update({
      'lastActivityAt': FieldValue.serverTimestamp(),
    });

    await _updateWorkspaceStats(workspaceId);
  }

  Future<void> _updateWorkspaceStats(String workspaceId) async {
    try {
      final tasksSnapshot = await _firestore
          .collection('workspaces')
          .doc(workspaceId)
          .collection('tasks')
          .get();

      final totalTasks = tasksSnapshot.docs.length;
      final completedTasks = tasksSnapshot.docs
          .where((doc) => doc.data()['status'] == 'completed')
          .length;

      final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

      await _firestore.collection('workspaces').doc(workspaceId).update({
        'totalTasks': totalTasks,
        'completedTasks': completedTasks,
        'progress': progress,
      });
    } catch (e) {
      debugPrint('Error updating workspace stats: $e');
    }
  }

  @override
  Future<void> addMember(String workspaceId, String email) async {
    try {
      final authRepo = AuthRepositoryImpl();
      final uid = await authRepo.getUIDByEmail(email);

      if (uid == null) {
        await _firestore.collection('workspaces').doc(workspaceId).update({
          'pendingMembers': FieldValue.arrayUnion([email]),
        });
        AppSnackbar.showSuccess(
          'Invitation sent to "$email". They will join upon signing up.',
        );
        return;
      }

      await _firestore.collection('workspaces').doc(workspaceId).update({
        'pendingInvites': FieldValue.arrayUnion([uid]),
      });
      AppSnackbar.showSuccess('Invitation sent to the user.');
    } catch (e) {
      AppSnackbar.showError('Failed to add member: ${e.toString()}');
    }
  }

  @override
  Future<void> cancelInvite(String workspaceId, String email) async {
    await _firestore.collection('workspaces').doc(workspaceId).update({
      'pendingMembers': FieldValue.arrayRemove([email]),
    });
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) async {
    await _firestore.collection('workspaces').doc(workspaceId).delete();
  }

  @override
  Future<void> updateWorkspace(Workspace workspace) async {
    await _firestore.collection('workspaces').doc(workspace.id).update({
      'name': workspace.name,
      'description': workspace.description,
      'lastActivityAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> removeMember(String workspaceId, String userId) async {
    await _firestore.collection('workspaces').doc(workspaceId).update({
      'members': FieldValue.arrayRemove([userId]),
      'pendingInvites': FieldValue.arrayRemove([userId]),
    });
  }

  @override
  Future<void> deleteTask(String workspaceId, String taskId) async {
    await _firestore
        .collection('workspaces')
        .doc(workspaceId)
        .collection('tasks')
        .doc(taskId)
        .delete();

    await _updateWorkspaceStats(workspaceId);
  }
}
