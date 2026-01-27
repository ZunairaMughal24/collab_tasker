import 'package:flutter/material.dart';
import 'package:collab_tasker/core/theme/app_colors.dart';
import 'package:collab_tasker/core/theme/app_text_styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppSnackbar {
  static OverlayEntry? _currentEntry;

  static void showSuccess(String message) {
    _show(message: message, isError: false, icon: Icons.check_circle_rounded);
  }

  static void showError(String message) {
    _show(message: message, isError: true, icon: Icons.error_outline_rounded);
  }

  static void _show({
    required String message,
    required bool isError,
    required IconData icon,
  }) {
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) return;

    final overlay = navigatorState.overlay;
    if (overlay == null) return;

    final statusColor = isError ? AppColors.error : AppColors.success;

    _currentEntry?.remove();
    _currentEntry = null;

    _currentEntry = OverlayEntry(
      builder: (context) => _TopSnackbarWidget(
        message: message,
        statusColor: statusColor,
        icon: icon,
        isError: isError,
        onDismiss: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
      ),
    );

    overlay.insert(_currentEntry!);
  }
}

class _TopSnackbarWidget extends StatefulWidget {
  final String message;
  final Color statusColor;
  final IconData icon;
  final bool isError;
  final VoidCallback onDismiss;

  const _TopSnackbarWidget({
    required this.message,
    required this.statusColor,
    required this.icon,
    required this.isError,
    required this.onDismiss,
  });

  @override
  State<_TopSnackbarWidget> createState() => _TopSnackbarWidgetState();
}

class _TopSnackbarWidgetState extends State<_TopSnackbarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _controller.reverse().then((_) => widget.onDismiss());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50.h,
      left: 20.w,
      right: 20.w,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B).withValues(alpha: 0.98),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.statusColor,
                    size: 28.w,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.isError ? 'Error Occurred' : 'Success!',
                        style: AppTextStyle.bodySmall.copyWith(
                          color: widget.statusColor,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        widget.message,
                        style: AppTextStyle.bodyMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
