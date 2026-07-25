import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/hover_region.dart';
import '../../domain/entities/project.dart';
import '../models/phone_screen.dart';
import 'device_frame.dart';
import 'project_screen_reel.dart';

/// A phone mockup that tilts in 3D toward the cursor and brightens on hover,
/// with a reel of screens looping inside it.
///
/// The tilt is interpolated rather than applied raw: following the pointer
/// frame-for-frame feels twitchy, while easing toward the target reads as a
/// physical object with weight.
class TiltingPhoneMockup extends StatefulWidget {
  const TiltingPhoneMockup({
    required this.screens,
    required this.width,
    this.glowColor = AppColors.violet,
    super.key,
  });

  /// Shows a single project's own screens.
  TiltingPhoneMockup.project({
    required Project project,
    required this.width,
    super.key,
  }) : screens = PhoneScreen.forProject(project),
       glowColor = project.accent;

  /// Screens to cycle through.
  final List<PhoneScreen> screens;

  final double width;

  /// Ambient glow behind the device. A single project's mockup uses its brand
  /// color; a mixed reel keeps the site violet, since the glow would otherwise
  /// have to lurch between four brand colors mid-loop.
  final Color glowColor;

  @override
  State<TiltingPhoneMockup> createState() => _TiltingPhoneMockupState();
}

class _TiltingPhoneMockupState extends State<TiltingPhoneMockup> {
  /// Pointer position normalized to -1..1, or [Offset.zero] when not hovered.
  Offset _pointer = Offset.zero;

  /// Maximum rotation on each axis, in radians (~7°). Past roughly 10° the
  /// perspective distortion starts to make the screenshots hard to read.
  static const double _maxTilt = 0.125;

  /// Perspective depth. Smaller values flatten the effect.
  static const double _perspective = 0.0011;

  void _onPointerChanged(Offset position) {
    if (position == _pointer) return;
    setState(() => _pointer = position);
  }

  @override
  Widget build(BuildContext context) {
    // The island is only drawn over generated placeholders. Real screenshots
    // have had their OS status bar cropped, so the app's own header sits at the
    // very top of the screen and the island would land on it.
    final bool allPlaceholders = widget.screens.every(
      (PhoneScreen screen) => screen.imagePath == null,
    );

    return HoverRegion(
      onPositionChanged: _onPointerChanged,
      builder: (BuildContext context, bool hovered) {
        return TweenAnimationBuilder<Offset>(
          tween: Tween<Offset>(end: _pointer),
          duration: AppMotion.medium,
          curve: AppMotion.enter,
          builder: (BuildContext context, Offset tilt, Widget? child) {
            return TweenAnimationBuilder<double>(
              tween: Tween<double>(end: hovered ? 1.15 : 0.5),
              duration: AppMotion.medium,
              curve: AppMotion.enter,
              builder: (BuildContext context, double glow, _) {
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, _perspective)
                    ..rotateX(-tilt.dy * _maxTilt)
                    ..rotateY(tilt.dx * _maxTilt)
                    // Lifts very slightly under the cursor, reinforcing that
                    // the object is being picked up rather than just skewed.
                    ..scaleByDouble(
                      hovered ? 1.02 : 1.0,
                      hovered ? 1.02 : 1.0,
                      1,
                      1,
                    ),
                  child: DeviceFrame(
                    width: widget.width,
                    glowColor: widget.glowColor,
                    glowStrength: glow,
                    showIsland: allPlaceholders,
                    screen: child!,
                  ),
                );
              },
            );
          },
          // Built once and passed down through both builders: the reel animates
          // on its own ticker and must not be rebuilt by tilt or glow changes.
          child: RepaintBoundary(
            child: ProjectScreenReel(screens: widget.screens),
          ),
        );
      },
    );
  }
}
