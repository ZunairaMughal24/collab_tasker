import 'dart:io';

import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_home_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final size in [const Size(393, 852), const Size(320, 640)]) {
    testWidgets('home feature banner fits ${size.width.toInt()}px', (
      tester,
    ) async {
      await _loadFonts(tester);
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final workspace = Workspace(
        id: 'launch',
        name: 'Product launch planning',
        description: 'Team release planning',
        createdBy: 'member',
        members: const ['a', 'b', 'c'],
        createdAt: DateTime.now(),
        totalTasks: 12,
        completedTasks: 8,
        progress: 8 / 12,
      );
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(393, 852),
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Nunito'),
            home: Scaffold(
              backgroundColor: const Color(0xFFF6F3ED),
              body: SafeArea(
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    FeaturedWorkspaceCard(workspace: workspace, onTap: () {}),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Open workspace'), findsOneWidget);
      if (size.width == 393) {
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile('home_banner.png'),
        );
      }
    });
  }
}

Future<void> _loadFonts(WidgetTester tester) async {
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
