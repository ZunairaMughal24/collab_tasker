import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/add_workspace_controller.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_top_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddWorkspaceScreen extends StatelessWidget {
  const AddWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddWorkspaceController());

    return Scaffold(
      appBar: WorkspaceTopBar(
        title: 'Create Workspace',
        subtitle: 'Bring your team together',
        leadingIcon: Icons.arrow_back_rounded,
        leadingTooltip: 'Back to workspaces',
        onLeadingPressed: () => context.pop(),
      ),
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextField(
                        heading: 'Workspace Name',
                        hintText: 'e.g. Project Phoenix',
                        controller: controller.nameController,
                        prefixIcon: Icons.workspace_premium_outlined,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        heading: 'Description',
                        hintText: 'What is this workspace about?',
                        controller: controller.descriptionController,
                        maxLines: 4,
                        prefixIcon: Icons.description_outlined,
                      ),

                      SizedBox(height: 20.h),
                      const Divider(color: AppColors.glassBorder),
                      SizedBox(height: 18.h),

                      _buildSectionHeader(
                        'Add First Task (Optional)',
                        Icons.task_alt_rounded,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        hintText: 'Task Title',
                        controller: controller.taskTitleController,
                        prefixIcon: Icons.edit_note_rounded,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        hintText: 'Task Description',
                        controller: controller.taskDescController,
                        maxLines: 2,
                        prefixIcon: Icons.notes_rounded,
                      ),

                      SizedBox(height: 16.h),
                      _buildSectionHeader(
                        'Invite Team Member (Optional)',
                        Icons.person_add_alt_1_rounded,
                      ),
                      SizedBox(height: 16.h),
                      AppTextField(
                        hintText: 'member@email.com',
                        controller: controller.memberEmailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                      ),

                      SizedBox(height: 30.h),
                      Obx(
                        () => AppButton(
                          text: 'Create Workspace',
                          onPressed: () => controller.createWorkspace(context),
                          isLoading: controller.isLoading.value,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            title,
            style: AppTextStyle.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }
}
