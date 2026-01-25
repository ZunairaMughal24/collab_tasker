import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:collab_tasker/core/utils/padding_extension.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';
import 'package:collab_tasker/core/utils/validators.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/auth/presentation/controllers/register_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_header.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.heightBox,
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              ),
              20.heightBox,

              const AuthHeader(
                title: 'Create Account',
                subtitle: 'Join the team and start managing tasks',
              ),
              40.heightBox,

              // Form inside Glass Container
              GlassContainer(
                padding: EdgeInsets.all(28.w),
                borderRadius: 24,
                child: Column(
                  children: [
                    AppTextField(
                      heading: 'Full Name',
                      hintText: 'John Doe',
                      controller: controller.nameController,
                      validator: Validators.nameValidator,
                    ),
                    20.heightBox,
                    AppTextField(
                      heading: 'Email Address',
                      hintText: 'name@example.com',
                      controller: controller.emailController,
                      validator: Validators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    20.heightBox,
                    Obx(
                      () => AppTextField(
                        heading: 'Password',
                        hintText: '••••••••',
                        controller: controller.passwordController,
                        validator: Validators.passwordValidator,
                        isPasswordField: !controller.isPasswordVisible.value,
                        onSuffixTap: controller.togglePasswordVisibility,
                      ),
                    ),
                    20.heightBox,
                    AppTextField(
                      heading: 'Confirm Password',
                      hintText: '••••••••',
                      controller: controller.confirmPasswordController,
                      isPasswordField: true,
                    ),

                    40.heightBox,
                    Obx(
                      () => AppButton(
                        text: 'Create Account',
                        onPressed: () => controller.register(context),
                        isLoading: controller.isLoading.value,
                      ),
                    ),
                  ],
                ),
              ),

              40.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Sign In',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              40.heightBox,
            ],
          ).px(24.w).scrollVertical(),
        ),
      ),
    );
  }
}
