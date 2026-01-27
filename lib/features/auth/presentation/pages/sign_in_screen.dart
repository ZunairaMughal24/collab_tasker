import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_styles.dart';
import 'package:collab_tasker/core/utils/padding_extension.dart';
import 'package:collab_tasker/core/utils/widget_extension.dart';
import 'package:collab_tasker/core/utils/validators.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/auth/presentation/controllers/login_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/widgets/app_button.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_header.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/social_auth_button.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return Scaffold(
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              60.heightBox,
              const AuthHeader(
                title: 'Welcome Back',
                subtitle: 'Sign in to continue your collaborative journey',
              ),
              40.heightBox,

              // Form inside Glass Container
              GlassContainer(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                borderRadius: 24,
                child: Column(
                  children: [
                    AppTextField(
                      heading: 'Email Address',
                      hintText: 'Enter your email',
                      controller: controller.emailController,
                      validator: Validators.emailValidator,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    24.heightBox,
                    Obx(
                      () => AppTextField(
                        heading: 'Password',
                        hintText: 'Enter your password',
                        controller: controller.passwordController,
                        validator: Validators.passwordValidator,
                        isPasswordField: true,
                        isObscure: !controller.isPasswordVisible.value,
                        onSuffixTap: controller.togglePasswordVisibility,
                      ),
                    ),

                    16.heightBox,
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(8),
                        child: Text(
                          'Forgot Password?',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ).p4(),
                      ),
                    ),

                    32.heightBox,
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

              32.heightBox,

              // Social Logins
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.glassBorder, thickness: 1),
                  ),
                  Text(
                    'Or continue with',
                    style: AppTextStyle.labelMedium,
                  ).px16(),
                  const Expanded(
                    child: Divider(color: AppColors.glassBorder, thickness: 1),
                  ),
                ],
              ),

              32.heightBox,
              Row(
                children: [
                  Expanded(
                    child: SocialAuthButton(
                      icon: 'assets/svg/google_logo.svg',
                      label: 'Google',
                      onTap: () {},
                    ),
                  ),
                  20.widthBox,
                  Expanded(
                    child: SocialAuthButton(
                      icon: 'assets/svg/apple_logo.svg',
                      label: 'Apple',
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  InkWell(
                    onTap: () => context.push(AppRoutes.signUp),
                    child: Text(
                      'Sign Up',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ).py8(),
                  ),
                ],
              ),
              20.heightBox,
            ],
          ).px(24.w),
        ).scrollVertical(),
      ),
    );
  }
}
