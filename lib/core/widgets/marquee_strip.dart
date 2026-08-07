import 'package:flutter/material.dart';

import '../constants/app_motion.dart';
import '../scroll/scroll_visibility.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// A continuously scrolling row of labels, bounded by hairlines.
///
/// Gives the page persistent motion without animating anything that carries
/// meaning. Both edges fade into the black canvas so the strip reads as
/// infinite rather than as a list that happens to be moving.
class MarqueeStrip extends StatefulWidget {
  const MarqueeStrip({
    required this.items,
    this.height = 64,
    super.key,
  });

  final List<String> items;
  final double height;

  @override
  State<MarqueeStrip> createState() => _MarqueeStripState();
}

class _MarqueeStripState extends State<MarqueeStrip>
    with SingleTickerProviderStateMixin, ScrollVisibility {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppMotion.marquee,
  );

  @override
  double get visibilityMargin => 120;

  @override
  double get visibilityThreshold => 0;

  @override
  void onVisibilityChanged(bool visible) {
    // Never burn frames scrolling text nobody can see.
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
    return SizedBox(
      height: widget.height,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.ashBorder),
            bottom: BorderSide(color: AppColors.ashBorder),
          ),
        ),
        child: ClipRect(
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (Rect bounds) => const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0x00000000),
                Color(0xFF000000),
                Color(0xFF000000),
                Color(0x00000000),
              ],
              stops: [0, 0.12, 0.88, 1],
            ).createShader(bounds),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    return _MarqueeRow(
                      progress: _controller.value,
                      items: widget.items,
                      viewportWidth: constraints.maxWidth,
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _MarqueeRow extends StatelessWidget {
  const _MarqueeRow({
    required this.progress,
    required this.items,
    required this.viewportWidth,
  });

  final double progress;
  final List<String> items;
  final double viewportWidth;

  static const double _itemWidth = 190;

  @override
  Widget build(BuildContext context) {
    final double runWidth = items.length * _itemWidth;
    // Enough copies to cover the viewport plus one full run, so the seam is
    // always off-screen no matter how wide the window is.
    final int copies = (viewportWidth / runWidth).ceil() + 1;
    final double offset = -progress * runWidth;

    // The row is deliberately wider than the viewport. OverflowBox hands it
    // unbounded width so it lays out at its natural size instead of reporting
    // an overflow — the ClipRect above is what keeps it inside the strip.
    return OverflowBox(
      maxWidth: double.infinity,
      alignment: Alignment.centerLeft,
      child: Transform.translate(
        offset: Offset(offset, 0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          for (int c = 0; c < copies + 1; c++)
            for (final String item in items)
              SizedBox(
                width: _itemWidth,
                child: Row(
                  children: [
                    // Expanded rather than a fixed Text plus Spacer: the label
                    // then shrinks to fit its slot instead of overflowing it,
                    // whatever the rendered font metrics turn out to be.
                    Expanded(
                      child: Text(
                        item,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.sans(
                          fontSize: 13,
                          color: AppColors.fog,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 3,
                      height: 3,
                      decoration: const BoxDecoration(
                        color: AppColors.ashBorder,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 24),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
