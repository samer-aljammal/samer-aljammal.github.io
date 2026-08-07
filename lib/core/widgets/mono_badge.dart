import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Monospace pill for a technology name or metadata value.
///
/// 6px radius, hairline border, no fill. The mono face is what makes a list of
/// technologies read as a developer's page rather than a marketing one.
class MonoBadge extends StatelessWidget {
  const MonoBadge(this.label, {this.accent = false, super.key});

  final String label;

  /// Renders the label in the brand violet. Reserved for identifiers that
  /// behave like code — never applied to every badge in a row.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.ashBorder),
      ),
      child: Text(
        label,
        style: AppTypography.sans(
          fontSize: 12,
          color: accent ? AppColors.bone : AppColors.fog,
        ),
      ),
    );
  }
}
