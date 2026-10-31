import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/core/theme/entry_palette.dart';
import 'package:collab_tasker/core/utils/validators.dart';
import 'package:collab_tasker/features/auth/presentation/controllers/login_controller.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());

    return AuthPageLayout(
      title: 'Welcome back',
      subtitle: 'Sign in to pick up where your team left off.',
      form: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthFormField(
            label: 'Email address',
            hint: 'you@example.com',
            controller: controller.emailController,
            validator: Validators.emailValidator,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            icon: Icons.mail_outline_rounded,
          ),
          const SizedBox(height: 20),
          Obx(
            () => AuthFormField(
              label: 'Password',
              hint: 'Enter your password',
              controller: controller.passwordController,
              validator: Validators.passwordValidator,
              isPasswordField: true,
              obscureText: !controller.isPasswordVisible.value,
              onVisibilityTap: controller.togglePasswordVisibility,
              textInputAction: TextInputAction.done,
              icon: Icons.lock_outline_rounded,
            ),
          ),
          const SizedBox(height: 28),
          Obx(
            () => AuthPrimaryButton(
              label: 'Sign in',
              onPressed: () => controller.login(context),
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
            "New to Collab Tasker?",
            style: TextStyle(color: EntryPalette.muted, fontSize: 14),
          ),
          TextButton(
            onPressed: () => context.push(AppRoutes.signUp),
            style: TextButton.styleFrom(foregroundColor: EntryPalette.accent),
            child: const Text(
              'Create account',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
