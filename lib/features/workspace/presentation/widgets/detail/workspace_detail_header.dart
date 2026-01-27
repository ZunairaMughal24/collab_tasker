import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_detail_controller.dart';

class WorkspaceDetailHeader extends StatelessWidget {
  final WorkspaceDetailController controller;

  const WorkspaceDetailHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        Expanded(
          child: Obx(
            () => Text(
              controller.workspace.value.name,
              style: AppTextStyle.displayMedium.copyWith(fontSize: 22.sp),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 20.w,
          ),
          radius: 18,
        ),
        24.widthBox,
      ],
    );
  }
}
