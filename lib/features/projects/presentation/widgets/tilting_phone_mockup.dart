import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/widgets/hover_region.dart';
import '../../domain/entities/project.dart';
import '../models/phone_screen.dart';
import 'device_frame.dart';
import 'project_screen_reel.dart';

/// A phone mockup that tilts in 3D toward the cursor, with a reel of screens
/// looping inside it.
///
/// The tilt is interpolated rather than tracked frame-for-frame: following the
/// pointer exactly feels twitchy, while easing toward the target reads as an
/// object with weight. Rotation is the entire effect — no glow, no scale pop.
class TiltingPhoneMockup extends StatefulWidget {
  const TiltingPhoneMockup({
    required this.screens,
    required this.width,
    super.key,
  });

  /// Shows one project's own screens.
  TiltingPhoneMockup.project({
    required Project project,
    required this.width,
    super.key,
  }) : screens = PhoneScreen.forProject(project);

  final List<PhoneScreen> screens;
  final double width;

  @override
  State<TiltingPhoneMockup> createState() => _TiltingPhoneMockupState();
}

class _TiltingPhoneMockupState extends State<TiltingPhoneMockup> {
  /// Pointer position normalised to -1..1, or zero when not hovered.
  Offset _pointer = Offset.zero;

  /// Max rotation per axis in radians (~6°). Past roughly 10° the perspective
  /// distortion starts making the screenshots hard to read.
  static const double _maxTilt = 0.11;
  static const double _perspective = 0.0011;

  void _onPointerChanged(Offset position) {
    if (position == _pointer) return;
    setState(() => _pointer = position);
  }

  @override
  Widget build(BuildContext context) {
    final bool allPlaceholders = widget.screens.every(
      (PhoneScreen s) => s.imagePath == null,
    );

    return HoverRegion(
      onPositionChanged: _onPointerChanged,
      builder: (BuildContext context, bool hovered) {
        return TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(end: _pointer),
          duration: AppMotion.base,
          curve: AppMotion.ease,
          builder: (BuildContext context, Offset tilt, Widget? child) {
            // Hover drives a lift and a small scale alongside the tilt. Tilt
            // alone is easy to miss when the cursor enters near the centre,
            // where the rotation is close to zero — the lift makes the device
            // acknowledge the pointer wherever it arrives.
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(end: hovered ? 1 : 0),
              duration: AppMotion.base,
              curve: AppMotion.ease,
              builder: (BuildContext context, double lift, Widget? inner) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, _perspective)
                    ..translateByDouble(0, -12 * lift, 0, 1)
                    ..rotateX(-tilt.dy * _maxTilt)
                    ..rotateY(tilt.dx * _maxTilt)
                    ..scaleByDouble(
                      1 + 0.03 * lift,
                      1 + 0.03 * lift,
                      1,
                      1,
                    ),
                  child: inner,
                );
              },
              child: child,
            );
          },
          // Built once and passed through the builder: the reel runs on its own
          // ticker and must not rebuild when the tilt changes.
          child: RepaintBoundary(
            child: DeviceFrame(
              width: widget.width,
              showIsland: allPlaceholders,
              screen: ProjectScreenReel(screens: widget.screens),
            ),
          ),
        );
      },
    );
  }
}
