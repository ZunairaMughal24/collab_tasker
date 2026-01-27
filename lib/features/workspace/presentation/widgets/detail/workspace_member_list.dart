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
    return Obx(() {
      final members = controller.workspace.value.members;
      final pendingMembers = controller.workspace.value.pendingMembers;
      final totalCount = members.length + pendingMembers.length;

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          final isPending = index >= members.length;
          final memberUid = !isPending ? members[index] : null;
          final pendingEmail = isPending
              ? pendingMembers[index - members.length]
              : null;
          final profile = memberUid != null
              ? controller.memberProfiles[memberUid]
              : null;

          return GlassContainer(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            borderRadius: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isPending
                      ? AppColors.textSecondary.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
                  child: isPending
                      ? const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.textSecondary,
                        )
                      : (profile?['name'] as String? ?? '').isNotEmpty
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
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              isPending
                                  ? 'Pending Invite'
                                  : (profile?['name'] ?? 'Loading...'),
                              style: AppTextStyle.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isPending
                                    ? AppColors.textSecondary
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPending) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'PENDING',
                                style: AppTextStyle.bodySmall.copyWith(
                                  color: AppColors.accent,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        isPending
                            ? pendingEmail!
                            : (profile?['email'] ?? memberUid!),
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
      );
    });
  }
}
