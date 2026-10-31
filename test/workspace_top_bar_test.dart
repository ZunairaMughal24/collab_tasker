import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('workspace toolbar keeps actions near the edges on a narrow phone',
      (tester) async {
    tester.view.physicalSize = const Size(320, 700);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    var backPressed = false;
    var editPressed = false;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        appBar: WorkspaceTopBar(
          title: 'Workspace Overview',
          leadingIcon: Icons.arrow_back_rounded,
          leadingTooltip: 'Back',
          onLeadingPressed: () => backPressed = true,
          actionIcon: Icons.edit_outlined,
          actionTooltip: 'Edit',
          onActionPressed: () => editPressed = true,
        ),
      ),
    ));

    final leading = find.byTooltip('Back');
    final action = find.byTooltip('Edit');
    expect(tester.getSize(leading), const Size(48, 48));
    expect(tester.getSize(action), const Size(48, 48));
    expect(tester.getCenter(leading).dx, lessThan(32));
    expect(tester.getCenter(action).dx, greaterThanOrEqualTo(288));
    expect(find.text('Workspace Overview'), findsOneWidget);
    final title = tester.widget<Text>(find.text('Workspace Overview'));
    expect(title.style?.fontSize, 20);
    expect(title.style?.fontWeight, FontWeight.w700);
    expect(tester.widget<Icon>(find.byIcon(Icons.arrow_back_rounded)).size, 24);

    await tester.tap(leading);
    await tester.tap(action);
    expect(backPressed, isTrue);
    expect(editPressed, isTrue);
  });
}
