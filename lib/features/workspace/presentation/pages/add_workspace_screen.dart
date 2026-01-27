import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/add_workspace_controller.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddWorkspaceScreen extends StatelessWidget {
  const AddWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddWorkspaceController());

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Create Workspace',
                    style: AppTextStyle.displayMedium.copyWith(fontSize: 28.sp),
                  ),
                ),
                SizedBox(height: 8.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Text(
                    'Bring your team together and master your goals',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: GlassContainer(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 32.h,
                    ),
                    borderRadius: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          heading: 'Workspace Name',
                          hintText: 'e.g. Project Phoenix',
                          controller: controller.nameController,
                          prefixIcon: Icons.workspace_premium_outlined,
                        ),
                        SizedBox(height: 24.h),
                        AppTextField(
                          heading: 'Description',
                          hintText: 'What is this workspace about?',
                          controller: controller.descriptionController,
                          maxLines: 4,
                        ),
                        SizedBox(height: 40.h),
                        Obx(
                          () => AppButton(
                            text: 'Save Workspace',
                            onPressed: () =>
                                controller.createWorkspace(context),
                            isLoading: controller.isLoading.value,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
