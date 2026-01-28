import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/widgets/glass_container.dart';

class WorkspaceCard extends StatelessWidget {
  final Workspace workspace;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const WorkspaceCard({
    super.key,
    required this.workspace,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: GlassContainer(
        padding: EdgeInsets.zero,
        borderRadius: 20,
        margin: EdgeInsets.symmetric(vertical: 8.h),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        workspace.name,
                        style: AppTextStyle.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    if (workspace.createdAt.isAfter(
                      DateTime.now().subtract(const Duration(days: 1)),
                    ))
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          'NEW',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      )
                    else if (workspace.lastActivityAt != null &&
                        workspace.lastActivityAt!.isAfter(
                          DateTime.now().subtract(const Duration(hours: 24)),
                        ))
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.accent.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          'UPDATED',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  workspace.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Members and Tasks count
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.group_work_outlined,
                                size: 16.w,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '${workspace.members.length} Members',
                                style: AppTextStyle.labelMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.task_alt_rounded,
                                size: 16.w,
                                color: AppColors.accent,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                '${workspace.totalTasks} Tasks (${workspace.completedTasks} done)',
                                style: AppTextStyle.labelMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 44.w,
                              height: 44.w,
                              child: CircularProgressIndicator(
                                value: workspace.progress,
                                strokeWidth: 3.5,
                                backgroundColor: AppColors.white.withValues(
                                  alpha: 0.05,
                                ),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  workspace.progress >= 1.0
                                      ? Colors.greenAccent
                                      : workspace.progress > 0
                                      ? AppColors.primary
                                      : AppColors.white.withValues(alpha: 0.1),
                                ),
                              ),
                            ),
                            Text(
                              '${(workspace.progress * 100).toInt()}%',
                              style: AppTextStyle.labelMedium.copyWith(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          workspace.progress == 0
                              ? 'Not started'
                              : workspace.progress >= 1.0
                              ? 'Completed'
                              : 'In progress',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: workspace.progress == 0
                                ? AppColors.textSecondary
                                : workspace.progress >= 1.0
                                ? Colors.greenAccent
                                : AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
