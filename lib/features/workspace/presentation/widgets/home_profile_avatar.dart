import 'package:collab_tasker/widgets/demo_avatar.dart';
import 'package:flutter/material.dart';

class HomeProfileAvatar extends StatelessWidget {
  const HomeProfileAvatar({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 6),
      child: Center(
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: const DemoAvatar(index: 0, size: 38),
        ),
      ),
    );
  }
}
