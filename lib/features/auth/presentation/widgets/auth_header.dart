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
    return Container(
      height: compact ? 242 : 280,
      color: EntryPalette.hero,
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: -64,
            top: -110,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x2EFFFFFF)),
              ),
            ),
          ),
          Positioned(
            right: -4,
            top: -55,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x24FFFFFF)),
              ),
            ),
          ),
          Positioned(
            right: 32,
            top: 45,
            child: Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: EntryPalette.accent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 31),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    EntryBrandMark(),
                    SizedBox(width: 11),
                    Text(
                      'collab tasker',
                      style: TextStyle(
                        color: Colors.white,
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
                    color: Colors.white,
                    fontSize: 37,
                    height: 1.08,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: EntryPalette.heroMuted,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
