import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Three typefaces, each with one job.
///
/// * **Instrument Serif** — display only. An editorial serif at large sizes is
///   the single strongest signal that a page was art-directed rather than
///   assembled from a UI kit. Used for hero and section headlines, nothing else.
/// * **Inter** — body, UI, navigation, buttons.
/// * **JetBrains Mono** — code, identifiers, section numbers, metadata. The
///   monospace presence is the developer identity running through the page.
///
/// Tracking is the other half of the effect: negative at display sizes so the
/// headline reads compressed and confident, positive on small uppercase mono so
/// labels breathe.
abstract final class AppTypography {
  const AppTypography._();

  /// Editorial serif for display type.
  static TextStyle display({
    required double fontSize,
    Color color = AppColors.white,
    double height = 1.0,
    FontWeight fontWeight = FontWeight.w400,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) => GoogleFonts.instrumentSerif(
    fontSize: fontSize,
    color: color,
    height: height,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    // Roughly -1% of the size: what makes large serif type feel set rather
    // than typed.
    letterSpacing: letterSpacing ?? fontSize * -0.01,
  );

  /// Monospace for code, identifiers, numbers and small uppercase labels.
  static TextStyle mono({
    double fontSize = 12,
    Color color = AppColors.ash,
    FontWeight fontWeight = FontWeight.w400,
    double letterSpacing = 0,
    double height = 1.4,
  }) => GoogleFonts.jetBrainsMono(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: height,
  );

  /// Small uppercase mono label — section eyebrows, metadata keys.
  static TextStyle label({
    Color color = AppColors.iron,
    double fontSize = 11,
  }) => GoogleFonts.jetBrainsMono(
    fontSize: fontSize,
    color: color,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.6,
    height: 1.2,
  );

  static TextTheme textTheme() {
    final TextTheme body = GoogleFonts.interTextTheme(
      const TextTheme(
        titleLarge: TextStyle(
          fontSize: 20,
          height: 1.3,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.4,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
        bodyLarge: TextStyle(fontSize: 18, height: 1.6),
        bodyMedium: TextStyle(fontSize: 16, height: 1.6),
        bodySmall: TextStyle(fontSize: 14, height: 1.5),
        labelLarge: TextStyle(
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w500,
        ),
      ),
    );

    return body.apply(bodyColor: AppColors.bone, displayColor: AppColors.white);
  }
}
