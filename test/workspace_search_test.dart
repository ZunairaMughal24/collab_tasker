import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/presentation/workspace_list_helpers.dart';
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

  test('workspace status filters use real task counts', () {
    final active = workspace.copyWith(totalTasks: 4, completedTasks: 1);
    final completed = workspace.copyWith(totalTasks: 4, completedTasks: 4);
    expect(workspaceMatchesFilter(workspace, WorkspaceFilter.all), isTrue);
    expect(
      workspaceMatchesFilter(workspace, WorkspaceFilter.notStarted),
      isTrue,
    );
    expect(workspaceMatchesFilter(active, WorkspaceFilter.notStarted), isFalse);
    expect(
      workspaceMatchesFilter(workspace, WorkspaceFilter.inProgress),
      isFalse,
    );
    expect(workspaceMatchesFilter(active, WorkspaceFilter.inProgress), isTrue);
    expect(workspaceMatchesFilter(active, WorkspaceFilter.completed), isFalse);
    expect(
      workspaceMatchesFilter(completed, WorkspaceFilter.completed),
      isTrue,
    );
  });

  test('featured workspace is the most recently active', () {
    final older = workspace.copyWith(
      id: 'older',
      createdAt: DateTime(2025, 1, 1),
      lastActivityAt: DateTime(2025, 2, 1),
    );
    final newer = workspace.copyWith(
      id: 'newer',
      createdAt: DateTime(2025, 1, 2),
      lastActivityAt: DateTime(2025, 2, 2),
    );
    expect(mostRecentlyActiveWorkspace([older, newer]).id, 'newer');
    expect(mostRecentlyActiveWorkspace([newer, older]).id, 'newer');
  });
}
