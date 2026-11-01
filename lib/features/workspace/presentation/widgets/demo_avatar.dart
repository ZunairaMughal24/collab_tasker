import 'package:flutter/material.dart';

/// Local demo portraits. They are placeholders until member profile photos exist.
class DemoAvatar extends StatelessWidget {
  const DemoAvatar({super.key, required this.index, required this.size});

  final int index;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/avatar_${index % 4}.png',
          width: size - 4,
          height: size - 4,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
