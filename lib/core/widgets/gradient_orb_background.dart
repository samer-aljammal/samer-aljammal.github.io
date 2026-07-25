import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../theme/app_colors.dart';

/// Slow-drifting colored glows behind the whole page.
///
/// Painted as radial gradients rather than blurred layers: a real blur filter on
/// a full-viewport surface costs several milliseconds per frame on Flutter web,
/// and at this softness the two are visually indistinguishable.
class GradientOrbBackground extends StatefulWidget {
  const GradientOrbBackground({this.child, super.key});

  final Widget? child;

  @override
  State<GradientOrbBackground> createState() => _GradientOrbBackgroundState();
}

class _GradientOrbBackgroundState extends State<GradientOrbBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.ambient,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Isolated so the ticking background never repaints the page content.
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) => CustomPaint(
              painter: _OrbPainter(_controller.value),
              isComplex: true,
              willChange: true,
            ),
          ),
        ),
        if (widget.child case final Widget child) child,
      ],
    );
  }
}

class _OrbPainter extends CustomPainter {
  const _OrbPainter(this.t);

  /// Loop progress, 0..1.
  final double t;

  /// Relative size, drift extent and cycle speed for each orb.
  static const List<({double radius, double spread, double fx, double fy})>
  _orbs = [
    (radius: 0.55, spread: 0.30, fx: 1, fy: 0.75),
    (radius: 0.45, spread: 0.35, fx: 0.8, fy: 1.25),
    (radius: 0.60, spread: 0.22, fx: 1.4, fy: 0.5),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = AppColors.background,
    );

    final double diagonal = size.shortestSide;
    const double tau = math.pi * 2;

    for (int i = 0; i < _orbs.length; i++) {
      final orb = _orbs[i];
      final Color color = AppColors.orbs[i % AppColors.orbs.length];
      final double phase = tau * i / _orbs.length;

      // Lissajous drift: two out-of-phase sines never retrace the same path,
      // so the movement reads as organic rather than as a circling loop.
      final Offset center = Offset(
        size.width * (0.5 + orb.spread * math.sin(tau * t * orb.fx + phase)),
        size.height *
            (0.42 + orb.spread * 0.7 * math.cos(tau * t * orb.fy + phase)),
      );
      final double radius = diagonal * orb.radius;

      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              color.withValues(alpha: 0.20),
              color.withValues(alpha: 0.06),
              color.withValues(alpha: 0),
            ],
            stops: const [0, 0.45, 1],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    // Vignette: pulls focus to the center column and keeps text legible over
    // whichever orb happens to be passing behind it.
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = RadialGradient(
          colors: [
            AppColors.background.withValues(alpha: 0),
            AppColors.background.withValues(alpha: 0.55),
          ],
          stops: const [0.5, 1],
          radius: 0.9,
        ).createShader(Offset.zero & size),
    );
  }

  @override
  bool shouldRepaint(_OrbPainter oldDelegate) => oldDelegate.t != t;
}
