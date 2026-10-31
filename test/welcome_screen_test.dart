import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/features/splash/presentation/pages/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  for (final size in [const Size(393, 852), const Size(320, 640)]) {
    testWidgets('welcome fits ${size.width.toInt()}px phone', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final testRouter = GoRouter(
        initialLocation: AppRoutes.welcome,
        routes: [
          GoRoute(
            path: AppRoutes.welcome,
            builder: (context, state) => const WelcomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.signUp,
            builder: (context, state) => const Text('Sign up destination'),
          ),
          GoRoute(
            path: AppRoutes.signIn,
            builder: (context, state) => const Text('Sign in destination'),
          ),
        ],
      );
      addTearDown(testRouter.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: testRouter));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Plan the week'), findsOneWidget);
      expect(find.text('Get started'), findsOneWidget);

      await tester.ensureVisible(find.text('Get started'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Get started'));
      await tester.pumpAndSettle();
      expect(find.text('Sign up destination'), findsOneWidget);

      testRouter.go(AppRoutes.welcome);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('I already have an account'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('I already have an account'));
      await tester.pumpAndSettle();
      expect(find.text('Sign in destination'), findsOneWidget);
    });
  }
}
