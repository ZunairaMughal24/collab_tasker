import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/core/utils/validators.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/auth/presentation/controllers/register_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_header.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AuthBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                const AuthHeader(
                  title: 'Create Account',
                  subtitle: 'Join the team and start managing tasks together',
                ),
                SizedBox(height: 20.h),
                GlassContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 24.h,
                  ),
                  borderRadius: 24,
                  child: Column(
                    children: [
                      AppTextField(
                        heading: 'Full Name',
                        hintText: 'Enter your full name',
                        controller: controller.nameController,
                        validator: Validators.nameValidator,
                        prefixIcon: Icons.person_outline_rounded,
                      ),
                      SizedBox(height: 14.h),
                      AppTextField(
                        heading: 'Email Address',
                        hintText: 'Enter your email',
                        controller: controller.emailController,
                        validator: Validators.emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                      ),
                      SizedBox(height: 14.h),
                      Obx(
                        () => AppTextField(
                          heading: 'Password',
                          hintText: 'Create a password',
                          controller: controller.passwordController,
                          validator: Validators.passwordValidator,
                          isPasswordField: true,
                          isObscure: !controller.isPasswordVisible.value,
                          onSuffixTap: controller.togglePasswordVisibility,
                          prefixIcon: Icons.lock_outline_rounded,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      AppTextField(
                        heading: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        controller: controller.confirmPasswordController,
                        isPasswordField: true,
                        isObscure: true,
                        prefixIcon: Icons.lock_outline_rounded,
                      ),
                      SizedBox(height: 30.h),
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
                const Spacer(),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.signIn);
                        }
                      },
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
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
