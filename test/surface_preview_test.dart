import 'dart:io';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_card.dart';
import 'package:collab_tasker/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('surface preview', (tester) async {
    await tester.runAsync(() async {
      for (final pair in [
        ('Nunito', 'assets/fonts/Nunito-Variable.ttf'),
        ('MaterialIcons', _materialIconsPath()),
      ]) {
        final bytes = await File(pair.$2).readAsBytes();
        await (FontLoader(
          pair.$1,
        )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
      }
    });
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final workspace = Workspace(
      id: 'preview',
      name: 'Product launch',
      description:
          'Plan the next release with design, product and engineering.',
      createdBy: 'u',
      members: const ['a', 'b', 'c', 'd'],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      totalTasks: 12,
      completedTasks: 8,
      progress: 8 / 12,
    );

    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Nunito', useMaterial3: true),
          home: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'My workspaces',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      WorkspaceCard(workspace: workspace, onTap: () {}),
                      const SizedBox(height: 25),
                      const Text(
                        'Create workspace',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Column(
                        children: [
                          AppTextField(
                            heading: 'Workspace Name',
                            hintText: 'e.g. Project Phoenix',
                            prefixIcon: Icons.workspace_premium_outlined,
                          ),
                          SizedBox(height: 16),
                          AppTextField(
                            heading: 'Description',
                            hintText: 'What is this workspace about?',
                            maxLines: 3,
                            prefixIcon: Icons.description_outlined,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(() async {
      for (var index = 0; index < 4; index++) {
        await precacheImage(
          AssetImage('assets/images/avatar_$index.png'),
          tester.element(find.byType(MaterialApp)),
        );
      }
    });
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('surface_preview.png'),
    );
  });
}

String _materialIconsPath() {
  var directory = File(Platform.resolvedExecutable).parent;
  while (directory.parent.path != directory.path) {
    final iconFile = File(
      '${directory.path}/artifacts/material_fonts/materialicons-regular.otf',
    );
    if (iconFile.existsSync()) return iconFile.path;
    directory = directory.parent;
  }
  throw StateError('Flutter Material Icons font was not found');
}
