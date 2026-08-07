import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Hairline pill with a small status dot — "Available for work".
///
/// The dot is the one place a status color is allowed. It does not pulse: a
/// blinking indicator on a portfolio is decoration pretending to be data.
class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 9),
          Text(
            label,
            style: AppTypography.mono(fontSize: 12, color: AppColors.ash),
          ),
        ],
      ),
    );
  }
}
