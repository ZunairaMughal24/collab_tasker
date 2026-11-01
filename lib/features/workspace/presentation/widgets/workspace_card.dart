import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/demo_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkspaceCard extends StatelessWidget {
  const WorkspaceCard({
    super.key,
    required this.workspace,
    required this.onTap,
    this.onLongPress,
    this.tone = 0,
  });

  final Workspace workspace;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final int tone;

  @override
  Widget build(BuildContext context) {
    const cardColors = [
      Color(0xFFF4E9E2),
      Color(0xFFEDEFEA),
      Color(0xFFF3EEE4),
    ];
    final completed =
        workspace.totalTasks > 0 &&
        workspace.completedTasks >= workspace.totalTasks;
    return Padding(
      padding: EdgeInsets.only(bottom: 11.h),
      child: Material(
        color: cardColors[tone % cardColors.length],
        borderRadius: BorderRadius.circular(19),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(19),
          child: Padding(
            padding: EdgeInsets.fromLTRB(15.w, 13.h, 13.w, 13.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(3.w, 3.h, 11.w, 3.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DemoAvatar(index: tone + 1, size: 26.r),
                          SizedBox(width: 6.w),
                          Text('Team workspace', style: AppTextStyle.cardMeta),
                        ],
                      ),
                    ),
                    const Spacer(),
                    CircleAvatar(
                      radius: 15.r,
                      backgroundColor: Colors.white.withValues(alpha: 0.84),
                      child: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        color: AppColors.textPrimary,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Text(
                  workspace.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.cardTitle,
                ),
                SizedBox(height: 1.h),
                Text(
                  workspace.description.isEmpty
                      ? 'Plan together with your team'
                      : workspace.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.cardSubtitle,
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.72),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    completed
                        ? 'Completed'
                        : '${workspace.completedTasks}/${workspace.totalTasks} tasks done',
                    style: AppTextStyle.cardMeta.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                SizedBox(height: 13.h),
                Row(
                  children: [
                    _MemberStack(count: workspace.members.length),
                    if (workspace.members.length > 3) ...[
                      SizedBox(width: 5.w),
                      Text(
                        '+${workspace.members.length - 3}',
                        style: AppTextStyle.cardMeta.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    const Spacer(),
                    CircleAvatar(
                      radius: 16.r,
                      backgroundColor: AppColors.primary,
                      child: const Icon(
                        Icons.arrow_outward_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
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

class _MemberStack extends StatelessWidget {
  const _MemberStack({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) {
    final visible = count.clamp(0, 3);
    if (visible == 0) {
      return Text(
        'Invite your team',
        style: AppTextStyle.cardMeta.copyWith(color: AppColors.textSecondary),
      );
    }
    return SizedBox(
      width: 19.0 * visible + 6,
      height: 27,
      child: Stack(
        children: [
          for (var index = 0; index < visible; index++)
            Positioned(
              left: index * 19.0,
              child: DemoAvatar(index: index + 1, size: 26),
            ),
        ],
      ),
    );
  }
}
