import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A phone chassis drawn entirely in Dart — bezel, dynamic-island cutout, side
/// buttons and a glass reflection — wrapping an arbitrary [screen] widget.
///
/// Drawn rather than imported as a mockup PNG for two reasons: the screen
/// content stays live (it can scroll, animate and respond to hover), and it
/// scales to any width without a second asset.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({
    required this.screen,
    required this.width,
    this.glowColor = AppColors.violet,
    this.glowStrength = 1,
    this.showIsland = true,
    super.key,
  });

  final Widget screen;
  final double width;
  final Color glowColor;

  /// 0 = flat, 1 = full ambient glow. Driven by hover state.
  final double glowStrength;

  /// Whether to draw the dynamic-island cutout.
  ///
  /// Off for real screenshots: those have had their OS status bar cropped, so
  /// the app's own header now sits at the very top of the screen and the island
  /// would land on it — over a centered logo, in some of them. Placeholder
  /// screens leave room for it deliberately.
  final bool showIsland;

  /// Modern phone proportions (~9:19.5).
  static const double aspectRatio = 19.5 / 9;

  double get height => width * aspectRatio;

  @override
  Widget build(BuildContext context) {
    final double bezel = width * 0.030;
    final double outerRadius = width * 0.155;
    final double buttonWidth = width * 0.012;

    return SizedBox(
      width: width + buttonWidth * 2,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Side buttons sit behind the body so their inner edge is hidden.
          _SideButton(
            alignment: Alignment.centerLeft,
            width: buttonWidth,
            top: height * 0.20,
            length: height * 0.045,
          ),
          _SideButton(
            alignment: Alignment.centerLeft,
            width: buttonWidth,
            top: height * 0.28,
            length: height * 0.075,
          ),
          _SideButton(
            alignment: Alignment.centerRight,
            width: buttonWidth,
            top: height * 0.24,
            length: height * 0.095,
          ),

          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.bezel,
              borderRadius: BorderRadius.circular(outerRadius),
              // A lit rim on the top-left edge reads as a metal chamfer.
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.55),
                  blurRadius: 40,
                  offset: const Offset(0, 24),
                ),
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.30 * glowStrength),
                  blurRadius: 70 * glowStrength,
                  spreadRadius: 6 * glowStrength,
                ),
              ],
            ),
            padding: EdgeInsets.all(bezel),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(outerRadius - bezel),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  screen,
                  const _ScreenReflection(),
                  if (showIsland)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.012),
                        child: _DynamicIsland(width: width * 0.28),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideButton extends StatelessWidget {
  const _SideButton({
    required this.alignment,
    required this.width,
    required this.top,
    required this.length,
  });

  final Alignment alignment;
  final double width;
  final double top;
  final double length;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.only(top: top),
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: width,
            height: length,
            decoration: BoxDecoration(
              color: const Color(0xFF1B1626),
              borderRadius: BorderRadius.circular(width),
            ),
          ),
        ),
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width * 0.30,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(width),
      ),
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: width * 0.09),
      // Camera lens: a faint colored ring, like light catching the glass.
      child: Container(
        width: width * 0.13,
        height: width * 0.13,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0D0A18),
          border: Border.all(
            color: AppColors.violet.withValues(alpha: 0.35),
            width: 0.8,
          ),
        ),
      ),
    );
  }
}

/// Diagonal sheen across the glass. Ignores pointers so it never intercepts
/// hover events meant for the screen beneath it.
class _ScreenReflection extends StatelessWidget {
  const _ScreenReflection();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.10),
              Colors.white.withValues(alpha: 0.02),
              Colors.transparent,
              Colors.transparent,
            ],
            stops: const [0, 0.18, 0.42, 1],
          ),
        ),
      ),
    );
  }
}
