import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/core/utils/validators.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/auth/presentation/controllers/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_header.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 60.h),

                const AuthHeader(
                  title: 'Welcome Back',
                  subtitle: 'Sign in to continue your collaborative journey',
                ),

                SizedBox(height: 32.h),

                GlassContainer(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 32.h,
                  ),
                  borderRadius: 24,
                  child: Column(
                    children: [
                      AppTextField(
                        heading: 'Email Address',
                        hintText: 'Enter your email',
                        controller: controller.emailController,
                        validator: Validators.emailValidator,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
                      ),

                      SizedBox(height: 20.h),

                      Obx(
                        () => AppTextField(
                          heading: 'Password',
                          hintText: 'Enter your password',
                          controller: controller.passwordController,
                          validator: Validators.passwordValidator,
                          isPasswordField: true,
                          isObscure: !controller.isPasswordVisible.value,
                          onSuffixTap: controller.togglePasswordVisibility,
                          prefixIcon: Icons.lock_outline_rounded,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password?',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 24.h),

                      Obx(
                        () => AppButton(
                          text: 'Sign In',
                          onPressed: () => controller.login(context),
                          isLoading: controller.isLoading.value,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 14.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.signUp),
                      child: Text(
                        'Sign Up',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
