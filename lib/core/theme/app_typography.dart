import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Type scale: Outfit for display/headings, Inter for body and UI.
abstract final class AppTypography {
  const AppTypography._();

  static TextTheme textTheme() {
    final TextTheme heading = GoogleFonts.outfitTextTheme(
      const TextTheme(
        // Sized against the ~700px hero copy column rather than the full page
        // width. Note that widget tests cannot validate this: flutter_test
        // swaps in a font whose every glyph is a square of the font size, which
        // inflates any measured line count by roughly 2x.
        displayLarge: TextStyle(
          fontSize: 68,
          height: 1.04,
          fontWeight: FontWeight.w700,
          letterSpacing: -2.0,
        ),
        displayMedium: TextStyle(
          fontSize: 52,
          height: 1.07,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 40,
          height: 1.12,
          fontWeight: FontWeight.w600,
          letterSpacing: -1.0,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.6,
        ),
        titleLarge: TextStyle(
          fontSize: 21,
          height: 1.3,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
      ),
    );

    final TextTheme body = GoogleFonts.interTextTheme(
      const TextTheme(
        titleMedium: TextStyle(
          fontSize: 16,
          height: 1.45,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(fontSize: 17, height: 1.65),
        bodyMedium: TextStyle(fontSize: 15, height: 1.6),
        bodySmall: TextStyle(fontSize: 13, height: 1.5),
        labelLarge: TextStyle(
          fontSize: 14,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        labelSmall: TextStyle(
          fontSize: 12,
          height: 1.2,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.6,
        ),
      ),
    );

    return TextTheme(
      displayLarge: heading.displayLarge,
      displayMedium: heading.displayMedium,
      headlineLarge: heading.headlineLarge,
      headlineMedium: heading.headlineMedium,
      titleLarge: heading.titleLarge,
      titleMedium: body.titleMedium,
      bodyLarge: body.bodyLarge,
      bodyMedium: body.bodyMedium,
      bodySmall: body.bodySmall,
      labelLarge: body.labelLarge,
      labelSmall: body.labelSmall,
    ).apply(
      bodyColor: AppColors.textPrimary,
      displayColor: AppColors.textPrimary,
    );
  }

  /// Monospace, for tech tags and the "coordinates" flourishes.
  static TextStyle mono({
    double fontSize = 12,
    Color color = AppColors.textSecondary,
    FontWeight fontWeight = FontWeight.w500,
    double letterSpacing = 0.4,
  }) => GoogleFonts.jetBrainsMono(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: 1.4,
  );
}
