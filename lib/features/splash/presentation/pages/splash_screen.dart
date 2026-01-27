import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:collab_tasker/features/splash/presentation/controllers/splash_controller.dart';

/// Splash screen - pure presentation, zero business logic.
/// All navigation and auth logic is in SplashController.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());
    controller.setContext(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Obx(() {
          // Error state with retry
          if (controller.hasError.value) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: AppTextStyle.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: controller.retry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: Text(
                    'Retry',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            );
          }

          // Loading state (default)
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.task_alt, size: 80, color: AppColors.primary),
              const SizedBox(height: 24),
              Text('Collab Tasker', style: AppTextStyle.displayMedium),
              const SizedBox(height: 24),
              const CircularProgressIndicator(color: AppColors.primary),
            ],
          );
        }),
      ),
    );
  }
}
