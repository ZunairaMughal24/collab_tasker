import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';
import 'package:collab_tasker/features/auth/domain/repositories/auth_repository.dart';
import 'package:collab_tasker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:collab_tasker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:go_router/go_router.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepositoryImpl(
    AuthRemoteDataSource(),
  );
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(BuildContext context) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      AppSnackbar.showError('Please fill all fields');
      return;
    }

    isLoading.value = true;
    final user = await _authRepository.signInWithEmailAndPassword(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    isLoading.value = false;

    if (user != null) {
      AppSnackbar.showSuccess('Logged in successfully');
      if (context.mounted) {
        context.go(AppRoutes.workspaceList);
      }
    }
  }

  void navigateToSignUp() {
    // router handle this usually, but GetX can also do it if needed
  }
}
