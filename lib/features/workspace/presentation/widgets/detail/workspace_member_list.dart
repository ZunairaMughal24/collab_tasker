import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:collab_tasker/widgets/glass_container.dart';
import 'package:collab_tasker/features/workspace/presentation/controllers/workspace_detail_controller.dart';

class WorkspaceMemberList extends StatelessWidget {
  final WorkspaceDetailController controller;

  const WorkspaceMemberList({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final members = controller.workspace.value.members;
      final pendingMembers = controller.workspace.value.pendingMembers;
      final totalCount = members.length + pendingMembers.length;

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          final isPending = index >= members.length;
          final memberUid = !isPending ? members[index] : null;
          final pendingEmail = isPending
              ? pendingMembers[index - members.length]
              : null;
          final profile = memberUid != null
              ? controller.memberProfiles[memberUid]
              : null;

          return GlassContainer(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(12.w),
            borderRadius: 16,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isPending
                      ? AppColors.textSecondary.withValues(alpha: 0.1)
                      : AppColors.primary.withValues(alpha: 0.1),
                  child: isPending
                      ? const Icon(
                          Icons.mail_outline_rounded,
                          color: AppColors.textSecondary,
                        )
                      : (profile?['name'] as String? ?? '').isNotEmpty
                      ? Text(
                          (profile!['name'] as String)[0].toUpperCase(),
                          style: const TextStyle(color: AppColors.primary),
                        )
                      : const Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                        ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              isPending
                                  ? 'Pending Invite'
                                  : (profile?['name'] ?? 'Loading...'),
                              style: AppTextStyle.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isPending
                                    ? AppColors.textSecondary
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isPending) ...[
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'PENDING',
                                style: AppTextStyle.bodySmall.copyWith(
                                  color: AppColors.accent,
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      Text(
                        isPending
                            ? pendingEmail!
                            : (profile?['email'] ?? memberUid!),
                        style: AppTextStyle.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _showMemberManagementMenu(
                    context,
                    memberId: memberUid,
                    email: pendingEmail,
                    name: isPending
                        ? pendingEmail!
                        : (profile?['name'] ?? 'this member'),
                  ),
                  icon: const Icon(
                    Icons.more_horiz_rounded,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  void _showMemberManagementMenu(
    BuildContext context, {
    String? memberId,
    String? email,
    required String name,
  }) {
    final currentUser = controller.currentUser;
    final isCreator = controller.workspace.value.createdBy == currentUser?.uid;
    final isPending = email != null;

    if (!isCreator) return;
    if (memberId == currentUser?.uid) return;

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
            if (isPending)
              _buildMenuOption(
                icon: Icons.cancel_outlined,
                title: 'Cancel Invitation',
                isDanger: true,
                onTap: () {
                  Navigator.pop(context);
                  _confirmCancelInvite(context, email);
                },
              )
            else
              _buildMenuOption(
                icon: Icons.person_remove_outlined,
                title: 'Remove Member',
                isDanger: true,
                onTap: () {
                  Navigator.pop(context);
                  _confirmRemoveMember(context, memberId!, name);
                },
              ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  void _confirmCancelInvite(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Cancel Invitation', style: AppTextStyle.displayMedium),
        content: Text(
          'Are you sure you want to cancel the invitation for $email?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              controller.cancelInvite(email);
              Navigator.pop(context);
            },
            child: const Text(
              'Yes, Cancel',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
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

  void _confirmRemoveMember(
    BuildContext context,
    String memberId,
    String name,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Remove Member', style: AppTextStyle.displayMedium),
        content: Text(
          'Are you sure you want to remove $name from this workspace?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              controller.removeMember(memberId);
              Navigator.pop(context);
            },
            child: const Text(
              'Remove',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
