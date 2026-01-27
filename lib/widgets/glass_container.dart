import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Gradient? borderGradient;
  final Color? borderColor;

  const GlassContainer({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.borderRadius = 16.0,
    this.padding,
    this.margin,
    this.borderGradient,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(opacity),
              borderRadius: BorderRadius.circular(borderRadius.r),
              border: borderGradient == null
                  ? Border.all(
                      color: borderColor ?? AppColors.glassBorder,
                      width: 1.0,
                    )
                  : null,
            ),
            child: borderGradient != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(borderRadius.r),
                      gradient: borderGradient,
                    ),
                    padding: const EdgeInsets.all(1), // Border width
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.glassBase.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(borderRadius.r - 1),
                      ),
                      child: child,
                    ),
                  )
                : child,
          ),
        ),
      ),
    );
  }
}
