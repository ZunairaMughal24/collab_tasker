import 'package:flutter/material.dart';
import 'package:collab_tasker/core/theme/entry_palette.dart';

class AppColors {
  // Shared workspace palette.
  static const Color primary = EntryPalette.accent;
  static const Color secondary = EntryPalette.hero;
  static const Color accent = EntryPalette.hero;
  static const Color neonCyan = EntryPalette.accent;
  static const Color neonMagenta = EntryPalette.accent;

  // Backgrounds
  static const Color background = EntryPalette.background;
  static const Color scaffoldBackground = EntryPalette.background;

  static const Color glassBase = EntryPalette.surface;
  static const Color glassBackground = EntryPalette.surface;
  static const Color glassBorder = Color.fromARGB(255, 233, 231, 227);
  static const Color surfaceShadow = Color.fromARGB(18, 100, 114, 107);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [EntryPalette.accent, EntryPalette.hero],
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [EntryPalette.accent, EntryPalette.hero],
  );

  // Text
  static const Color textPrimary = EntryPalette.ink;
  static const Color textSecondary = EntryPalette.muted;
  static const Color textMuted = EntryPalette.muted;

  // States
  static const Color success = Color(0xFF3E7658);
  static const Color error = EntryPalette.error;
  static const Color warning = Color(0xFFB88035);
  static const Color info = EntryPalette.hero;

  // UI Elements
  static const Color textFieldFill = EntryPalette.surface;
  static const Color textFieldBorder = Color.fromARGB(255, 231, 233, 227);
  static const Color hintText = EntryPalette.muted;
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
}
