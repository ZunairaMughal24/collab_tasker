import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/features/auth/domain/repositories/auth_repository.dart';
import 'package:collab_tasker/features/auth/data/repositories/auth_repository_impl.dart';

class SplashController extends GetxController {
  final AuthRepository _authRepository = AuthRepositoryImpl();

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  late BuildContext _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2), () {
      checkAuthAndNavigate();
    });
  }

  Future<void> checkAuthAndNavigate() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final user = await Future.any([
        Future.value(_authRepository.currentUser),
        Future.delayed(const Duration(seconds: 5), () => null),
      ]);

      debugPrint('SplashController: User is ${user?.uid}');

      if (!_context.mounted) return;

      if (user != null) {
        await _authRepository.updateFcmToken();
        debugPrint('SplashController: Navigating to WorkspaceList');
        _context.go(AppRoutes.workspaceList);
      } else {
        debugPrint('SplashController: Navigating to SignIn');
        _context.go(AppRoutes.signIn);
      }
    } catch (e, stackTrace) {
      debugPrint('SplashController Error: $e');
      debugPrint('StackTrace: $stackTrace');

      hasError.value = true;
      errorMessage.value = 'Something went wrong. Please try again.';
      isLoading.value = false;
    }
  }

  void retry() {
    checkAuthAndNavigate();
  }
}
