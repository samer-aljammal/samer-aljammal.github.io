import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    const ColorScheme scheme = ColorScheme.dark(
      primary: AppColors.white,
      onPrimary: AppColors.void_,
      secondary: AppColors.iris,
      onSecondary: AppColors.white,
      surface: AppColors.void_,
      onSurface: AppColors.bone,
      outline: AppColors.hairline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.void_,
      canvasColor: AppColors.void_,
      textTheme: AppTypography.textTheme(),
      // No ripples anywhere: Material ink on an editorial layout is the fastest
      // way to make a custom design look like a default one.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.ash, size: 18),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.charcoal),
        thickness: WidgetStateProperty.all(4),
        radius: const Radius.circular(2),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.void_,
          border: Border.all(color: AppColors.hairline),
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: AppTypography.mono(color: AppColors.bone, fontSize: 11),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }
}
