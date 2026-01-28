import 'package:flutter/material.dart';
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

class WorkspaceListScreen extends StatelessWidget {
  const WorkspaceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WorkspaceListController());
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      key: scaffoldKey,
      drawer: _buildDrawer(context),
      body: AuthBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Icon(
                          Icons.menu_rounded,
                          color: AppColors.white,
                          size: 24.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${user?.displayName?.split(' ').first ?? 'Member'}!',
                            style: AppTextStyle.displayMedium.copyWith(
                              fontSize: 22.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Manage your team tasks effectively',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        AppSnackbar.showSuccess('Notifications coming soon');
                      },
                      icon: Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                        size: 28.w,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                      size: 20.w,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: TextField(
                        style: AppTextStyle.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'Search Workspaces...',
                          hintStyle: AppTextStyle.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 22.h),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

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
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    itemCount:
                        controller.workspaces.length +
                        (controller.hasMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < controller.workspaces.length) {
                        final workspace = controller.workspaces[index];
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
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.addWorkspace),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.transparent),
            currentAccountPicture: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(
                Icons.person_outline_rounded,
                color: AppColors.primary,
                size: 40.w,
              ),
              radius: 40.r,
            ),
            accountName: Text(
              user?.displayName ?? 'Collab Member',
              style: AppTextStyle.bodyLarge,
            ),
            accountEmail: Text(
              user?.email ?? 'member@collabtasker.com',
              style: AppTextStyle.bodySmall,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline, color: Colors.white),
            title: Text('My Profile', style: AppTextStyle.bodyMedium),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: Colors.white),
            title: Text('Settings', style: AppTextStyle.bodyMedium),
            onTap: () {},
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              'Logout',
              style: AppTextStyle.bodyMedium.copyWith(color: AppColors.error),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go(AppRoutes.signIn);
              }
            },
          ),
          SizedBox(height: 30.h),
        ],
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
          color: AppColors.background,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
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
      leading: Icon(icon, color: isDanger ? AppColors.error : Colors.white),
      title: Text(
        title,
        style: AppTextStyle.bodyLarge.copyWith(
          color: isDanger ? AppColors.error : Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: Colors.white.withValues(alpha: 0.05),
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
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              style: AppTextStyle.bodyMedium.copyWith(color: Colors.white),
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
