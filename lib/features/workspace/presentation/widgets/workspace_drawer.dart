import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WorkspaceDrawer extends StatelessWidget {
  const WorkspaceDrawer({
    super.key,
    required this.displayName,
    required this.email,
    required this.onLogout,
  });

  final String? displayName;
  final String? email;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
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
                  displayName ?? 'Collab Member',
                  style: AppTextStyle.displayMedium.copyWith(fontSize: 20.sp),
                ),
                Text(
                  email ?? 'member@collabtasker.com',
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
              onTap: onLogout,
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
}
