import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_detail_controller.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WorkspaceDetailScreen extends StatelessWidget {
  final Workspace workspace;
  const WorkspaceDetailScreen({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkspaceDetailController(workspace));

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      workspace.name,
                      style: AppTextStyle.displayMedium.copyWith(
                        fontSize: 24.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.glassBackground,
                    child: Icon(Icons.person, color: Colors.white, size: 20.w),
                  ),
                  24.widthBox,
                ],
              ),

              20.heightBox,
              // Banner
              GlassContainer(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(16.w),
                borderRadius: 16,
                borderGradient: const LinearGradient(
                  colors: [AppColors.neonCyan, AppColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        color: AppColors.neonCyan,
                      ),
                    ),
                    16.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'New Workspace!',
                            style: AppTextStyle.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: AppColors.primary.withOpacity(0.5),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'You\'ve been added to "${workspace.name}"',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              24.heightBox,
              // Toggle
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppColors.glassBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Obx(
                  () => Row(
                    children: [
                      _buildToggleButton(
                        'Tasks',
                        controller.selectedView.value == 0,
                        () => controller.switchView(0),
                      ),
                      _buildToggleButton(
                        'Members',
                        controller.selectedView.value == 1,
                        () => controller.switchView(1),
                      ),
                    ],
                  ),
                ),
              ),

              32.heightBox,
              // Content
              Expanded(
                child: Obx(() {
                  if (controller.selectedView.value == 0) {
                    return _buildTasksList(controller);
                  } else {
                    return _buildMembersList(controller);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => controller.selectedView.value == 0
            ? FloatingActionButton(
                onPressed: () => _showAddTaskDialog(context, controller),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: Colors.white),
              )
            : Container(),
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  )
                : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyle.bodyMedium.copyWith(
                color: isSelected ? Colors.white : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTasksList(WorkspaceDetailController controller) {
    if (controller.tasks.isEmpty) {
      return Center(
        child: Text(
          'No tasks in this workspace',
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: controller.tasks.length,
      itemBuilder: (context, index) {
        final task = controller.tasks[index];
        return GlassContainer(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(16.w),
          borderRadius: 16,
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.redAccent, // For demo, use priority color
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              16.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppTextStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    4.heightBox,
                    Text(
                      'Due: Jan 28',
                      style: AppTextStyle.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMembersList(WorkspaceDetailController controller) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: workspace.members.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundColor: AppColors.glassBackground,
            child: Icon(Icons.person, color: Colors.white),
          ),
          title: Text('Member ${index + 1}', style: AppTextStyle.bodyMedium),
          subtitle: Text(
            'Added recently',
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        );
      },
    );
  }

  void _showAddTaskDialog(
    BuildContext context,
    WorkspaceDetailController controller,
  ) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: GlassContainer(
          padding: EdgeInsets.all(24.w),
          borderRadius: 24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'New Task',
                style: AppTextStyle.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              20.heightBox,
              TextField(
                controller: titleController,
                style: AppTextStyle.bodyMedium,
                decoration: const InputDecoration(hintText: 'Task Title'),
              ),
              12.heightBox,
              TextField(
                controller: descController,
                style: AppTextStyle.bodyMedium,
                decoration: const InputDecoration(hintText: 'Description'),
              ),
              24.heightBox,
              AppButton(
                text: 'Create Task',
                onPressed: () {
                  controller.addTask(titleController.text, descController.text);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
