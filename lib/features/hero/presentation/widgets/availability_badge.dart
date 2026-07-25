import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Pill with a slowly pulsing dot, e.g. "Available for work".
class AvailabilityBadge extends StatefulWidget {
  const AvailabilityBadge({required this.label, super.key});

  final String label;

  @override
  State<AvailabilityBadge> createState() => _AvailabilityBadgeState();
}

class _AvailabilityBadgeState extends State<AvailabilityBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Only the dot repaints; the pill and its text stay static.
          RepaintBoundary(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, _) {
                final double t = Curves.easeInOut.transform(_controller.value);
                return Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(
                      AppColors.magenta,
                      AppColors.violet,
                      t,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.magenta.withValues(
                          alpha: 0.25 + 0.55 * t,
                        ),
                        blurRadius: 4 + 8 * t,
                        spreadRadius: 1 + 2 * t,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Text(
            widget.label,
            style: AppTypography.mono(
              fontSize: 12,
              letterSpacing: 1.2,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
