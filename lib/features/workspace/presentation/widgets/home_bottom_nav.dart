import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onHome,
    required this.onWorkspaces,
    required this.onSchedule,
    required this.onProfile,
  });

  final int selectedIndex;
  final VoidCallback onHome;
  final VoidCallback onWorkspaces;
  final VoidCallback onSchedule;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Material(
          color: AppColors.glassBase,
          elevation: 5,
          shadowColor: const Color(0x2225362E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: AppColors.glassBorder),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
            child: GNav(
              selectedIndex: selectedIndex,
              onTabChange: (index) {
                switch (index) {
                  case 0:
                    onHome();
                    return;
                  case 1:
                    onWorkspaces();
                    return;
                  case 2:
                    onSchedule();
                    return;
                  case 3:
                    onProfile();
                    return;
                }
              },
              gap: 4,
              iconSize: 19,
              textSize: AppTextStyle.navLabel.fontSize!,
              color: AppColors.textSecondary,
              activeColor: Colors.white,
              tabBackgroundColor: AppColors.primary,
              tabBorderRadius: 22,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
              duration: const Duration(milliseconds: 260),
              tabs: const [
                GButton(icon: Icons.home_rounded, text: 'Home'),
                GButton(icon: Icons.grid_view_rounded, text: 'Spaces'),
                GButton(icon: Icons.calendar_month_rounded, text: 'Schedule'),
                GButton(icon: Icons.person_outline_rounded, text: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
