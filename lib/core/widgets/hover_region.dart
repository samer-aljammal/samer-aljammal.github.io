import 'package:flutter/widgets.dart';

/// Rebuilds [builder] with the current hover state.
///
/// Saves every interactive widget from hand-rolling its own [MouseRegion] plus
/// a `_hovered` field and `setState` pair.
class HoverRegion extends StatefulWidget {
  const HoverRegion({
    required this.builder,
    this.onTap,
    this.cursor = SystemMouseCursors.click,
    this.onPositionChanged,
    super.key,
  });

  final Widget Function(BuildContext context, bool hovered) builder;
  final VoidCallback? onTap;
  final MouseCursor cursor;

  /// Local pointer position, normalized to -1..1 on both axes with (0,0) at the
  /// widget's center. Used by the phone mockup to derive its tilt.
  final ValueChanged<Offset>? onPositionChanged;

  @override
  State<HoverRegion> createState() => _HoverRegionState();
}

class _HoverRegionState extends State<HoverRegion> {
  bool _hovered = false;

  void _setHovered(bool value) {
    if (_hovered == value) return;
    setState(() => _hovered = value);
  }

  void _report(PointerEvent event) {
    final ValueChanged<Offset>? callback = widget.onPositionChanged;
    if (callback == null) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final Size size = renderObject.size;
    final Offset local = renderObject.globalToLocal(event.position);
    callback(
      Offset(
        (local.dx / size.width * 2 - 1).clamp(-1, 1),
        (local.dy / size.height * 2 - 1).clamp(-1, 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = MouseRegion(
      cursor: widget.onTap == null ? MouseCursor.defer : widget.cursor,
      onEnter: (event) {
        _setHovered(true);
        _report(event);
      },
      onHover: _report,
      onExit: (_) {
        _setHovered(false);
        widget.onPositionChanged?.call(Offset.zero);
      },
      child: widget.builder(context, _hovered),
    );

    if (widget.onTap == null) return child;
    return GestureDetector(onTap: widget.onTap, child: child);
  }
}
