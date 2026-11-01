import 'dart:io';

import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_schedule_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('schedule preview shows the week and real task fields', (
    tester,
  ) async {
    await _loadFonts(tester);
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final previewDate = DateTime(2026, 11, 1);
    final workspace = Workspace(
      id: 'launch',
      name: 'Product launch',
      description: 'Release planning',
      createdBy: 'member',
      members: const ['a', 'b', 'c'],
      createdAt: previewDate,
    );
    final tasks = [
      WorkspaceTask(
        id: 'one',
        title: 'Review launch checklist',
        description: 'Finalize priorities with the team',
        assignedTo: 'member',
        workspaceId: workspace.id,
        dueDate: previewDate,
        createdAt: previewDate,
      ),
      WorkspaceTask(
        id: 'two',
        title: 'Share design feedback',
        description: 'Check the latest screens',
        status: TaskStatus.completed,
        assignedTo: 'member',
        workspaceId: workspace.id,
        dueDate: previewDate,
        createdAt: previewDate,
      ),
    ];

    var openCount = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(fontFamily: 'Nunito'),
          home: Scaffold(
            backgroundColor: const Color(0xFFF6F3ED),
            body: WorkspaceScheduleView(
              initialDate: previewDate,
              workspaces: [workspace],
              onCreateWorkspace: () {},
              onOpenWorkspace: (_) => openCount++,
              taskStreamForWorkspace: (_) => Stream.value(tasks),
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
    expect(find.text('Review launch checklist'), findsOneWidget);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('workspace_schedule_preview.png'),
    );
    await tester.tap(find.byTooltip('Next week'));
    await tester.pumpAndSettle();
    expect(find.text('8'), findsOneWidget);
    await tester.tap(find.byTooltip('Open workspace to add a task'));
    expect(openCount, 1);
  });

  testWidgets('schedule layout fits a narrow phone without workspaces', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var createTaps = 0;
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(393, 852),
        builder: (context, child) => MaterialApp(
          home: Scaffold(
            body: WorkspaceScheduleView(
              workspaces: const [],
              onCreateWorkspace: () => createTaps++,
              onOpenWorkspace: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Week of'), findsOneWidget);
    expect(find.text('Your schedule starts with a workspace'), findsOneWidget);
    await tester.tap(find.text('Create workspace'));
    expect(createTaps, 1);
  });
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
