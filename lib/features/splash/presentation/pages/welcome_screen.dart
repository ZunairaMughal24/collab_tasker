import 'dart:math' as math;

import 'package:collab_tasker/config/app_router.dart';
import 'package:collab_tasker/core/theme/entry_palette.dart';
import 'package:collab_tasker/features/auth/presentation/widgets/auth_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: EntryPalette.systemOverlayStyle,
      child: Scaffold(
        backgroundColor: EntryPalette.background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 26),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 28),
                        child: Column(
                          children: [
                            _WelcomeArtwork(
                              width: math.min(constraints.maxWidth - 56, 280),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Make space for\nbetter work.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: EntryPalette.ink,
                                fontSize: 33,
                                height: 1.12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.9,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Your team, tasks and progress\nin one thoughtful place.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: EntryPalette.muted,
                                fontSize: 15,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: FilledButton(
                              onPressed: () => context.go(AppRoutes.signUp),
                              style: FilledButton.styleFrom(
                                backgroundColor: EntryPalette.accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: const Text(
                                'Get started',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () => context.go(AppRoutes.signIn),
                            style: TextButton.styleFrom(
                              foregroundColor: EntryPalette.ink,
                            ),
                            child: const Text(
                              'I already have an account',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeArtwork extends StatelessWidget {
  final double width;

  const _WelcomeArtwork({required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        aspectRatio: 280 / 220,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 280,
            height: 220,
            child: Stack(
              children: [
                Positioned(
                  left: 14,
                  top: 15,
                  child: Transform.rotate(
                    angle: -0.07,
                    child: Container(
                      width: 238,
                      height: 181,
                      decoration: BoxDecoration(
                        color: EntryPalette.sand,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 28,
                  top: 25,
                  child: Container(
                    width: 240,
                    height: 181,
                    padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                    decoration: BoxDecoration(
                      color: EntryPalette.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: EntryPalette.border),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x16222C27),
                          blurRadius: 22,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TODAY\'S FOCUS',
                          style: TextStyle(
                            color: EntryPalette.muted,
                            fontSize: 10,
                            letterSpacing: 1.3,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          'Plan the week',
                          style: TextStyle(
                            color: EntryPalette.ink,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8),
                        _ArtworkTask(label: 'Review project goals', done: true),
                        SizedBox(height: 7),
                        _ArtworkTask(label: 'Share progress', done: true),
                        SizedBox(height: 7),
                        _ArtworkTask(label: 'Plan next steps', done: false),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 49,
                    height: 49,
                    decoration: BoxDecoration(
                      color: EntryPalette.accent,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x30AD5538),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.check_rounded, color: Colors.white),
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

class _ArtworkTask extends StatelessWidget {
  final String label;
  final bool done;

  const _ArtworkTask({required this.label, required this.done});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          done
              ? Icons.check_circle_rounded
              : Icons.radio_button_unchecked_rounded,
          size: 18,
          color: done ? EntryPalette.accent : EntryPalette.border,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: EntryPalette.ink,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
