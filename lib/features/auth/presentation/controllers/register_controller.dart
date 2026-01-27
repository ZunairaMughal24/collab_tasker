import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';
import 'package:collab_tasker/core/utils/validators.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/features/auth/domain/repositories/auth_repository.dart';
import 'package:collab_tasker/features/auth/data/repositories/auth_repository_impl.dart';

class RegisterController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepositoryImpl();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final errorMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> register(BuildContext context) async {
    // Clear previous error
    errorMessage.value = '';

    final nameError = Validators.nameValidator(nameController.text);
    final emailError = Validators.emailValidator(emailController.text);
    final passwordError = Validators.passwordValidator(passwordController.text);

    if (nameError != null) {
      AppSnackbar.showError(nameError);
      return;
    }
    if (emailError != null) {
      AppSnackbar.showError(emailError);
      return;
    }
    if (passwordError != null) {
      AppSnackbar.showError(passwordError);
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      AppSnackbar.showError('Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;

      final userCredential = await _authRepository.signUpWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (userCredential != null) {
        AppSnackbar.showSuccess('Account created successfully');
        await userCredential.user?.updateDisplayName(
          nameController.text.trim(),
        );

        if (context.mounted) {
          context.go(AppRoutes.workspaceList);
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.showError('Registration failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
