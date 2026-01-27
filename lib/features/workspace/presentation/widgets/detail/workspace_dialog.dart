import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/widgets/glass_container.dart';

class WorkspaceDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final Widget? action;

  const WorkspaceDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: GlassContainer(
          padding: EdgeInsets.all(28.w),
          borderRadius: 32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyle.displayMedium.copyWith(fontSize: 24.sp),
              ),
              if (subtitle != null) ...[
                SizedBox(height: 8.h),
                Text(
                  subtitle!,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              ...children,
              if (action != null) ...[
                SizedBox(height: 24.h),
                SizedBox(width: double.infinity, child: action!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
