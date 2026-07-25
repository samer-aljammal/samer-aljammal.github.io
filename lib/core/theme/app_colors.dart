import 'package:flutter/material.dart';

/// The violet/magenta neon palette.
///
/// Everything visual pulls from here — no raw hex literals anywhere else in the
/// app, so re-theming the whole site means editing this one file.
abstract final class AppColors {
  const AppColors._();

  // --- Surfaces -------------------------------------------------------------

  /// Deep plum page background.
  static const Color background = Color(0xFF0B0714);

  /// Raised panels: cards, nav bar, input fields.
  static const Color surface = Color(0xFF16102A);

  /// Hover/pressed state for anything sitting on [surface].
  static const Color surfaceHigh = Color(0xFF1E1638);

  /// The device bezel and other "solid object" fills.
  static const Color bezel = Color(0xFF080510);

  // --- Accents --------------------------------------------------------------

  static const Color violet = Color(0xFFA855F7);
  static const Color magenta = Color(0xFFEC4899);

  /// Cooler violet used for the far end of ambient glows.
  static const Color indigo = Color(0xFF6366F1);

  // --- Text -----------------------------------------------------------------

  static const Color textPrimary = Color(0xFFF4F1FB);
  static const Color textSecondary = Color(0xFF9C93B8);
  static const Color textTertiary = Color(0xFF6D648A);

  // --- Lines ----------------------------------------------------------------

  static const Color border = Color(0x1FFFFFFF);
  static const Color borderStrong = Color(0x3DA855F7);

  // --- Gradients ------------------------------------------------------------

  /// The signature violet to magenta sweep. Used on headings, buttons, rules.
  static const LinearGradient accent = LinearGradient(
    colors: [violet, magenta],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle top-lit sheen for cards, so panels read as physical surfaces.
  static const LinearGradient cardSheen = LinearGradient(
    colors: [Color(0x14FFFFFF), Color(0x00FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomCenter,
  );

  /// Ambient background orbs, in draw order.
  static const List<Color> orbs = [violet, magenta, indigo];

  // --- Effects --------------------------------------------------------------

  /// Glow cast by an accent-colored element on hover.
  static List<BoxShadow> glow(Color color, {double strength = 1}) => [
    BoxShadow(
      color: color.withValues(alpha: 0.35 * strength),
      blurRadius: 28 * strength,
      spreadRadius: -4,
      offset: const Offset(0, 8),
    ),
  ];
}
