import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collab_tasker/features/workspace/data/models/workspace_model.dart';
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
  final selectedView = 0.obs;
  final memberProfiles = <String, Map<String, dynamic>>{}.obs;

  User? get currentUser => _firebaseAuth.currentUser;

  @override
  void onInit() {
    super.onInit();
    _bindWorkspace();
    _bindTasks();
    _fetchMemberProfiles();
  }

  void _bindWorkspace() {
    FirebaseFirestore.instance
        .collection('workspaces')
        .doc(workspace.value.id)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            final updatedWorkspace = WorkspaceModel.fromFirestore(snapshot);
            workspace.value = updatedWorkspace;
            _fetchMemberProfiles();
          }
        });
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
        } catch (e) {
          // Profile not found or error
        }
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

  Future<void> updateTaskStatus(WorkspaceTask task, TaskStatus status) async {
    try {
      final updatedTask = task.copyWith(status: status);
      await _repository.updateTask(workspace.value.id, updatedTask);
      AppSnackbar.showSuccess('Task updated');
    } catch (e) {
      AppSnackbar.showError('Failed to update task: ${e.toString()}');
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

  void switchView(int index) {
    selectedView.value = index;
  }
}
