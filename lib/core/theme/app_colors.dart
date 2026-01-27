import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary = Color(0xFF6366F1); // Indigo
  static const Color secondary = Color(0xFFEC4899); // Pink
  static const Color accent = Color(0xFF8B5CF6); // Violet
  static const Color neonCyan = Color(0xFF00E5FF);
  static const Color neonMagenta = Color(0xFFFF2E93);

  // Backgrounds
  static const Color background = Color(0xFF0F172A); // Dark Slate
  static const Color scaffoldBackground = Color(0xFF0F172A);

  // Glassmorphism Base
  static const Color glassBase = Color(0xFF1E293B);
  static const Color glassBackground = Color(0x1AFFFFFF); // 10% white for glass
  static const Color glassBorder = Color(0x33FFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
  );

  static const LinearGradient neonGradient = LinearGradient(
    colors: [Color(0xFF00E5FF), Color(0xFF2979FF)],
  );

  // Text
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // States
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // UI Elements
  static const Color textFieldFill = Color(0xFF1E293B);
  static const Color textFieldBorder = Color(0xFF334155);
  static const Color hintText = Color(0xFF64748B);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
}
