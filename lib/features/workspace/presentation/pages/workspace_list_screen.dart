import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_background.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_list_controller.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_card.dart';
import 'package:collab_tasker/features/workspace/presentation/widgets/workspace_top_bar.dart';
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
      appBar: WorkspaceTopBar(
        title: 'Hello, ${user?.displayName?.split(' ').first ?? 'Member'}!',
        subtitle: 'Manage your team tasks effectively',
        leadingIcon: Icons.menu_rounded,
        leadingTooltip: 'Open menu',
        onLeadingPressed: () => _scaffoldKey.currentState?.openDrawer(),
        actionIcon: Icons.notifications_none_rounded,
        actionTooltip: 'Notifications',
        onActionPressed: () =>
            AppSnackbar.showSuccess('Notifications coming soon'),
      ),
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                    fillColor: AppColors.textFieldFill,
                    contentPadding: EdgeInsets.symmetric(vertical: 15.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.textFieldBorder,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: AppColors.textFieldBorder,
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

              SizedBox(height: 20.h),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final visibleWorkspaces = controller.workspaces
                      .where(
                        (workspace) => workspaceMatchesQuery(workspace, _query),
                      )
                      .toList();

                  if (controller.workspaces.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.dashboard_customize_outlined,
                            size: 64.w,
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            'No Workspaces Found',
                            style: AppTextStyle.displayMedium.copyWith(
                              fontSize: 20.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              'Create a workspace to collaborate with your team and master your goals together.',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          SizedBox(height: 22.h),
                          FilledButton.icon(
                            onPressed: () =>
                                context.push(AppRoutes.addWorkspace),
                            icon: const Icon(Icons.add_rounded, size: 20),
                            label: const Text('Create workspace'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 13.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (visibleWorkspaces.isEmpty) {
                    return Center(
                      child: Text(
                        'No matching workspaces',
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount: visibleWorkspaces.length,
                    itemBuilder: (context, index) {
                      final workspace = visibleWorkspaces[index];
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
