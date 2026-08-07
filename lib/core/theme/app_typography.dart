import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// One typeface, one weight, hierarchy from scale alone.
///
/// Instrument Sans stands in for Neue Montreal — a modern grotesque that holds
/// up at display sizes. Everything is weight 400: a 100px headline next to 18px
/// body is a 5x ratio, and at that distance bolding is not only unnecessary, it
/// reads as insecurity. Weight 700 is reserved for one role only.
///
/// The other half of the effect is tracking. Display sizes take -2% and small
/// uppercase labels take +2% — tight where the letters are huge, open where
/// they are small and set in caps.
abstract final class AppTypography {
  const AppTypography._();

  /// Cinematic display type. Line height stays at 1.0–1.05 so multi-line
  /// stacks read as sculptural blocks rather than as paragraphs.
  static TextStyle display({
    required double fontSize,
    Color color = AppColors.bone,
    double height = 1.0,
    FontWeight fontWeight = FontWeight.w400,
  }) => GoogleFonts.instrumentSans(
    fontSize: fontSize,
    color: color,
    height: height,
    fontWeight: fontWeight,
    letterSpacing: fontSize * -0.02,
  );

  /// Uppercase metadata: eyebrows, nav, taxonomy labels, section numbers.
  /// All-caps at weight 400 — restraint rather than shouting.
  static TextStyle label({
    Color color = AppColors.fog,
    double fontSize = 14,
  }) => GoogleFonts.instrumentSans(
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w400,
    letterSpacing: fontSize * 0.02 + 0.6,
    height: 1.2,
  );

  /// General-purpose sans for anything not covered by a named role — inline
  /// metadata, captions, values in a definition list.
  static TextStyle sans({
    double fontSize = 16,
    Color color = AppColors.bone,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
    double height = 1.4,
  }) => GoogleFonts.instrumentSans(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
  );

  /// The one place weight 700 is allowed: mid-scale subheadings.
  static TextStyle subheading({
    double fontSize = 33,
    Color color = AppColors.bone,
  }) => GoogleFonts.instrumentSans(
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: fontSize * -0.01,
  );

  static TextTheme textTheme() {
    final TextTheme base = GoogleFonts.instrumentSansTextTheme(
      const TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          height: 1.25,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.22,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          height: 1.3,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        bodyLarge: TextStyle(fontSize: 20, height: 1.5, letterSpacing: -0.2),
        bodyMedium: TextStyle(fontSize: 18, height: 1.55),
        bodySmall: TextStyle(fontSize: 16, height: 1.5),
        labelLarge: TextStyle(
          fontSize: 15,
          height: 1.2,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
      ),
    );

    return base.apply(bodyColor: AppColors.bone, displayColor: AppColors.bone);
  }
}
