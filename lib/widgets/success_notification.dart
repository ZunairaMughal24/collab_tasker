import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/widgets/glass_container.dart';

class SuccessNotification extends StatelessWidget {
  final String title;
  final String message;

  const SuccessNotification({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: GlassContainer(
          margin: EdgeInsets.all(40.w),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          borderRadius: 32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.greenAccent.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: Colors.greenAccent,
                  size: 48.w,
                ),
              ),
              24.heightBox,
              Text(
                title,
                style: AppTextStyle.displayMedium.copyWith(fontSize: 20.sp),
                textAlign: TextAlign.center,
              ),
              8.heightBox,
              Text(
                message,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              32.heightBox,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showSuccessNotification({
  required BuildContext context,
  required String title,
  required String message,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => SuccessNotification(title: title, message: message),
  );
}
