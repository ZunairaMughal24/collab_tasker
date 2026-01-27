import 'package:go_router/go_router.dart';
import 'package:collab_tasker/features/splash/presentation/pages/splash_screen.dart';
import 'package:collab_tasker/features/auth/presentation/pages/sign_in_screen.dart';
import 'package:collab_tasker/features/auth/presentation/pages/sign_up_screen.dart';
import 'package:collab_tasker/features/workspace/presentation/pages/workspace_list_screen.dart';
import 'package:collab_tasker/features/workspace/presentation/pages/add_workspace_screen.dart';
import 'package:collab_tasker/features/workspace/presentation/pages/workspace_detail_screen.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';

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
      name: 'splash',
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: 'sign_in',
      path: AppRoutes.signIn,
      builder: (context, state) => const SignInScreen(),
    ),
    GoRoute(
      name: 'sign_up',
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: 'workspace_list',
      path: AppRoutes.workspaceList,
      builder: (context, state) => const WorkspaceListScreen(),
    ),
    GoRoute(
      name: 'add_workspace',
      path: AppRoutes.addWorkspace,
      builder: (context, state) => const AddWorkspaceScreen(),
    ),
    GoRoute(
      name: 'workspace_detail',
      path: AppRoutes.workspaceDetail,
      builder: (context, state) {
        if (state.extra == null) {
          return const WorkspaceListScreen();
        }
        final workspace = state.extra as Workspace;
        return WorkspaceDetailScreen(workspace: workspace);
      },
    ),
  ],
);
