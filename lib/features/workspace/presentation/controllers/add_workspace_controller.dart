import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:collab_tasker/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_list_controller.dart';

class AddWorkspaceController extends GetxController {
  final WorkspaceRepository _repository = WorkspaceRepositoryImpl();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
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

      await _repository
          .createWorkspace(workspace)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception(
                'Connection timed out. Please check your internet connection.',
              );
            },
          );

      nameController.clear();
      descriptionController.clear();

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
