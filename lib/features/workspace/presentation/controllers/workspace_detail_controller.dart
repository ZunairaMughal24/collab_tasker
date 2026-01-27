import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/features/workspace/domain/repositories/workspace_repository.dart';
import 'package:collab_tasker/features/workspace/data/repositories/workspace_repository_impl.dart';

class WorkspaceDetailController extends GetxController {
  final WorkspaceRepository _repository = WorkspaceRepositoryImpl();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final Workspace workspace;
  WorkspaceDetailController(this.workspace);

  final tasks = <WorkspaceTask>[].obs;
  final isLoadingTasks = false.obs;
  final selectedView = 0.obs; // 0 for Tasks, 1 for Members

  User? get currentUser => _firebaseAuth.currentUser;

  @override
  void onInit() {
    super.onInit();
    _bindTasks();
  }

  void _bindTasks() {
    tasks.bindStream(_repository.getTasks(workspace.id));
  }

  Future<void> addTask(String title, String description) async {
    final user = currentUser;
    if (user == null) return;

    final task = WorkspaceTask(
      id: '',
      title: title,
      description: description,
      assignedTo: user.uid,
      workspaceId: workspace.id,
      createdAt: DateTime.now(),
    );

    await _repository.addTask(workspace.id, task);
  }

  Future<void> updateTaskStatus(WorkspaceTask task, TaskStatus status) async {
    final updatedTask = task.copyWith(status: status);
    await _repository.updateTask(workspace.id, updatedTask);
  }

  void switchView(int index) {
    selectedView.value = index;
  }
}
