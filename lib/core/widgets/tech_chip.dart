import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Small monospace pill for a technology name.
class TechChip extends StatelessWidget {
  const TechChip(this.label, {this.dense = false, super.key});

  final String label;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.fast,
      padding: EdgeInsets.symmetric(
        horizontal: dense ? 9 : 12,
        vertical: dense ? 5 : 7,
      ),
      decoration: BoxDecoration(
        color: AppColors.violet.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.violet.withValues(alpha: 0.22)),
      ),
      child: Text(
        label,
        style: AppTypography.mono(
          fontSize: dense ? 11 : 12,
          color: AppColors.textPrimary.withValues(alpha: 0.85),
        ),
      ),
    );
  }
}
