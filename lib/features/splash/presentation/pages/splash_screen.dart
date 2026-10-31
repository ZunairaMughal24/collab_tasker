import 'package:collab_tasker/core/theme/entry_palette.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_header.dart';
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
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: EntryPalette.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 24, 28, 30),
            child: Column(
              children: [
                const Row(
                  children: [
                    EntryBrandMark(size: 36),
                    SizedBox(width: 10),
                    Text(
                      'collab tasker',
                      style: TextStyle(
                        color: EntryPalette.ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const _TaskArtwork(),
                        const SizedBox(height: 36),
                        const Text(
                          'Make space for\nbetter work.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: EntryPalette.ink,
                            fontSize: 36,
                            height: 1.08,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Your team, tasks and progress\nin one thoughtful place.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: EntryPalette.muted,
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.hasError.value) {
                    return Column(
                      children: [
                        Text(
                          controller.errorMessage.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: EntryPalette.error,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: controller.retry,
                          style: TextButton.styleFrom(
                            foregroundColor: EntryPalette.accent,
                          ),
                          child: const Text('Try again'),
                        ),
                      ],
                    );
                  }

                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          color: EntryPalette.accent,
                          strokeWidth: 2,
                        ),
                      ),
                      SizedBox(width: 11),
                      Text(
                        'Preparing your workspace',
                        style: TextStyle(
                          color: EntryPalette.muted,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskArtwork extends StatelessWidget {
  const _TaskArtwork();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 258,
      height: 212,
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 13,
            child: Transform.rotate(
              angle: -0.09,
              child: Container(
                width: 216,
                height: 166,
                decoration: BoxDecoration(
                  color: EntryPalette.sand,
                  borderRadius: BorderRadius.circular(21),
                ),
              ),
            ),
          ),
          Positioned(
            left: 29,
            top: 24,
            child: Container(
              width: 218,
              height: 170,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: EntryPalette.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: EntryPalette.border),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x16222C27),
                    blurRadius: 24,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TODAY',
                    style: TextStyle(
                      color: EntryPalette.muted,
                      fontSize: 10,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 17),
                  _TaskLine(width: 126, checked: true),
                  SizedBox(height: 14),
                  _TaskLine(width: 151, checked: true),
                  SizedBox(height: 14),
                  _TaskLine(width: 105, checked: false),
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 51,
              height: 51,
              decoration: BoxDecoration(
                color: EntryPalette.accent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x32AD5538),
                    blurRadius: 16,
                    offset: Offset(0, 7),
                  ),
                ],
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskLine extends StatelessWidget {
  final double width;
  final bool checked;

  const _TaskLine({required this.width, required this.checked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: checked ? EntryPalette.accentSoft : EntryPalette.surface,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: checked ? EntryPalette.accent : EntryPalette.border,
            ),
          ),
          child: checked
              ? const Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: EntryPalette.accent,
                )
              : null,
        ),
        const SizedBox(width: 11),
        Container(
          width: width,
          height: 8,
          decoration: BoxDecoration(
            color: checked ? EntryPalette.sand : EntryPalette.border,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }
}
