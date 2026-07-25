import 'package:flutter/widgets.dart';

import '../constants/app_motion.dart';
import '../scroll/scroll_visibility.dart';

/// Fades and lifts [child] into place the first time it scrolls into view.
///
/// Fires once and stays revealed — re-animating on every pass makes a long page
/// feel restless, and scrolling back up to watch content rebuild reads as jank.
class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    required this.child,
    this.delay = Duration.zero,
    this.offset = const Offset(0, 0.16),
    this.duration = AppMotion.slow,
    super.key,
  });

  final Widget child;

  /// Stagger offset for siblings. See [RevealOnScroll.staggered].
  final Duration delay;

  /// Starting displacement, as a fraction of the child's own size.
  final Offset offset;

  final Duration duration;

  /// Wraps each of [children] in a reveal, delayed by its index, so a row or
  /// column of cards resolves one after another instead of all at once.
  static List<Widget> staggered(
    List<Widget> children, {
    Duration step = AppMotion.stagger,
    Offset offset = const Offset(0, 0.16),
  }) => List<Widget>.generate(
    children.length,
    (int i) => RevealOnScroll(
      delay: step * i,
      offset: offset,
      child: children[i],
    ),
  );

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll>
    with ScrollVisibility {
  bool _revealed = false;

  @override
  void onVisibilityChanged(bool visible) {
    if (!visible || _revealed) return;

    if (widget.delay == Duration.zero) {
      setState(() => _revealed = true);
      return;
    }
    Future<void>.delayed(widget.delay, () {
      if (mounted) setState(() => _revealed = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: _revealed ? Offset.zero : widget.offset,
      duration: widget.duration,
      curve: AppMotion.emphasized,
      child: AnimatedOpacity(
        opacity: _revealed ? 1 : 0,
        duration: widget.duration,
        curve: AppMotion.enter,
        child: widget.child,
      ),
    );
  }
}
