import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/workspace/data/repositories/workspace_repository_impl.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace_task.dart';
import 'package:collab_tasker/widgets/demo_avatar.dart';
import 'package:flutter/material.dart';

class WorkspaceScheduleView extends StatefulWidget {
  const WorkspaceScheduleView({
    super.key,
    required this.workspaces,
    required this.onCreateWorkspace,
    required this.onOpenWorkspace,
    this.taskStreamForWorkspace,
    this.initialDate,
  });

  final List<Workspace> workspaces;
  final VoidCallback onCreateWorkspace;
  final ValueChanged<Workspace> onOpenWorkspace;
  final Stream<List<WorkspaceTask>> Function(String workspaceId)?
  taskStreamForWorkspace;
  final DateTime? initialDate;

  @override
  State<WorkspaceScheduleView> createState() => _WorkspaceScheduleViewState();
}

class _WorkspaceScheduleViewState extends State<WorkspaceScheduleView> {
  WorkspaceRepositoryImpl? _repository;
  late DateTime _selectedDate;
  String? _selectedWorkspaceId;
  String? _streamWorkspaceId;
  Stream<List<WorkspaceTask>>? _taskStream;
  int _filter = 0;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateUtils.dateOnly(widget.initialDate ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final workspaces = widget.workspaces;
    final selectedWorkspace = workspaces.isEmpty
        ? null
        : workspaces.firstWhere(
            (workspace) => workspace.id == _selectedWorkspaceId,
            orElse: () => workspaces.first,
          );
    if (selectedWorkspace != null &&
        _streamWorkspaceId != selectedWorkspace.id) {
      _streamWorkspaceId = selectedWorkspace.id;
      _taskStream =
          widget.taskStreamForWorkspace?.call(selectedWorkspace.id) ??
          (_repository ??= WorkspaceRepositoryImpl()).getTasks(
            selectedWorkspace.id,
          );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 120),
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Task schedule',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            IconButton.filledTonal(
              tooltip: selectedWorkspace == null
                  ? 'Create workspace'
                  : 'Open workspace to add a task',
              onPressed: selectedWorkspace == null
                  ? widget.onCreateWorkspace
                  : () => widget.onOpenWorkspace(selectedWorkspace),
              icon: const Icon(Icons.add_rounded, size: 21),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.glassBase,
                foregroundColor: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _WeekPicker(
          selectedDate: _selectedDate,
          onSelected: (date) => setState(() => _selectedDate = date),
        ),
        const SizedBox(height: 18),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _ScheduleChip(
                label: 'All',
                selected: _filter == 0,
                onTap: () => setState(() => _filter = 0),
              ),
              const SizedBox(width: 8),
              _ScheduleChip(
                label: 'Active',
                selected: _filter == 1,
                onTap: () => setState(() => _filter = 1),
              ),
              const SizedBox(width: 8),
              _ScheduleChip(
                label: 'Completed',
                selected: _filter == 2,
                onTap: () => setState(() => _filter = 2),
              ),
            ],
          ),
        ),
        const SizedBox(height: 23),
        if (selectedWorkspace == null)
          _ScheduleEmpty(
            title: 'Your schedule starts with a workspace',
            detail: 'Create a workspace, then add tasks with due dates.',
            onAction: widget.onCreateWorkspace,
          )
        else ...[
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedWorkspace.id,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              style: AppTextStyle.cardSubtitle.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              items: [
                for (final workspace in workspaces)
                  DropdownMenuItem(
                    value: workspace.id,
                    child: Text(
                      workspace.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (id) => setState(() => _selectedWorkspaceId = id),
            ),
          ),
          const SizedBox(height: 8),
          StreamBuilder<List<WorkspaceTask>>(
            stream: _taskStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const _ScheduleEmpty(
                  title: 'Could not load tasks',
                  detail: 'Check your connection and try again.',
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final tasks = snapshot.data!.where((task) {
                if (_filter == 1 && task.status == TaskStatus.completed) {
                  return false;
                }
                if (_filter == 2 && task.status != TaskStatus.completed) {
                  return false;
                }
                return true;
              }).toList();
              final dated = tasks
                  .where(
                    (task) =>
                        task.dueDate != null &&
                        DateUtils.isSameDay(task.dueDate, _selectedDate),
                  )
                  .toList();
              final undated = tasks
                  .where((task) => task.dueDate == null)
                  .toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (dated.isEmpty)
                    const _ScheduleEmpty(
                      title: 'Nothing due on this day',
                      detail: 'Choose another date to see planned tasks.',
                    )
                  else
                    for (final task in dated)
                      _ScheduleTaskCard(
                        task: task,
                        workspace: selectedWorkspace,
                        onTap: () => widget.onOpenWorkspace(selectedWorkspace),
                      ),
                  if (undated.isNotEmpty) ...[
                    const SizedBox(height: 23),
                    const Text(
                      'No due date',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (final task in undated.take(5))
                      _ScheduleTaskCard(
                        task: task,
                        workspace: selectedWorkspace,
                        onTap: () => widget.onOpenWorkspace(selectedWorkspace),
                      ),
                  ],
                ],
              );
            },
          ),
        ],
      ],
    );
  }
}

class _WeekPicker extends StatelessWidget {
  const _WeekPicker({required this.selectedDate, required this.onSelected});

  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelected;

  @override
  Widget build(BuildContext context) {
    final monday = selectedDate.subtract(
      Duration(days: selectedDate.weekday - 1),
    );
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 13),
      decoration: BoxDecoration(
        color: AppColors.glassBase,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Week of ${MaterialLocalizations.of(context).formatShortDate(monday)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.cardSubtitle.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Previous week',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 30,
                  height: 32,
                ),
                onPressed: () =>
                    onSelected(selectedDate.subtract(const Duration(days: 7))),
                icon: const Icon(Icons.chevron_left_rounded, size: 20),
              ),
              IconButton(
                tooltip: 'Next week',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 30,
                  height: 32,
                ),
                onPressed: () =>
                    onSelected(selectedDate.add(const Duration(days: 7))),
                icon: const Icon(Icons.chevron_right_rounded, size: 20),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(42, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                ),
                onPressed: () => onSelected(DateUtils.dateOnly(DateTime.now())),
                child: const Text(
                  'Today',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              for (var index = 0; index < 7; index++)
                Expanded(
                  child: _DayCell(
                    label: days[index],
                    date: monday.add(Duration(days: index)),
                    selected: DateUtils.isSameDay(
                      monday.add(Duration(days: index)),
                      selectedDate,
                    ),
                    onTap: () => onSelected(monday.add(Duration(days: index))),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.label,
    required this.date,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyle.cardMeta.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 9),
          Container(
            width: 35,
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${date.day}',
              style: AppTextStyle.cardMeta.copyWith(
                color: selected ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleChip extends StatelessWidget {
  const _ScheduleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.glassBase,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyle.chipLabel.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _ScheduleTaskCard extends StatelessWidget {
  const _ScheduleTaskCard({
    required this.task,
    required this.workspace,
    required this.onTap,
  });

  final WorkspaceTask task;
  final Workspace workspace;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final completed = task.status == TaskStatus.completed;
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Material(
        color: AppColors.glassBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.14,
                      ),
                      child: const Icon(
                        Icons.grid_view_rounded,
                        size: 13,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        workspace.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.cardMeta.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: completed
                            ? const Color(0xFFE1EFE4)
                            : const Color(0xFFF8EAE0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        completed
                            ? 'Completed'
                            : task.status == TaskStatus.inProgress
                            ? 'In progress'
                            : 'Pending',
                        style: AppTextStyle.cardMeta.copyWith(
                          color: completed
                              ? AppColors.success
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        task.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.cardTitle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    DemoAvatar(
                      index:
                          task.assignedTo.codeUnits.fold<int>(
                            0,
                            (sum, code) => sum + code,
                          ) %
                          4,
                      size: 30,
                    ),
                  ],
                ),
                if (task.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.cardSubtitle,
                  ),
                ],
                const SizedBox(height: 13),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 13,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      task.dueDate == null
                          ? 'No due date'
                          : MaterialLocalizations.of(
                              context,
                            ).formatShortDate(task.dueDate!),
                      style: AppTextStyle.cardMeta.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScheduleEmpty extends StatelessWidget {
  const _ScheduleEmpty({
    required this.title,
    required this.detail,
    this.onAction,
  });
  final String title;
  final String detail;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFF3EAE1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.event_note_rounded,
            size: 25,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyle.cardTitle),
          const SizedBox(height: 4),
          Text(detail, style: AppTextStyle.cardSubtitle),
          if (onAction != null) ...[
            const SizedBox(height: 14),
            FilledButton(
              onPressed: onAction,
              child: const Text('Create workspace'),
            ),
          ],
        ],
      ),
    );
  }
}
