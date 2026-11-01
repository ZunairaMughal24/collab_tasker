import 'package:collab_tasker/features/workspace/presentation/widgets/demo_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('demo avatar keeps a square frame in the header', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: Center(child: DemoAvatar(index: 0, size: 38))),
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
    expect(tester.takeException(), isNull);
  });
}
