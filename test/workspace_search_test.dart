import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/presentation/pages/workspace_list_screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final workspace = Workspace(
    id: '1',
    name: 'Product Launch',
    description: 'Design and engineering tasks',
    createdBy: 'member',
    members: const ['member'],
    createdAt: DateTime(2025),
  );

  test(
    'workspace search matches name and description without case sensitivity',
    () {
      expect(workspaceMatchesQuery(workspace, '  product  '), isTrue);
      expect(workspaceMatchesQuery(workspace, 'ENGINEERING'), isTrue);
      expect(workspaceMatchesQuery(workspace, 'marketing'), isFalse);
      expect(workspaceMatchesQuery(workspace, '   '), isTrue);
    },
  );
}
