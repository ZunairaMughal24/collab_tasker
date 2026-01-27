import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_detail_controller.dart';

class WorkspaceMemberList extends StatelessWidget {
  final WorkspaceDetailController controller;

  const WorkspaceMemberList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: controller.workspace.value.members.length,
        itemBuilder: (context, index) {
          final memberUid = controller.workspace.value.members[index];
          final profile = controller.memberProfiles[memberUid];

          return GlassContainer(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            borderRadius: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: (profile?['name'] as String? ?? '').isNotEmpty
                      ? Text(
                          (profile!['name'] as String)[0].toUpperCase(),
                          style: const TextStyle(color: AppColors.primary),
                        )
                      : const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                        ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?['name'] ?? 'Loading...',
                        style: AppTextStyle.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        profile?['email'] ?? memberUid,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
