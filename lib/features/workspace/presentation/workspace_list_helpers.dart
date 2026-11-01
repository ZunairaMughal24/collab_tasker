import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';

enum WorkspaceFilter { all, notStarted, inProgress, completed }

bool workspaceMatchesQuery(Workspace workspace, String query) {
  final normalized = query.trim().toLowerCase();
  return normalized.isEmpty ||
      workspace.name.toLowerCase().contains(normalized) ||
      workspace.description.toLowerCase().contains(normalized);
}

bool workspaceMatchesFilter(Workspace workspace, WorkspaceFilter filter) {
  switch (filter) {
    case WorkspaceFilter.all:
      return true;
    case WorkspaceFilter.notStarted:
      return workspace.totalTasks == 0;
    case WorkspaceFilter.inProgress:
      return workspace.totalTasks > 0 &&
          workspace.completedTasks < workspace.totalTasks;
    case WorkspaceFilter.completed:
      return workspace.totalTasks > 0 &&
          workspace.completedTasks >= workspace.totalTasks;
  }
}

Workspace mostRecentlyActiveWorkspace(List<Workspace> workspaces) {
  return workspaces.reduce((latest, workspace) {
    final latestAt = latest.lastActivityAt ?? latest.createdAt;
    final workspaceAt = workspace.lastActivityAt ?? workspace.createdAt;
    return workspaceAt.isAfter(latestAt) ? workspace : latest;
  });
}
