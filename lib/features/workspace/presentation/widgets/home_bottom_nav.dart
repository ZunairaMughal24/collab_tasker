import 'package:collab_tasker/core/theme/app_colors.dart';
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
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Material(
              color: AppColors.glassBase,
              elevation: 6,
              shadowColor: const Color(0x1A25362E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(27),
                side: const BorderSide(color: Color(0xFFE8E4DC)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
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
                  gap: 7,
                  iconSize: 21,
                  textSize: 12,
                  color: AppColors.textSecondary,
                  activeColor: Colors.white,
                  tabBackgroundColor: AppColors.primary,
                  tabBorderRadius: 20,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 11,
                  ),
                  duration: const Duration(milliseconds: 220),
                  tabs: const [
                    GButton(icon: Icons.home_rounded, text: 'Home'),
                    GButton(icon: Icons.grid_view_rounded, text: 'Spaces'),
                    GButton(
                      icon: Icons.calendar_month_rounded,
                      text: 'Schedule',
                    ),
                    GButton(
                      icon: Icons.person_outline_rounded,
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
