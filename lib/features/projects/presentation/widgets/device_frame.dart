import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A phone chassis drawn in Dart: black body, hairline rim, side buttons.
///
/// Deliberately undecorated. The previous version cast a large colored glow,
/// which is the effect that made the whole page read as generated — here the
/// device is a matte black object separated from a black canvas by a 1px rim,
/// exactly like every other surface in the design.
class DeviceFrame extends StatelessWidget {
  const DeviceFrame({
    required this.screen,
    required this.width,
    this.showIsland = true,
    super.key,
  });

  final Widget screen;
  final double width;

  /// Draw the dynamic-island cutout. Off for real screenshots, whose OS status
  /// bar has been cropped so the app's own header sits at the very top.
  final bool showIsland;

  static const double aspectRatio = 19.5 / 9;

  double get height => width * aspectRatio;

  @override
  Widget build(BuildContext context) {
    final double bezel = width * 0.028;
    final double radius = width * 0.155;
    final double buttonWidth = width * 0.011;

    return SizedBox(
      width: width + buttonWidth * 2,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _SideButton(
            alignment: Alignment.centerLeft,
            width: buttonWidth,
            top: height * 0.21,
            length: height * 0.05,
          ),
          _SideButton(
            alignment: Alignment.centerLeft,
            width: buttonWidth,
            top: height * 0.29,
            length: height * 0.08,
          ),
          _SideButton(
            alignment: Alignment.centerRight,
            width: buttonWidth,
            top: height * 0.24,
            length: height * 0.10,
          ),
          Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.void_,
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(color: AppColors.hairline, width: 1),
            ),
            padding: EdgeInsets.all(bezel),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(radius - bezel),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  screen,
                  if (showIsland)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.012),
                        child: Container(
                          width: width * 0.26,
                          height: width * 0.078,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(width),
                          ),
                        ),
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
              color: AppColors.hairline,
              borderRadius: BorderRadius.circular(width),
            ),
          ),
        ),
      ),
    );
  }
}
