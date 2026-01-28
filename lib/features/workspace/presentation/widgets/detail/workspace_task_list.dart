import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/detail/workspace_dialog.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
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
          return GestureDetector(
            onLongPress: () => _showTaskManagementMenu(context, task),
            child: _buildTaskCard(context, task),
          );
        },
      );
    });
  }

  Widget _buildTaskCard(BuildContext context, WorkspaceTask task) {
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
          IconButton(
            onPressed: () => _showTaskManagementMenu(context, task),
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showTaskManagementMenu(BuildContext context, WorkspaceTask task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 24.h),
            _buildMenuOption(
              icon: Icons.edit_outlined,
              title: 'Edit Task',
              onTap: () {
                Navigator.pop(context);
                _showEditTaskDialog(context, task);
              },
            ),
            SizedBox(height: 12.h),
            _buildMenuOption(
              icon: Icons.delete_outline_rounded,
              title: 'Delete Task',
              isDanger: true,
              onTap: () {
                Navigator.pop(context);
                _confirmDeleteTask(context, task);
              },
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: isDanger ? AppColors.error : Colors.white),
      title: Text(
        title,
        style: AppTextStyle.bodyLarge.copyWith(
          color: isDanger ? AppColors.error : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white.withValues(alpha: 0.05),
    );
  }

  void _showEditTaskDialog(BuildContext context, WorkspaceTask task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);

    showDialog(
      context: context,
      builder: (context) => WorkspaceDialog(
        title: 'Edit Task',
        subtitle: 'Update your task details',
        action: AppButton(
          text: 'Save Changes',
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              controller.updateTask(
                task.copyWith(
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                ),
              );
              Navigator.pop(context);
            }
          },
        ),
        children: [
          AppTextField(
            heading: 'Task Title',
            hintText: 'What needs to be done?',
            controller: titleController,
            prefixIcon: Icons.task_alt_rounded,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            heading: 'Description',
            hintText: 'Add some details...',
            controller: descController,
            maxLines: 3,
            prefixIcon: Icons.description_outlined,
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, WorkspaceTask task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Delete Task', style: AppTextStyle.displayMedium),
        content: Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              controller.deleteTask(task.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
