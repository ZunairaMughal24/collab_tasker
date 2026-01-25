import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/features/splash/presentation/pages/splash_screen.dart';
import 'package:collab_tasker/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:collab_tasker/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:collab_tasker/features/workspace/presentation/pages/workspace_list_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String signIn = '/signin';
  static const String signUp = '/signup';
  static const String workspaceList = '/workspaces';
  static const String addWorkspace = '/add-workspace';
  static const String workspaceDetail = '/workspace-detail';
}

final router = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      path: AppRoutes.workspaceList,
      builder: (context, state) => const WorkspaceListScreen(),
    ),
  ],
);
