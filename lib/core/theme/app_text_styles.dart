import 'package:flutter/material.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  static TextStyle get base =>
      const TextStyle(fontFamily: 'Nunito', color: AppColors.textPrimary);

  static TextStyle displayLarge = base.copyWith(
    fontSize: 32.sp,
    fontWeight: FontWeight.w800,
    height: 1.14,
  );

  static TextStyle displayMedium = base.copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.w800,
    height: 1.18,
  );

  static TextStyle bodyLarge = base.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle bodyMedium = base.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle bodySmall = base.copyWith(
    fontSize: 13.sp,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle labelLarge = base.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelMedium = base.copyWith(
    fontSize: 12.5.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
  );

  static TextStyle poppins16normal400() => base.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static TextStyle poppins24normal500() => base.copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
}
