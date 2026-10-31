import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A consistent compact toolbar for the workspace screens.
class WorkspaceTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final IconData leadingIcon;
  final String leadingTooltip;
  final VoidCallback onLeadingPressed;
  final IconData? actionIcon;
  final String? actionTooltip;
  final VoidCallback? onActionPressed;

  const WorkspaceTopBar({
    super.key,
    required this.title,
    this.subtitle,
    required this.leadingIcon,
    required this.leadingTooltip,
    required this.onLeadingPressed,
    this.actionIcon,
    this.actionTooltip,
    this.onActionPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      toolbarHeight: 64,
      leadingWidth: 56,
      titleSpacing: 0,
      leading: IconButton(
        tooltip: leadingTooltip,
        onPressed: onLeadingPressed,
        style: IconButton.styleFrom(
          minimumSize: const Size(48, 48),
          padding: EdgeInsets.zero,
        ),
        icon: Icon(leadingIcon, size: 24),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Nunito',
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Nunito',
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.25,
              ),
            ),
          ],
        ],
      ),
      actionsPadding: const EdgeInsets.only(right: 8),
      actions: actionIcon == null
          ? null
          : [
              IconButton(
                tooltip: actionTooltip,
                onPressed: onActionPressed,
                style: IconButton.styleFrom(
                  minimumSize: const Size(48, 48),
                  padding: EdgeInsets.zero,
                ),
                icon: Icon(actionIcon, size: 24),
              ),
            ],
    );
  }
}
