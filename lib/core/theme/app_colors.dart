import 'package:flutter/material.dart';

/// Monochrome-with-one-accent palette.
///
/// The discipline here is deliberate and it is the whole design: a flat black
/// canvas, hairline borders instead of shadows, four tiers of grey text, and a
/// single violet reserved for code and identifiers. No gradients on surfaces,
/// no glows, no tinted card fills — those read as generated rather than
/// designed, which is exactly what this replaced.
abstract final class AppColors {
  const AppColors._();

  // --- Canvas -------------------------------------------------------------

  /// The page. Pure black, never off-black or tinted.
  static const Color void_ = Color(0xFF000000);

  /// Elevated panel fill, used sparingly — most surfaces stay black and are
  /// separated by a border alone.
  static const Color surfaceLift = Color(0xFF0B0E14);

  // --- Lines --------------------------------------------------------------

  /// The 1px hairline that separates every layer. This does the job that
  /// shadows do elsewhere.
  static const Color hairline = Color(0xFF292D30);

  /// Hairline under hover/focus — brighter, never colored.
  static const Color hairlineBright = Color(0xFF52585C);

  // --- Text ---------------------------------------------------------------

  /// Headings and hero type.
  static const Color white = Color(0xFFFFFFFF);

  /// Body copy and secondary headings — the main reading color.
  static const Color bone = Color(0xFFF0F0F0);

  /// Muted body, metadata, badge labels.
  static const Color ash = Color(0xFFA1A4A5);

  /// Captions, inactive states, supporting detail.
  static const Color smoke = Color(0xFF8A8F94);

  /// Text that should recede into the surface — section numbers, footnotes.
  static const Color iron = Color(0xFF6E727A);

  /// Barely-there labels and decorative strokes.
  static const Color charcoal = Color(0xFF464A4D);

  // --- Accent -------------------------------------------------------------

  /// The only brand color. Belongs to code, identifiers, inline marks and
  /// small indicators — never to a button fill, never to a large heading, and
  /// never as a gradient.
  static const Color iris = Color(0xFF9281F7);

  /// Lighter violet for text-on-black where [iris] is too dim.
  static const Color irisGlow = Color(0xFFBAA7FF);

  // --- Status -------------------------------------------------------------
  // Reserved for data and state indicators only, never for UI chrome.

  static const Color green = Color(0xFF3AD389);
  static const Color blue = Color(0xFF70B8FF);
  static const Color amber = Color(0xFFFFCA16);
  static const Color red = Color(0xFFFF9592);
}
