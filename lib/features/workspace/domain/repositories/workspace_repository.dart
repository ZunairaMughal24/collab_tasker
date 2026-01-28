import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';

class PaginatedResult<T> {
  final List<T> items;
  final dynamic lastDoc;

  PaginatedResult(this.items, this.lastDoc);
}

abstract class WorkspaceRepository {
  Future<PaginatedResult<Workspace>> getWorkspaces(
    String userId, {
    int limit = 10,
    dynamic lastDoc,
  });
  Stream<List<Workspace>> watchWorkspaces(String userId);
  Stream<Workspace> watchWorkspace(String workspaceId);
  Future<String> createWorkspace(Workspace workspace);
  Stream<List<WorkspaceTask>> getTasks(String workspaceId);
  Future<String> addTask(String workspaceId, WorkspaceTask task);
  Future<void> updateTask(String workspaceId, WorkspaceTask task);
  Future<void> addMember(String workspaceId, String email);
  Future<void> cancelInvite(String workspaceId, String email);
  Future<void> deleteWorkspace(String workspaceId);
  Future<void> updateWorkspace(Workspace workspace);
  Future<void> removeMember(String workspaceId, String userId);
  Future<void> deleteTask(String workspaceId, String taskId);
}
