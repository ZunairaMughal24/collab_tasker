import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextField extends StatelessWidget {
  final String? heading;
  final String? hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool isPasswordField;
  final bool isObscure;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? prefixIconPath;
  final IconData? suffixIcon;
  final String? suffixIconPath;
  final VoidCallback? onSuffixTap;
  final bool readOnly;
  final int maxLines;
  final Color? fillColor;
  final Function(String)? onChanged;

  const AppTextField({
    super.key,
    this.heading,
    this.hintText,
    this.controller,
    this.validator,
    this.isPasswordField = false,
    this.isObscure = false,
    this.keyboardType,
    this.prefixIcon,
    this.prefixIconPath,
    this.suffixIcon,
    this.suffixIconPath,
    this.onSuffixTap,
    this.readOnly = false,
    this.maxLines = 1,
    this.fillColor,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (heading != null) ...[
          Text(
            heading ?? '',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
        ],

        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: isObscure,
          keyboardType: keyboardType,
          readOnly: readOnly,
          maxLines: maxLines,
          onChanged: onChanged,
          style: AppTextStyle.bodyMedium,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyle.bodyMedium.copyWith(
              color: AppColors.hintText,
            ),
            fillColor: fillColor,
            filled: fillColor != null,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            prefixIcon: _buildPrefixIcon(),
            suffixIcon: _buildSuffixIcon(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.glassBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildPrefixIcon() {
    final path = prefixIconPath;
    Widget? iconWidget;

    if (path != null) {
      iconWidget = Padding(
        padding: EdgeInsets.all(12.w),
        child: SvgPicture.asset(
          path,
          colorFilter: const ColorFilter.mode(
            AppColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
      );
    } else if (prefixIcon != null) {
      iconWidget = Icon(prefixIcon, color: AppColors.textSecondary, size: 20.w);
    }

    if (iconWidget != null && maxLines > 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 12.h), // Align with hint text
          iconWidget,
        ],
      );
    }
    return iconWidget;
  }

  Widget? _buildSuffixIcon() {
    final path = suffixIconPath;
    if (path != null) {
      return InkWell(
        onTap: onSuffixTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: SvgPicture.asset(
            path,
            colorFilter: const ColorFilter.mode(
              AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
      );
    }
    final icon = suffixIcon;
    if (icon != null) {
      return IconButton(
        icon: Icon(icon, color: AppColors.textSecondary, size: 20.w),
        onPressed: onSuffixTap,
      );
    }
    if (isPasswordField) {
      return IconButton(
        icon: Icon(
          isObscure ? Icons.visibility_off : Icons.visibility,
          color: AppColors.textSecondary,
          size: 20.w,
        ),
        onPressed: onSuffixTap,
      );
    }
    return null;
  }
}
