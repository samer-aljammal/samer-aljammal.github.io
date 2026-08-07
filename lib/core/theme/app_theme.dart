import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  const AppTheme._();

  static ThemeData dark() {
    const ColorScheme scheme = ColorScheme.dark(
      primary: AppColors.bone,
      onPrimary: AppColors.obsidian,
      secondary: AppColors.bone,
      onSecondary: AppColors.bone,
      surface: AppColors.obsidian,
      onSurface: AppColors.bone,
      outline: AppColors.ashBorder,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.obsidian,
      canvasColor: AppColors.obsidian,
      textTheme: AppTypography.textTheme(),
      // No ripples anywhere: Material ink on an editorial layout is the fastest
      // way to make a custom design look like a default one.
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      dividerTheme: const DividerThemeData(
        color: AppColors.ashBorder,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.fog, size: 18),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(AppColors.ashBorder),
        thickness: WidgetStateProperty.all(4),
        radius: const Radius.circular(2),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.obsidian,
          border: Border.all(color: AppColors.ashBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: AppTypography.sans(color: AppColors.bone, fontSize: 11),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      ),
    );
  }
}
