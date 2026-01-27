import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:collab_tasker/core/utils/padding_extension.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              20.heightBox,

              Text(
                'Create Workspace',
                style: AppTextStyle.displayMedium.copyWith(fontSize: 28.sp),
              ).px(24.w),
              8.heightBox,
              Text(
                'Bring your team together and master your goals',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ).px(24.w),

              40.heightBox,
              GlassContainer(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                borderRadius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workspace Name',
                      style: AppTextStyle.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    12.heightBox,
                    AppTextField(
                      hintText: 'e.g. Project Phoenix',
                      controller: controller.nameController,
                    ),
                    24.heightBox,
                    Text(
                      'Description',
                      style: AppTextStyle.labelLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    12.heightBox,
                    AppTextField(
                      hintText: 'What is this workspace about?',
                      controller: controller.descriptionController,
                      maxLines: 4,
                    ),
                    40.heightBox,
                    Obx(
                      () => AppButton(
                        text: 'Save & Invite',
                        onPressed: () => controller.createWorkspace(context),
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                    16.heightBox,
                    Center(
                      child: TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'Add members later',
                          style: AppTextStyle.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ).px(24.w),
            ],
          ).scrollVertical(),
        ),
      ),
    );
  }
}
