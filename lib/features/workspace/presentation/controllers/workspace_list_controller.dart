import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:collab_tasker/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';

class WorkspaceListController extends GetxController {
  final WorkspaceRepository _repository = WorkspaceRepositoryImpl();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final workspaces = <Workspace>[].obs;
  final isLoading = false.obs;
  final isMoreLoading = false.obs;
  final hasMore = true.obs;
  final errorMessage = ''.obs;
  dynamic lastDoc;

  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_scrollListener);
    _listenToWorkspaces();
  }

  void _listenToWorkspaces() {
    final user = currentUser;
    if (user == null) return;
    workspaces.bindStream(_repository.watchWorkspaces(user.uid));
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      if (!isMoreLoading.value && hasMore.value) {
        fetchMoreWorkspaces();
      }
    }
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Future<void> fetchWorkspaces() async {
    final user = currentUser;
    if (user == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final result = await _repository.getWorkspaces(user.uid, limit: 10);
      workspaces.value = result.items;
      lastDoc = result.lastDoc;
      hasMore.value = result.items.length >= 10;
    } catch (e) {
      errorMessage.value = 'Failed to load workspaces';
      Get.snackbar(
        'Error',
        'Failed to load workspaces: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteWorkspace(String workspaceId) async {
    try {
      await _repository.deleteWorkspace(workspaceId);
      refreshWorkspaces();
      AppSnackbar.showSuccess('Workspace deleted successfully');
    } catch (e) {
      AppSnackbar.showError('Failed to delete workspace');
    }
  }

  Future<void> updateWorkspace(Workspace workspace) async {
    try {
      await _repository.updateWorkspace(workspace);
      refreshWorkspaces();
      AppSnackbar.showSuccess('Workspace updated successfully');
    } catch (e) {
      AppSnackbar.showError('Failed to update workspace: ${e.toString()}');
    }
  }

  Future<void> fetchMoreWorkspaces() async {
    final user = currentUser;
    if (user == null) return;

    isMoreLoading.value = true;
    try {
      final result = await _repository.getWorkspaces(
        user.uid,
        limit: 10,
        lastDoc: lastDoc,
      );
      if (result.items.isEmpty) {
        hasMore.value = false;
      } else {
        workspaces.addAll(result.items);
        lastDoc = result.lastDoc;
        hasMore.value = result.items.length >= 10;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load more: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isMoreLoading.value = false;
    }
  }

  void refreshWorkspaces() {
    lastDoc = null;
    hasMore.value = true;
    _listenToWorkspaces();
  }

  Future<void> cancelInvite(String workspaceId, String email) async {
    try {
      await _repository.cancelInvite(workspaceId, email);
      AppSnackbar.showSuccess('Invitation cancelled');
    } catch (e) {
      AppSnackbar.showError('Failed to cancel invitation');
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
