import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';
import 'package:collab_tasker/core/utils/validators.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/features/auth/domain/repositories/auth_repository.dart';
import 'package:collab_tasker/features/auth/data/repositories/auth_repository_impl.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final AuthRepository _authRepository = AuthRepositoryImpl();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final errorMessage = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login(BuildContext context) async {
    errorMessage.value = '';

    final emailError = Validators.emailValidator(emailController.text);
    final passwordError = Validators.passwordValidator(passwordController.text);

    if (emailError != null || passwordError != null) {
      AppSnackbar.showError(emailError ?? passwordError!);
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authRepository.signInWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (user != null) {
        final firebaseUser = user.user;
        if (firebaseUser != null) {
          await _authRepository.saveUserData(
            firebaseUser.uid,
            firebaseUser.email ?? '',
            firebaseUser.displayName ?? '',
          );
        }
        await _authRepository.updateFcmToken();
        AppSnackbar.showSuccess('Logged in successfully');
        if (context.mounted) {
          context.go(AppRoutes.workspaceList);
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      AppSnackbar.showError('Login failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
