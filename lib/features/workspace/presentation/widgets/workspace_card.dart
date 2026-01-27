import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/core/utils/padding_extension.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';

class WorkspaceCard extends StatelessWidget {
  final Workspace workspace;
  final VoidCallback onTap;

  const WorkspaceCard({
    super.key,
    required this.workspace,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: EdgeInsets.all(20.w),
      borderRadius: 20,
      borderGradient: LinearGradient(
        colors: [
          AppColors.primary.withOpacity(0.5),
          AppColors.neonCyan.withOpacity(0.3),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: InkWell(
        onTap: onTap,
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
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.5),
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
                  ),
              ],
            ),
            12.heightBox,
            Text(
              workspace.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            20.heightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Members count
                Row(
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 16.w,
                      color: AppColors.textSecondary,
                    ),
                    8.widthBox,
                    Text(
                      '${workspace.members.length} Members',
                      style: AppTextStyle.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                // Progress indicator
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 40.w,
                      height: 40.w,
                      child: CircularProgressIndicator(
                        value: workspace.progress,
                        strokeWidth: 3,
                        backgroundColor: AppColors.glassBorder.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          workspace.progress > 0.7
                              ? Colors.greenAccent
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    Text(
                      '${(workspace.progress * 100).toInt()}%',
                      style: AppTextStyle.labelMedium.copyWith(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ).py12();
  }
}
