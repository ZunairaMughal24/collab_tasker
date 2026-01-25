import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';
import 'package:collab_tasker/features/auth/domain/repositories/auth_repository.dart';
import 'package:collab_tasker/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:collab_tasker/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:go_router/go_router.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepositoryImpl(
    AuthRemoteDataSource(),
  );
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register(BuildContext context) async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      AppSnackbar.showError('Please fill all fields');
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.showError('Passwords do not match');
      return;
    }

    isLoading.value = true;
    final user = await _authRepository.signUpWithEmailAndPassword(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    isLoading.value = false;

    if (user != null) {
      AppSnackbar.showSuccess('Account created successfully');
      // Update display name (simplified for now as optional)
      await user.user?.updateDisplayName(nameController.text.trim());

      if (context.mounted) {
        context.go(AppRoutes.workspaceList);
      }
    }
  }
}
