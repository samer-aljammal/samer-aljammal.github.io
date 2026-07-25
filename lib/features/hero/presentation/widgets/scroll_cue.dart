import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// "Scroll" hint with a bar that slides down a track, repeating.
class ScrollCue extends StatefulWidget {
  const ScrollCue({super.key});

  @override
  State<ScrollCue> createState() => _ScrollCueState();
}

class _ScrollCueState extends State<ScrollCue>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat();

  static const double _trackHeight = 42;
  static const double _barHeight = 14;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 1,
          height: _trackHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(color: AppColors.border),
            child: RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (BuildContext context, _) {
                  final double t = _controller.value;
                  return Align(
                    // Travels the full track, fading out at both ends so the
                    // restart is never visible as a jump.
                    alignment: Alignment(0, -1 + 2 * t),
                    child: Opacity(
                      opacity: (1 - (t - 0.5).abs() * 2).clamp(0.0, 1.0),
                      child: Container(
                        width: 1,
                        height: _barHeight,
                        decoration: const BoxDecoration(
                          gradient: AppColors.accent,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'SCROLL',
          style: AppTypography.mono(
            fontSize: 10,
            letterSpacing: 3,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
