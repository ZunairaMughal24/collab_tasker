import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_list_controller.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_card.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:collab_tasker/core/utils/app_snackbar.dart';

bool workspaceMatchesQuery(Workspace workspace, String query) {
  final normalized = query.trim().toLowerCase();
  return normalized.isEmpty ||
      workspace.name.toLowerCase().contains(normalized) ||
      workspace.description.toLowerCase().contains(normalized);
}

enum WorkspaceFilter { all, inProgress, completed }

bool workspaceMatchesFilter(Workspace workspace, WorkspaceFilter filter) {
  switch (filter) {
    case WorkspaceFilter.all:
      return true;
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

class WorkspaceListScreen extends StatefulWidget {
  const WorkspaceListScreen({super.key});

  @override
  State<WorkspaceListScreen> createState() => _WorkspaceListScreenState();
}

class _WorkspaceListScreenState extends State<WorkspaceListScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _searchController = TextEditingController();
  late final WorkspaceListController controller;
  String _query = '';
  WorkspaceFilter _filter = WorkspaceFilter.all;

  @override
  void initState() {
    super.initState();
    controller = Get.put(WorkspaceListController());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      appBar: AppBar(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 64,
        leadingWidth: 56,
        titleSpacing: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.secondary,
          statusBarIconBrightness: Brightness.light,
          systemStatusBarContrastEnforced: false,
          systemNavigationBarColor: AppColors.background,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarContrastEnforced: false,
        ),
        leading: IconButton(
          tooltip: 'Open menu',
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          icon: const Icon(Icons.menu_rounded, size: 24),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hello, ${user?.displayName?.split(' ').first ?? 'Member'}!',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Text(
              'Your work, in one place',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 12,
                color: Color(0xFFD1DDD3),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.only(right: 8),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () =>
                AppSnackbar.showSuccess('Notifications coming soon'),
            icon: const Icon(Icons.notifications_none_rounded, size: 24),
          ),
        ],
      ),
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.secondary, Color(0xFF385447)],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(24),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _query = value),
                  style: AppTextStyle.bodyMedium.copyWith(fontSize: 15.sp),
                  cursorColor: AppColors.primary,
                  decoration: InputDecoration(
                    hintText: 'Search workspaces',
                    hintStyle: AppTextStyle.bodyMedium.copyWith(
                      color: AppColors.hintText,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                      size: 20.w,
                    ),
                    suffixIcon: _query.trim().isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _query = '');
                            },
                            icon: const Icon(Icons.close_rounded, size: 19),
                          ),
                    filled: true,
                    fillColor: AppColors.glassBase,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.glassBase),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.glassBase),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.4,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 22.h),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final visibleWorkspaces = controller.workspaces
                      .where(
                        (workspace) =>
                            workspaceMatchesQuery(workspace, _query) &&
                            workspaceMatchesFilter(workspace, _filter),
                      )
                      .toList();

                  if (controller.workspaces.isEmpty) {
                    return _WorkspaceEmptyState(
                      onCreate: () => context.push(AppRoutes.addWorkspace),
                    );
                  }

                  final recentWorkspace = mostRecentlyActiveWorkspace(
                    controller.workspaces,
                  );

                  return ListView.builder(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
                    itemCount: visibleWorkspaces.isEmpty
                        ? 2
                        : visibleWorkspaces.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _WorkspaceOverview(
                              workspaces: controller.workspaces,
                            ),
                            if (_query.trim().isEmpty &&
                                _filter == WorkspaceFilter.all) ...[
                              SizedBox(height: 24.h),
                              _FeaturedWorkspaceCard(
                                workspace: recentWorkspace,
                                onTap: () => context.push(
                                  AppRoutes.workspaceDetail,
                                  extra: recentWorkspace,
                                ),
                              ),
                            ],
                            SizedBox(height: 30.h),
                            Row(
                              children: [
                                Text(
                                  'Workspaces',
                                  style: AppTextStyle.displayMedium.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 21.sp,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${visibleWorkspaces.length} total',
                                  style: AppTextStyle.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: WorkspaceFilter.values.map((filter) {
                                  final selected = _filter == filter;
                                  final label = switch (filter) {
                                    WorkspaceFilter.all => 'All',
                                    WorkspaceFilter.inProgress => 'In progress',
                                    WorkspaceFilter.completed => 'Done',
                                  };
                                  return Padding(
                                    padding: EdgeInsets.only(right: 23.w),
                                    child: InkWell(
                                      onTap: () =>
                                          setState(() => _filter = filter),
                                      child: Column(
                                        children: [
                                          Text(
                                            label,
                                            style: TextStyle(
                                              fontFamily: 'Nunito',
                                              fontSize: 13.sp,
                                              fontWeight: selected
                                                  ? FontWeight.w800
                                                  : FontWeight.w600,
                                              color: selected
                                                  ? AppColors.textPrimary
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                          SizedBox(height: 9.h),
                                          Container(
                                            height: 2.h,
                                            width: 20.w,
                                            color: selected
                                                ? AppColors.primary
                                                : Colors.transparent,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(height: 12.h),
                          ],
                        );
                      }
                      if (visibleWorkspaces.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 36.h),
                          child: Center(
                            child: Text(
                              _query.trim().isNotEmpty
                                  ? 'No workspaces match your search'
                                  : 'No workspaces in this view',
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      }
                      final workspace = visibleWorkspaces[index - 1];
                      return WorkspaceCard(
                        workspace: workspace,
                        onTap: () => context.push(
                          AppRoutes.workspaceDetail,
                          extra: workspace,
                        ),
                        onLongPress: () => _showWorkspaceManagementMenu(
                          context,
                          controller,
                          workspace,
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(
        () => controller.workspaces.isEmpty
            ? const SizedBox.shrink()
            : FloatingActionButton.extended(
                onPressed: () => context.push(AppRoutes.addWorkspace),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                icon: const Icon(Icons.add_rounded, size: 22),
                label: const Text(
                  'New workspace',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20.h,
              bottom: 30.h,
              left: 24.w,
              right: 24.w,
            ),
            color: AppColors.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 35.r,
                    backgroundColor: AppColors.glassBase,
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 40.w,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  user?.displayName ?? 'Collab Member',
                  style: AppTextStyle.displayMedium.copyWith(fontSize: 20.sp),
                ),
                Text(
                  user?.email ?? 'member@collabtasker.com',
                  style: AppTextStyle.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          _buildDrawerItem(
            icon: Icons.dashboard_outlined,
            label: 'My Workspaces',
            onTap: () => Navigator.pop(context),
            isSelected: true,
          ),
          _buildDrawerItem(
            icon: Icons.person_outline_rounded,
            label: 'My Profile',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.task_alt_rounded,
            label: 'Task Analytics',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () {},
          ),
          const Divider(
            color: AppColors.glassBorder,
            indent: 24,
            endIndent: 24,
            height: 40,
          ),
          _buildDrawerItem(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.privacy_tip_outlined,
            label: 'Privacy Policy',
            onTap: () {},
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.error),
              title: Text(
                'Logout',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              tileColor: AppColors.error.withValues(alpha: 0.05),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  context.go(AppRoutes.signIn);
                }
              },
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: isSelected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          label,
          style: AppTextStyle.bodyMedium.copyWith(
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
      ),
    );
  }

  void _showWorkspaceManagementMenu(
    BuildContext context,
    WorkspaceListController controller,
    Workspace workspace,
  ) {
    final user = FirebaseAuth.instance.currentUser;
    final isCreator = workspace.createdBy == user?.uid;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: AppColors.glassBase,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: AppColors.glassBorder),
          boxShadow: const [
            BoxShadow(
              color: AppColors.surfaceShadow,
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.glassBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 24.h),
            if (isCreator) ...[
              SizedBox(height: 12.h),
              _buildMenuOption(
                icon: Icons.delete_outline_rounded,
                title: 'Delete Workspace',
                isDanger: true,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, controller, workspace);
                },
              ),
            ],
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icon,
        color: isDanger ? AppColors.error : AppColors.textPrimary,
      ),
      title: Text(
        title,
        style: AppTextStyle.bodyLarge.copyWith(
          color: isDanger ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.glassBorder),
      ),
      tileColor: AppColors.background,
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WorkspaceListController controller,
    Workspace workspace,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.glassBase,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
        title: Text('Delete Workspace', style: AppTextStyle.displayMedium),
        content: Text(
          'Are you sure you want to delete "${workspace.name}"? This action cannot be undone and all tasks will be removed.',
          style: AppTextStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteWorkspace(workspace.id);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceOverview extends StatelessWidget {
  const _WorkspaceOverview({required this.workspaces});

  final List<Workspace> workspaces;

  @override
  Widget build(BuildContext context) {
    final totalTasks = workspaces.fold<int>(
      0,
      (total, workspace) => total + workspace.totalTasks,
    );
    final completedTasks = workspaces.fold<int>(
      0,
      (total, workspace) => total + workspace.completedTasks,
    );
    final openTasks = (totalTasks - completedTasks).clamp(0, totalTasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: AppTextStyle.displayMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 21.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 17.h),
        Row(
          children: [
            _OverviewMetric(label: 'Spaces', value: workspaces.length),
            _OverviewDivider(),
            _OverviewMetric(label: 'To do', value: openTasks),
            _OverviewDivider(),
            _OverviewMetric(label: 'Done', value: completedTasks),
          ],
        ),
        SizedBox(height: 22.h),
        Container(height: 1, color: AppColors.glassBorder),
      ],
    );
  }
}

class _FeaturedWorkspaceCard extends StatelessWidget {
  const _FeaturedWorkspaceCard({required this.workspace, required this.onTap});

  final Workspace workspace;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final remaining = (workspace.totalTasks - workspace.completedTasks).clamp(
      0,
      workspace.totalTasks,
    );
    final detail = workspace.totalTasks == 0
        ? 'Ready for your first task'
        : remaining == 0
        ? 'All tasks completed'
        : '$remaining ${remaining == 1 ? 'task' : 'tasks'} left to finish';
    final progress = workspace.progress.clamp(0.0, 1.0);
    final activityAt = workspace.lastActivityAt ?? workspace.createdAt;
    final today = DateUtils.dateOnly(DateTime.now());
    final activityDay = DateUtils.dateOnly(activityAt);
    final activityLabel = activityDay == today
        ? 'Today'
        : activityDay == today.subtract(const Duration(days: 1))
        ? 'Yesterday'
        : MaterialLocalizations.of(context).formatShortDate(activityAt);

    return Material(
      color: const Color(0xFFE8EEE7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFD7E2D7)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(18.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'CONTINUE',
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: AppColors.primary,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    activityLabel,
                    style: TextStyle(
                      fontFamily: 'Nunito',
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workspace.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: AppColors.textPrimary,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          detail,
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 21,
                    color: AppColors.primary,
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4.h,
                  backgroundColor: const Color(0xFFCCD9CC),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkspaceEmptyState extends StatelessWidget {
  const _WorkspaceEmptyState({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 40.h),
      children: [
        Text(
          'YOUR WORKSPACES',
          style: TextStyle(
            fontFamily: 'Nunito',
            color: AppColors.primary,
            fontSize: 11.sp,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.3,
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'No workspaces yet',
          style: AppTextStyle.displayMedium.copyWith(
            color: AppColors.textPrimary,
            fontSize: 27.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 7.h),
        Text(
          'Create a workspace for a project or team. Your tasks and progress will show up here.',
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 27.h),
        Container(
          padding: EdgeInsets.all(21.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF0E5D9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE8D9C9)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46.w,
                height: 46.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  Icons.space_dashboard_outlined,
                  color: AppColors.primary,
                  size: 23.w,
                ),
              ),
              SizedBox(height: 18.h),
              Text(
                'Start a workspace',
                style: AppTextStyle.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 7.h),
              Text(
                'Add tasks, share them with your team, and see what is done.',
                style: AppTextStyle.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(height: 21.h),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onCreate,
                  icon: const Icon(Icons.add_rounded, size: 19),
                  label: const Text('Create workspace'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OverviewMetric extends StatelessWidget {
  const _OverviewMetric({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$value',
            style: AppTextStyle.displayMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 25.sp,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          SizedBox(height: 7.h),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 37.h,
      margin: EdgeInsets.only(right: 16.w),
      color: AppColors.glassBorder,
    );
  }
}
