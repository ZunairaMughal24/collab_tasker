import 'package:flutter/material.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class AppSnackbar {
  static void showSuccess(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.success.withOpacity(0.9),
      icon: Icons.check_circle_outline,
    );
  }

  static void showError(String message) {
    _show(
      message: message,
      backgroundColor: AppColors.error.withOpacity(0.9),
      icon: Icons.error_outline,
    );
  }

  static void _show({
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    snackbarKey.currentState?.hideCurrentSnackBar();
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24.w),
            12.widthBox,
            Expanded(
              child: Text(
                message,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        margin: EdgeInsets.all(24.w),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

extension SpacingExtension on num {
  Widget get widthBox => SizedBox(width: toDouble().w);
}
