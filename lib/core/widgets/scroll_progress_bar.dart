import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A 1.5px violet rule across the top of the viewport tracking read position.
///
/// One of the few places the accent is allowed on a wide element, because it
/// reports state rather than decorating. Isolated behind a repaint boundary so
/// scrolling repaints the rule and nothing else.
class ScrollProgressBar extends StatelessWidget {
  const ScrollProgressBar({required this.controller, super.key});

  final ScrollController controller;

  static const double _thickness = 1.5;

  @override
  Widget build(BuildContext context) {
    // Height is fixed and the width comes from LayoutBuilder rather than a
    // FractionallySizedBox: this widget is placed in a Stack with no bottom
    // constraint, where a self-sizing child has no bounds to resolve against.
    return SizedBox(
      height: _thickness,
      child: RepaintBoundary(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? child) {
                double progress = 0;
                if (controller.hasClients &&
                    controller.positions.length == 1) {
                  final double max = controller.position.maxScrollExtent;
                  if (max > 0) {
                    progress = (controller.offset / max).clamp(0.0, 1.0);
                  }
                }

                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: constraints.maxWidth * progress,
                    height: _thickness,
                    color: AppColors.bone,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
