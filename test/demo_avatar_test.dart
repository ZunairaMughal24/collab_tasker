import 'package:collab_tasker/features/workspace/presentation/widgets/home_profile_avatar.dart';
import 'package:collab_tasker/widgets/demo_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('demo avatar keeps a square frame in the header', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            toolbarHeight: 64,
            leadingWidth: 64,
            leading: HomeProfileAvatar(onTap: () => taps++),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => precacheImage(
        const AssetImage('assets/images/avatar_0.png'),
        tester.element(find.byType(MaterialApp)),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(DemoAvatar)), const Size(38, 38));
    expect(tester.getSize(find.byType(ClipOval)), const Size(34, 34));
    await tester.tap(find.byType(DemoAvatar));
    expect(taps, 1);
    expect(tester.takeException(), isNull);
  });
}
