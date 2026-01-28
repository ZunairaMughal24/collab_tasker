import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_detail_controller.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/detail/workspace_task_list.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/detail/workspace_member_list.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/detail/workspace_dialog.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkspaceDetailScreen extends StatelessWidget {
  final Workspace workspace;
  const WorkspaceDetailScreen({super.key, required this.workspace});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      WorkspaceDetailController(workspace),
      tag: workspace.id,
    );

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              _buildHeader(context, controller),
              SizedBox(height: 20.h),
              _buildStatsCard(controller),
              SizedBox(height: 24.h),
              _buildViewToggle(controller),
              SizedBox(height: 24.h),
              _buildActionBar(controller, () {
                if (controller.selectedView.value == 0) {
                  _showAddTaskDialog(context, controller);
                } else {
                  _showAddMemberDialog(context, controller);
                }
              }),
              SizedBox(height: 16.h),
              Expanded(
                child: Obx(() {
                  if (controller.selectedView.value == 0) {
                    return WorkspaceTaskList(controller: controller);
                  } else {
                    return WorkspaceMemberList(controller: controller);
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WorkspaceDetailController controller,
  ) {
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
          child: Text(
            'Workspace Overview',
            style: AppTextStyle.displayMedium.copyWith(fontSize: 22.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (controller.isCreator)
          IconButton(
            onPressed: () => _showEditWorkspaceDialog(context, controller),
            icon: const Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
      ],
    );
  }

  Widget _buildStatsCard(WorkspaceDetailController controller) {
    return Obx(
      () => GlassContainer(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        padding: EdgeInsets.all(20.w),
        borderRadius: 24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.work_outline_rounded,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.workspace.value.name,
                        style: AppTextStyle.displayMedium.copyWith(
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '${controller.workspace.value.members.length} members • ${controller.tasks.length} tasks',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (controller.workspace.value.description.isNotEmpty) ...[
              SizedBox(height: 16.h),
              Text(
                'Description',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                controller.workspace.value.description,
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle(WorkspaceDetailController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
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

  Widget _buildActionBar(
    WorkspaceDetailController controller,
    VoidCallback onAdd,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.selectedView.value == 0
                  ? 'Recent Tasks'
                  : 'Team Members',
              style: AppTextStyle.displayMedium.copyWith(fontSize: 18.sp),
            ),
            TextButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 20),
              label: Text(
                controller.selectedView.value == 0 ? 'Add Task' : 'Invite',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog(
    BuildContext context,
    WorkspaceDetailController controller,
  ) {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => WorkspaceDialog(
        title: 'Create New Task',
        subtitle: 'Break down your goals into actionable items',
        action: AppButton(
          text: 'Create Task',
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              controller.addTask(
                context,
                titleController.text,
                descController.text,
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

  void _showAddMemberDialog(
    BuildContext context,
    WorkspaceDetailController controller,
  ) {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => WorkspaceDialog(
        title: 'Add Team Member',
        subtitle: 'Collaborate with others on this project',
        action: AppButton(
          text: 'Add Member',
          onPressed: () {
            if (emailController.text.isNotEmpty) {
              controller.addMember(context, emailController.text);
              Navigator.pop(context);
            }
          },
        ),
        children: [
          AppTextField(
            heading: 'Email Address',
            hintText: 'member@email.com',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.mail_outline_rounded,
          ),
        ],
      ),
    );
  }

  void _showEditWorkspaceDialog(
    BuildContext context,
    WorkspaceDetailController controller,
  ) {
    final nameController = TextEditingController(
      text: controller.workspace.value.name,
    );
    final descController = TextEditingController(
      text: controller.workspace.value.description,
    );

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => WorkspaceDialog(
        title: 'Edit Workspace',
        subtitle: 'Update your workspace details',
        action: Obx(
          () => AppButton(
            text: 'Save Changes',
            isLoading: controller.isLoadingInfo.value,
            onPressed: () async {
              await controller.updateWorkspaceInfo(
                nameController.text,
                descController.text,
              );
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ),
        children: [
          AppTextField(
            heading: 'Workspace Name',
            hintText: 'Enter name',
            controller: nameController,
            prefixIcon: Icons.work_outline_rounded,
          ),
          SizedBox(height: 16.h),
          AppTextField(
            heading: 'Description',
            hintText: 'Enter description',
            controller: descController,
            maxLines: 3,
            prefixIcon: Icons.description_outlined,
          ),
        ],
      ),
    );
  }
}
