import 'package:collab_tasker/core/theme/entry_palette.dart';
import 'package:collab_tasker/features/splash/presentation/controllers/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SplashController());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: EntryPalette.accent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: EntryPalette.accent,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarContrastEnforced: false,
      ),
      child: Scaffold(
        backgroundColor: EntryPalette.accent,
        body: SafeArea(
          child: Stack(
            children: [
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SplashMark(),
                    SizedBox(height: 20),
                    Text(
                      'collab tasker',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 28,
                right: 28,
                bottom: 30,
                child: Obx(() {
                  if (!controller.hasError.value) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        controller.errorMessage.value,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                      TextButton(
                        onPressed: controller.retry,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Try again'),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashMark extends StatelessWidget {
  const _SplashMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: Colors.white.withValues(alpha: 0.48)),
      ),
      child: const Icon(Icons.done_all_rounded, color: Colors.white, size: 38),
    );
  }
}
