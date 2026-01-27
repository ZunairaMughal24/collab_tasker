import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:collab_tasker/features/workspace/data/repositories/workspace_repository_impl.dart';

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
    fetchWorkspaces();
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
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
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
    fetchWorkspaces();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
