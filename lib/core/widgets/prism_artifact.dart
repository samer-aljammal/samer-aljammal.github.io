import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../scroll/scroll_visibility.dart';
import '../theme/app_colors.dart';

/// The signature brand object: a cluster of glass cubes whose edges split into
/// red, green and blue channels, drifting slowly.
///
/// This is the only chromatic element in the entire design, and it earns that
/// by behaving like light rather than paint. The colour comes from dispersion —
/// each cube's wireframe is drawn three times at slightly different offsets and
/// composited additively, so where the channels overlap they sum back to white
/// and where they separate they fringe into spectrum. That is genuinely how a
/// prism splits light, which is why it reads as physical instead of decorative.
///
/// Deliberately slow: a ~7s cycle you notice at the edge of vision, not an
/// animation that demands attention.
class PrismArtifact extends StatefulWidget {
  const PrismArtifact({this.opacity = 1.0, super.key});

  /// Overall strength. Below 1 when the artifact sits behind type.
  final double opacity;

  @override
  State<PrismArtifact> createState() => _PrismArtifactState();
}

class _PrismArtifactState extends State<PrismArtifact>
    with SingleTickerProviderStateMixin, ScrollVisibility {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    // The reference's named animation runs at 6.65s. Matching it keeps the
    // shimmer at the same unhurried cadence.
    duration: const Duration(milliseconds: 6650),
  );

  @override
  double get visibilityMargin => 200;

  @override
  double get visibilityThreshold => 0;

  @override
  void onVisibilityChanged(bool visible) {
    if (visible) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, _) => CustomPaint(
            // Without this the painter collapses to Size.zero whenever its
            // constraints are not tight — a child-less CustomPaint does not
            // expand on its own, and the result is a silently blank canvas.
            size: Size.infinite,
            painter: _PrismPainter(
              t: _controller.value,
              opacity: widget.opacity,
            ),
            isComplex: true,
            willChange: true,
          ),
        ),
      ),
    );
  }
}

/// One cube in the cluster: where it sits, how big, how fast it drifts.
typedef _Cube = ({double x, double y, double scale, double phase});

class _PrismPainter extends CustomPainter {
  const _PrismPainter({required this.t, required this.opacity});

  final double t;
  final double opacity;

  /// Staggered cluster rather than a grid — an even arrangement would read as
  /// a pattern instead of an object.
  static const List<_Cube> _cubes = [
    (x: 0.50, y: 0.44, scale: 1.00, phase: 0.0),
    (x: 0.26, y: 0.62, scale: 0.62, phase: 0.35),
    (x: 0.74, y: 0.30, scale: 0.55, phase: 0.68),
    (x: 0.70, y: 0.70, scale: 0.44, phase: 0.15),
    (x: 0.32, y: 0.26, scale: 0.38, phase: 0.82),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final double unit = size.shortestSide * 0.22;
    const double tau = math.pi * 2;

    // Additive layer: overlapping channels sum toward white, which is what
    // makes the centre of each edge read as a specular highlight.
    canvas.saveLayer(Offset.zero & size, Paint());

    for (final _Cube cube in _cubes) {
      final double phase = tau * (t + cube.phase);
      // Each cube drifts on its own slow lissajous path.
      final Offset centre = Offset(
        size.width * cube.x + math.sin(phase) * unit * 0.10,
        size.height * cube.y + math.cos(phase * 0.8) * unit * 0.08,
      );
      final double radius = unit * cube.scale;
      // Dispersion widens and narrows through the cycle, so the fringing
      // breathes instead of sitting at a fixed width.
      final double split =
          radius * 0.055 * (0.55 + 0.45 * math.sin(phase * 1.3));

      final Path path = _cubePath(centre, radius, phase * 0.12);

      for (int i = 0; i < AppColors.prism.length; i++) {
        final double angle = tau * i / AppColors.prism.length + phase * 0.5;
        final Offset offset = Offset(
          math.cos(angle) * split,
          math.sin(angle) * split,
        );

        canvas.save();
        canvas.translate(offset.dx, offset.dy);
        canvas.drawPath(
          path,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = math.max(1.0, radius * 0.018)
            ..blendMode = BlendMode.plus
            ..color = AppColors.prism[i].withValues(alpha: 0.62 * opacity),
        );
        canvas.restore();
      }

      // Bone-white core edge, drawn last so the object still reads as glass
      // rather than as three coloured outlines.
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(0.8, radius * 0.012)
          ..blendMode = BlendMode.plus
          ..color = AppColors.bone.withValues(alpha: 0.30 * opacity),
      );
    }

    canvas.restore();
  }

  /// An isometric cube: outer hexagon plus the three edges meeting at the
  /// centre vertex.
  Path _cubePath(Offset c, double r, double rotation) {
    final Path path = Path();
    final List<Offset> hex = List<Offset>.generate(6, (int i) {
      final double a = math.pi / 3 * i + math.pi / 6 + rotation;
      return Offset(c.dx + math.cos(a) * r, c.dy + math.sin(a) * r);
    });

    path.addPolygon(hex, true);
    for (final int i in const [1, 3, 5]) {
      path
        ..moveTo(c.dx, c.dy)
        ..lineTo(hex[i].dx, hex[i].dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(_PrismPainter old) =>
      old.t != t || old.opacity != opacity;
}
