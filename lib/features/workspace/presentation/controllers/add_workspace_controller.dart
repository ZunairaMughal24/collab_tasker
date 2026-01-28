import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:collab_tasker/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_list_controller.dart';

class AddWorkspaceController extends GetxController {
  final WorkspaceRepository _repository = WorkspaceRepositoryImpl();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  // Integrated creation fields
  final taskTitleController = TextEditingController();
  final taskDescController = TextEditingController();
  final memberEmailController = TextEditingController();

  final isLoading = false.obs;

  Future<void> createWorkspace(BuildContext context) async {
    if (nameController.text.isEmpty) {
      AppSnackbar.showError('Please enter a workspace name');
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final workspace = Workspace(
        id: '',
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        createdBy: user.uid,
        members: [user.uid],
        createdAt: DateTime.now(),
      );

      final workspaceId = await _repository.createWorkspace(workspace);

      // Add initial task if provided
      if (taskTitleController.text.isNotEmpty) {
        final initialTask = WorkspaceTask(
          id: '',
          title: taskTitleController.text.trim(),
          description: taskDescController.text.trim(),
          assignedTo: user.uid,
          workspaceId: workspaceId,
          createdAt: DateTime.now(),
        );
        await _repository.addTask(workspaceId, initialTask);
      }

      // Invite initial member if provided
      if (memberEmailController.text.isNotEmpty) {
        await _repository.addMember(
          workspaceId,
          memberEmailController.text.trim(),
        );
      }

      nameController.clear();
      descriptionController.clear();
      taskTitleController.clear();
      taskDescController.clear();
      memberEmailController.clear();

      if (Get.isRegistered<WorkspaceListController>()) {
        Get.find<WorkspaceListController>().refreshWorkspaces();
      }

      if (context.mounted) {
        AppSnackbar.showSuccess('Workspace Created Successfully!');
        context.pop();
      }
    } catch (e) {
      AppSnackbar.showError('Failed to create workspace: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
