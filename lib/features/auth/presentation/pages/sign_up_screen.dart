import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/core/theme/entry_palette.dart';
import 'package:collab_tasker/core/utils/validators.dart';
import 'package:collab_tasker/features/auth/presentation/controllers/register_controller.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());

    return AuthPageLayout(
      title: 'Create account',
      subtitle: 'One place to keep your team and tasks in sync.',
      compactHero: true,
      sectionLabel: 'YOUR DETAILS',
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthFormField(
            label: 'Full name',
            hint: 'Your name',
            controller: controller.nameController,
            validator: Validators.nameValidator,
            textInputAction: TextInputAction.next,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 18),
          AuthFormField(
            label: 'Email address',
            hint: 'you@example.com',
            controller: controller.emailController,
            validator: Validators.emailValidator,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 18),
          Obx(
            () => AuthFormField(
              label: 'Password',
              hint: 'At least 6 characters',
              controller: controller.passwordController,
              validator: Validators.passwordValidator,
              isPasswordField: true,
              obscureText: !controller.isPasswordVisible.value,
              onVisibilityTap: controller.togglePasswordVisibility,
              textInputAction: TextInputAction.next,
              icon: Icons.lock_outline_rounded,
            ),
          ),
          const SizedBox(height: 18),
          AuthFormField(
            label: 'Confirm password',
            hint: 'Re-enter your password',
            controller: controller.confirmPasswordController,
            isPasswordField: true,
            obscureText: true,
            textInputAction: TextInputAction.done,
            icon: Icons.lock_outline_rounded,
          ),
          const SizedBox(height: 28),
          Obx(
            () => AuthPrimaryButton(
              label: 'Create account',
              onPressed: () => controller.register(context),
              isLoading: controller.isLoading.value,
            ),
          ),
        ],
      ),
      footer: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          const Text(
            'Already have an account?',
            style: TextStyle(color: EntryPalette.muted, fontSize: 14),
          ),
          TextButton(
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.signIn);
              }
            },
            style: TextButton.styleFrom(foregroundColor: EntryPalette.accent),
            child: const Text(
              'Sign in',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
