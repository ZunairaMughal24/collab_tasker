import 'package:flutter/services.dart';

/// Palette for the redesigned entry and workspace list screens.
class EntryPalette {
  static const background = Color(0xFFF6F3ED);
  static const surface = Color(0xFFFFFEFB);
  static const fieldFill = Color(0xFFFCFAF6);
  static const ink = Color(0xFF222C27);
  static const muted = Color(0xFF707A72);
  static const accent = Color(0xFFAD5538);
  static const accentSoft = Color(0xFFF7E7DC);
  static const border = Color(0xFFDCDDD5);
  static const fieldBorder = Color(0xFFE7E9E3);
  static const fieldHint = Color(0xFF879088);
  static const error = Color(0xFFB4453D);
  static const hero = Color(0xFF25362E);
  static const heroMuted = Color(0xFFB9C6BA);
  static const sand = Color(0xFFE8E1D4);

  static const systemOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: background,
    statusBarIconBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarColor: background,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );
}
