import 'package:flutter/material.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  static TextStyle get base =>
      const TextStyle(fontFamily: 'Nunito', color: AppColors.textPrimary);

  static TextStyle displayLarge = base.copyWith(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle displayMedium = base.copyWith(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyLarge = base.copyWith(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodyMedium = base.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle bodySmall = base.copyWith(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
  );

  static TextStyle labelLarge = base.copyWith(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle labelMedium = base.copyWith(
    fontSize: 12.sp,
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
