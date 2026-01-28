import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:collab_tasker/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';

class WorkspaceDetailController extends GetxController {
  final WorkspaceRepository _repository = WorkspaceRepositoryImpl();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Rx<Workspace> workspace;
  WorkspaceDetailController(Workspace initialWorkspace)
    : workspace = initialWorkspace.obs;

  final tasks = <WorkspaceTask>[].obs;
  final isLoadingTasks = false.obs;
  final isLoadingInfo = false.obs;
  final selectedView = 0.obs;
  final memberProfiles = <String, Map<String, dynamic>>{}.obs;

  User? get currentUser => _firebaseAuth.currentUser;

  bool get isCreator => workspace.value.createdBy == currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    _bindWorkspace();
    _bindTasks();
    _fetchMemberProfiles();
  }

  void _bindWorkspace() {
    workspace.bindStream(_repository.watchWorkspace(workspace.value.id));

    ever(workspace, (_) => _fetchMemberProfiles());
  }

  void _bindTasks() {
    tasks.bindStream(_repository.getTasks(workspace.value.id));
  }

  Future<void> _fetchMemberProfiles() async {
    final firestore = FirebaseFirestore.instance;
    for (final uid in workspace.value.members) {
      if (!memberProfiles.containsKey(uid)) {
        try {
          final doc = await firestore.collection('users').doc(uid).get();
          if (doc.exists && doc.data() != null) {
            memberProfiles[uid] = doc.data()!;
          }
        } catch (e) {}
      }
    }
  }

  Future<void> addTask(
    BuildContext context,
    String title,
    String description,
  ) async {
    final user = currentUser;
    if (user == null) return;

    try {
      isLoadingTasks.value = true;
      final task = WorkspaceTask(
        id: '',
        title: title,
        description: description,
        assignedTo: user.uid,
        workspaceId: workspace.value.id,
        createdAt: DateTime.now(),
      );

      await _repository.addTask(workspace.value.id, task);
      if (context.mounted) {
        AppSnackbar.showSuccess('Task Added Successfully!');
      }
    } catch (e) {
      AppSnackbar.showError('Failed to add task: ${e.toString()}');
    } finally {
      isLoadingTasks.value = false;
    }
  }

  Future<void> updateTask(WorkspaceTask task) async {
    try {
      await _repository.updateTask(workspace.value.id, task);
      AppSnackbar.showSuccess('Task updated');
    } catch (e) {
      AppSnackbar.showError('Failed to update task');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _repository.deleteTask(workspace.value.id, taskId);
      AppSnackbar.showSuccess('Task deleted');
    } catch (e) {
      AppSnackbar.showError('Failed to delete task');
    }
  }

  Future<void> updateTaskStatus(WorkspaceTask task, TaskStatus status) async {
    try {
      final updatedTask = task.copyWith(status: status);
      await _repository.updateTask(workspace.value.id, updatedTask);
      AppSnackbar.showSuccess('Task progress updated');
    } catch (e) {
      AppSnackbar.showError('Failed to update task status');
    }
  }

  Future<void> addMember(BuildContext context, String email) async {
    try {
      isLoadingTasks.value = true;
      await _repository.addMember(
        workspace.value.id,
        email.trim().toLowerCase(),
      );
      if (context.mounted) {
        AppSnackbar.showSuccess('Member Added Successfully!');
      }

      _fetchMemberProfiles();
    } catch (e) {
      AppSnackbar.showError('Failed to add member: ${e.toString()}');
    } finally {
      isLoadingTasks.value = false;
    }
  }

  Future<void> removeMember(String userId) async {
    try {
      await _repository.removeMember(workspace.value.id, userId);
      memberProfiles.remove(userId);
      AppSnackbar.showSuccess('Member removed');
    } catch (e) {
      AppSnackbar.showError('Failed to remove member');
    }
  }

  Future<void> cancelInvite(String email) async {
    try {
      await _repository.cancelInvite(workspace.value.id, email);
      AppSnackbar.showSuccess('Invitation cancelled');
    } catch (e) {
      AppSnackbar.showError('Failed to cancel invitation');
    }
  }

  Future<void> updateWorkspaceInfo(String name, String description) async {
    if (name.isEmpty) {
      AppSnackbar.showError('Name cannot be empty');
      return;
    }

    try {
      isLoadingInfo.value = true;
      final updatedWorkspace = workspace.value.copyWith(
        name: name.trim(),
        description: description.trim(),
      );
      await _repository.updateWorkspace(updatedWorkspace);
      AppSnackbar.showSuccess('Workspace updated successfully');
    } catch (e) {
      AppSnackbar.showError('Failed to update workspace');
    } finally {
      isLoadingInfo.value = false;
    }
  }

  void switchView(int index) {
    selectedView.value = index;
  }
}
