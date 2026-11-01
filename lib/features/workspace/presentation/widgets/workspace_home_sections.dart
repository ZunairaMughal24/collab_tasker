import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeaturedWorkspaceCard extends StatelessWidget {
  const FeaturedWorkspaceCard({
    super.key,
    required this.workspace,
    required this.onTap,
  });

  final Workspace workspace;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF3DFD2), Color(0xFFE9C7B6), Color(0xFFF5E7DA)],
          ),
          borderRadius: BorderRadius.circular(19),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(19),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 15.h, 12.w, 14.h),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 75.w,
                    color: Colors.white.withValues(alpha: 0.43),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 13.r,
                          backgroundColor: AppColors.primary,
                          child: const Icon(
                            Icons.groups_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 7.w),
                        Text(
                          'Your team space',
                          style: AppTextStyle.bannerTitle,
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: 220.w,
                      child: Text(
                        'Stay on top of tasks and keep your team moving.',
                        maxLines: 2,
                        style: AppTextStyle.bannerBody,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_outward_rounded,
                            size: 14,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            'Open workspace',
                            style: AppTextStyle.cardMeta.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

class ScheduleShortcutCard extends StatelessWidget {
  const ScheduleShortcutCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE9EEE8),
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Padding(
          padding: EdgeInsets.fromLTRB(15.w, 13.h, 13.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text('Your schedule', style: AppTextStyle.cardMeta),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_up_rounded,
                    size: 19,
                    color: AppColors.textPrimary,
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              Text('Plan your week', style: AppTextStyle.cardTitle),
              SizedBox(height: 2.h),
              Text(
                'See tasks and keep your team on track',
                style: AppTextStyle.cardSubtitle,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 15.w,
                    color: AppColors.success,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Open schedule',
                    style: AppTextStyle.cardMeta.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.success,
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
    );
  }
}

class WorkspaceEmptyState extends StatelessWidget {
  const WorkspaceEmptyState({super.key, required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 120.h),
      children: [
        Text(
          'YOUR WORKSPACES',
          style: TextStyle(
            fontFamily: 'Nunito',
            color: AppColors.primary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.3,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'No workspaces yet',
          style: AppTextStyle.displayMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 27.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          'Create a workspace for a project or team. Your tasks and progress will show up here.',
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 27.h),
        Container(
          padding: EdgeInsets.all(21.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, Color(0xFFC87553)],
            ),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.17),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.space_dashboard_outlined,
                  color: Colors.white,
                  size: 23.w,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Start a workspace',
                style: AppTextStyle.bodyLarge.copyWith(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                'Add tasks, share them with your team, and see what is done.',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: const Color(0xFFFFE8DD),
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 21.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onCreate,
                  icon: const Icon(Icons.add_rounded, size: 19),
                  label: const Text('Create workspace'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
