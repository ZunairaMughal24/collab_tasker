import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_detail_controller.dart';

class WorkspaceTaskList extends StatelessWidget {
  final WorkspaceDetailController controller;

  const WorkspaceTaskList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.tasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.task_alt_rounded,
                size: 48.w,
                color: AppColors.textSecondary.withValues(alpha: 0.3),
              ),
              SizedBox(height: 16.h),
              Text(
                'No tasks yet',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: controller.tasks.length,
        itemBuilder: (context, index) {
          final task = controller.tasks[index];
          return _buildTaskCard(task);
        },
      );
    });
  }

  Widget _buildTaskCard(WorkspaceTask task) {
    final isCompleted = task.status == TaskStatus.completed;

    return GlassContainer(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.greenAccent : AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: AppTextStyle.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted ? AppColors.textSecondary : Colors.white,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  task.description.isEmpty
                      ? 'No description'
                      : task.description,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (!isCompleted)
            IconButton(
              onPressed: () =>
                  controller.updateTaskStatus(task, TaskStatus.completed),
              icon: Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.primary,
                size: 26.w,
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(8.w),
              child: Icon(
                Icons.check_circle_rounded,
                color: Colors.greenAccent,
                size: 26.w,
              ),
            ),
        ],
      ),
    );
  }
}
