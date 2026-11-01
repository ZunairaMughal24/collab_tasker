import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/entry_palette.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_list_controller.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_card.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/home_bottom_nav.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_schedule_view.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/home_profile_avatar.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_home_sections.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_drawer.dart';
import 'package:collab_tasker/features/workspace/presentation/workspace_list_helpers.dart';
import 'package:collab_tasker/features/workspace/domain/entities/workspace.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:collab_tasker/config/app_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

const _homeBackgroundGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFF2E2D3),
    Color(0xFFF8F3EB),
    Color.fromARGB(255, 156, 220, 231),
  ],
  stops: [0, 0.54, 1],
);

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
  bool _showSearch = false;
  WorkspaceFilter _filter = WorkspaceFilter.all;
  bool _showSpacesOnly = false;
  bool _showSchedule = false;
  int _navVersion = 0;

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
    final showHomeGradient = !_showSchedule && !_showSpacesOnly;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: showHomeGradient ? null : AppColors.background,
        gradient: showHomeGradient ? _homeBackgroundGradient : null,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        extendBody: true,
        drawer: WorkspaceDrawer(
          displayName: user?.displayName,
          email: user?.email,
          onLogout: () async {
            await FirebaseAuth.instance.signOut();
            if (context.mounted) context.go(AppRoutes.signIn);
          },
        ),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 64,
          leadingWidth: 64,
          titleSpacing: 0,
          systemOverlayStyle: EntryPalette.systemOverlayStyle,
          centerTitle: _showSchedule,
          leading: _showSchedule
              ? IconButton(
                  tooltip: 'Back to home',
                  onPressed: () => setState(() => _showSchedule = false),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 19),
                )
              : HomeProfileAvatar(
                  onTap: () => _scaffoldKey.currentState?.openDrawer(),
                ),
          title: _showSchedule
              ? const Text(
                  'Task schedule',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hi, ${user?.displayName?.split(' ').first ?? 'there'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.homeGreeting,
                    ),
                    Text(
                      'Ready to make progress today?',
                      style: AppTextStyle.homeSubtitle,
                    ),
                  ],
                ),
          actionsPadding: const EdgeInsets.only(right: 8),
          actions: [
            if (!_showSchedule)
              IconButton(
                tooltip: 'Notifications',
                onPressed: () => _showNotifications(context),
                icon: const Icon(Icons.notifications_none_rounded, size: 20),
              )
            else
              IconButton(
                tooltip: 'About schedule',
                onPressed: () => _showScheduleHelp(context),
                icon: const Icon(Icons.help_outline_rounded, size: 22),
              ),
          ],
        ),
        body: _showSchedule
            ? AuthBackground(
                child: SafeArea(
                  child: Obx(
                    () => WorkspaceScheduleView(
                      workspaces: controller.workspaces.toList(),
                      onCreateWorkspace: () =>
                          context.push(AppRoutes.addWorkspace),
                      onOpenWorkspace: (workspace) => context.push(
                        AppRoutes.workspaceDetail,
                        extra: workspace,
                      ),
                    ),
                  ),
                ),
              )
            : SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showSearch)
                      Padding(
                        padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) => setState(() => _query = value),
                          style: AppTextStyle.bodyMedium.copyWith(
                            fontSize: 15.sp,
                          ),
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
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 19,
                                    ),
                                  ),
                            filled: true,
                            fillColor: AppColors.glassBase,
                            contentPadding: EdgeInsets.symmetric(
                              vertical: 15.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppColors.glassBase,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppColors.glassBase,
                              ),
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

                    SizedBox(height: 12.h),

                    Expanded(
                      child: Obx(() {
                        if (controller.isLoading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final visibleWorkspaces = controller.workspaces
                            .where(
                              (workspace) =>
                                  workspaceMatchesQuery(workspace, _query) &&
                                  workspaceMatchesFilter(workspace, _filter),
                            )
                            .toList();

                        if (controller.workspaces.isEmpty) {
                          return WorkspaceEmptyState(
                            onCreate: () =>
                                context.push(AppRoutes.addWorkspace),
                          );
                        }

                        final recentWorkspace = mostRecentlyActiveWorkspace(
                          controller.workspaces,
                        );

                        final showScheduleShortcut =
                            !_showSpacesOnly &&
                            _query.trim().isEmpty &&
                            _filter == WorkspaceFilter.all;
                        return ListView.builder(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 100.h),
                          itemCount: visibleWorkspaces.isEmpty
                              ? 2
                              : visibleWorkspaces.length +
                                    1 +
                                    (showScheduleShortcut ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!_showSpacesOnly &&
                                      _query.trim().isEmpty &&
                                      _filter == WorkspaceFilter.all) ...[
                                    FeaturedWorkspaceCard(
                                      workspace: recentWorkspace,
                                      onTap: () => context.push(
                                        AppRoutes.workspaceDetail,
                                        extra: recentWorkspace,
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: 20.h),
                                  Row(
                                    children: [
                                      Text(
                                        _showSpacesOnly
                                            ? 'Your workspaces'
                                            : 'Workspaces',
                                        style: AppTextStyle.homeSection,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        tooltip: 'Search workspaces',
                                        onPressed: () {
                                          if (_showSearch) {
                                            _searchController.clear();
                                          }
                                          setState(() {
                                            _showSearch = !_showSearch;
                                            if (!_showSearch) _query = '';
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.search_rounded,
                                          color: AppColors.textPrimary,
                                          size: 20,
                                        ),
                                      ),
                                      IconButton.filledTonal(
                                        tooltip: 'Create workspace',
                                        onPressed: () => context.push(
                                          AppRoutes.addWorkspace,
                                        ),
                                        style: IconButton.styleFrom(
                                          backgroundColor: AppColors.glassBase,
                                          foregroundColor:
                                              AppColors.textPrimary,
                                        ),
                                        icon: const Icon(
                                          Icons.add_rounded,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12.h),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: WorkspaceFilter.values.map((
                                        filter,
                                      ) {
                                        final selected = _filter == filter;
                                        final label = switch (filter) {
                                          WorkspaceFilter.all => 'All',
                                          WorkspaceFilter.notStarted =>
                                            'Not started',
                                          WorkspaceFilter.inProgress =>
                                            'Active',
                                          WorkspaceFilter.completed =>
                                            'Completed',
                                        };
                                        return Padding(
                                          padding: EdgeInsets.only(right: 8.w),
                                          child: ChoiceChip(
                                            label: Text(label),
                                            selected: selected,
                                            onSelected: (_) => setState(
                                              () => _filter = filter,
                                            ),
                                            showCheckmark: false,
                                            selectedColor: AppColors.primary,
                                            backgroundColor:
                                                AppColors.glassBase,
                                            side: BorderSide(
                                              color: selected
                                                  ? AppColors.primary
                                                  : AppColors.glassBorder,
                                            ),
                                            labelStyle: AppTextStyle.chipLabel
                                                .copyWith(
                                                  color: selected
                                                      ? Colors.white
                                                      : AppColors.textSecondary,
                                                ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 7.w,
                                              vertical: 1.h,
                                            ),
                                            shape: const StadiumBorder(),
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
                            if (index == visibleWorkspaces.length + 1) {
                              return ScheduleShortcutCard(
                                onTap: () =>
                                    setState(() => _showSchedule = true),
                              );
                            }
                            final workspace = visibleWorkspaces[index - 1];
                            return WorkspaceCard(
                              workspace: workspace,
                              tone: index - 1,
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
        bottomNavigationBar: HomeBottomNav(
          key: ValueKey(_navVersion),
          selectedIndex: _showSchedule ? 2 : (_showSpacesOnly ? 1 : 0),
          onHome: () {
            _searchController.clear();
            setState(() {
              _showSchedule = false;
              _showSpacesOnly = false;
              _query = '';
              _filter = WorkspaceFilter.all;
            });
          },
          onWorkspaces: () => setState(() {
            _showSchedule = false;
            _showSpacesOnly = true;
          }),
          onSchedule: () => setState(() => _showSchedule = true),
          onProfile: () {
            setState(() => _navVersion++);
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 38),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: AppTextStyle.displayMedium.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 26),
              const Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  'You’re all caught up',
                  style: TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showScheduleHelp(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.background,
      builder: (context) => const SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, 8, 24, 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'About your schedule',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 9),
              Text(
                'Tasks with due dates appear on the selected day. Tasks without a due date are listed below.',
                style: TextStyle(
                  fontFamily: 'Nunito',
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
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
