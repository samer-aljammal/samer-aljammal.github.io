import 'dart:async';

import 'package:flutter/widgets.dart';

import '../constants/app_motion.dart';
import '../scroll/scroll_visibility.dart';

/// A headline that rises line by line from behind a mask.
///
/// This is the signature motion of the page. Each line is clipped to its own
/// box and translated up from below, so the text appears to be revealed by the
/// layout rather than faded in on top of it — the difference between a page
/// that animates and a page that just has animations.
///
/// Lines are authored explicitly rather than wrapped automatically: a mask has
/// to know where the breaks are, and hand-set breaks are what make an editorial
/// headline scan properly anyway.
class LineReveal extends StatefulWidget {
  const LineReveal({
    required this.lines,
    required this.style,
    this.textAlign = TextAlign.start,
    this.delay = Duration.zero,
    super.key,
  });

  final List<String> lines;
  final TextStyle style;
  final TextAlign textAlign;
  final Duration delay;

  @override
  State<LineReveal> createState() => _LineRevealState();
}

class _LineRevealState extends State<LineReveal>
    with SingleTickerProviderStateMixin, ScrollVisibility {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration:
        AppMotion.enter + (AppMotion.stagger * (widget.lines.length - 1)),
  );

  bool _started = false;

  /// Cancellable, so a pending delay does not outlive the widget tree.
  Timer? _delayTimer;

  @override
  double get visibilityThreshold => 0.05;

  @override
  void onVisibilityChanged(bool visible) {
    if (!visible || _started) return;
    _started = true;
    if (widget.delay == Duration.zero) {
      _controller.forward();
      return;
    }
    _delayTimer = Timer(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double fontSize = widget.style.fontSize ?? 16;
    final double lineHeight = fontSize * (widget.style.height ?? 1.1);
    final int count = widget.lines.length;

    return Column(
      crossAxisAlignment: widget.textAlign == TextAlign.center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < count; i++)
          AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, Widget? child) {
              // Each line gets its own slice of the timeline, so they arrive in
              // sequence off a single controller.
              final double start = count == 1 ? 0 : (i / count) * 0.45;
              final double t = AppMotion.easeStrong.transform(
                ((_controller.value - start) / (1 - start)).clamp(0.0, 1.0),
              );

              return ClipRect(
                child: SizedBox(
                  // Slightly taller than the line box so descenders and the
                  // serif's overshoot are not shaved off by the clip.
                  height: lineHeight * 1.18,
                  child: Transform.translate(
                    offset: Offset(0, lineHeight * (1 - t)),
                    child: Opacity(opacity: t, child: child),
                  ),
                ),
              );
            },
            child: Text(
              widget.lines[i],
              style: widget.style,
              textAlign: widget.textAlign,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
            ),
          ),
      ],
    );
  }
}
