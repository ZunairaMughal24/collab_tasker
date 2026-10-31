import 'package:collab_tasker/core/theme/entry_palette.dart';
import 'package:flutter/material.dart';

class EntryBrandMark extends StatelessWidget {
  final double size;

  const EntryBrandMark({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: EntryPalette.accent,
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Icon(
        Icons.done_all_rounded,
        color: Colors.white,
        size: size * 0.54,
      ),
    );
  }
}

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool compact;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: compact ? 198 : 216,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 24, 28, 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const Spacer(),
            Text(
              title,
              style: const TextStyle(
                color: EntryPalette.ink,
                fontSize: 32,
                height: 1.12,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                color: EntryPalette.muted,
                fontSize: 14,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
