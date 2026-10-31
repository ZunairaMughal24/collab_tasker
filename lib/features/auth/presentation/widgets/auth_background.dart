import 'package:flutter/material.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: AppColors.background, child: child);
  }
}
