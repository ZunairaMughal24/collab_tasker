import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';

class AppTextField extends StatelessWidget {
  final String? heading;
  final String? hintText;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final bool isPasswordField;
  final bool isObscure;
  final TextInputType? keyboardType;
  final String? prefixIcon;
  final String? suffixIcon;
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
    this.suffixIcon,
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
          8.heightBox,
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
            fillColor: fillColor ?? AppColors.textFieldFill.withOpacity(0.5),
            filled: true,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 18.h,
            ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.all(12.w),
                    child: SvgPicture.asset(
                      prefixIcon ?? '',
                      colorFilter: const ColorFilter.mode(
                        AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                  )
                : null,
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

  Widget? _buildSuffixIcon() {
    if (suffixIcon != null) {
      return InkWell(
        onTap: onSuffixTap,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: SvgPicture.asset(
            suffixIcon!,
            colorFilter: const ColorFilter.mode(
              AppColors.textSecondary,
              BlendMode.srcIn,
            ),
          ),
        ),
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
