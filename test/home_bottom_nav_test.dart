import 'dart:io';

import 'package:collab_tasker/features/workspace/presentation/widgets/home_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

void main() {
  testWidgets('floating navigation fits a narrow phone and invokes actions', (
    tester,
  ) async {
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
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var homeTaps = 0;
    var spaceTaps = 0;
    var scheduleTaps = 0;
    var profileTaps = 0;

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Nunito'),
        home: Scaffold(
          bottomNavigationBar: HomeBottomNav(
            selectedIndex: 0,
            onHome: () => homeTaps++,
            onWorkspaces: () => spaceTaps++,
            onSchedule: () => scheduleTaps++,
            onProfile: () => profileTaps++,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('home_bottom_nav.png'),
    );

    await tester.tap(find.byType(GButton).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(GButton).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(GButton).at(3));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(GButton).at(0));
    await tester.pumpAndSettle();

    expect([homeTaps, spaceTaps, scheduleTaps, profileTaps], [1, 1, 1, 1]);
    expect(tester.takeException(), isNull);
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
