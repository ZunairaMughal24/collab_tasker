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
  Future<String> createWorkspace(Workspace workspace);
  Stream<List<WorkspaceTask>> getTasks(String workspaceId);
  Future<String> addTask(String workspaceId, WorkspaceTask task);
  Future<void> updateTask(String workspaceId, WorkspaceTask task);
  Future<void> addMember(String workspaceId, String email);
}
