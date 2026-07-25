import 'package:flutter/widgets.dart';

import '../responsive/breakpoints.dart';

/// Standard section wrapper: full-bleed background, centered content column
/// capped at [Breakpoints.maxContentWidth], responsive gutters and rhythm.
///
/// Every section uses this, which is what keeps the left edge of all text
/// aligned down the entire page.
class SectionShell extends StatelessWidget {
  const SectionShell({
    required this.child,
    this.topSpacing,
    this.bottomSpacing,
    super.key,
  });

  final Widget child;
  final double? topSpacing;
  final double? bottomSpacing;

  @override
  Widget build(BuildContext context) {
    final double rhythm = context.sectionSpacing;

    return Padding(
      padding: EdgeInsets.only(
        left: context.gutter,
        right: context.gutter,
        top: topSpacing ?? rhythm,
        bottom: bottomSpacing ?? rhythm,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Breakpoints.maxContentWidth,
          ),
          child: child,
        ),
      ),
    );
  }
}
