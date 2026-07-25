import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Reports whether the host widget is inside (or near) the viewport of the
/// nearest enclosing [Scrollable].
///
/// This exists instead of a visibility-detector package because it is the only
/// behavior the site needs and it keeps the dependency list at two packages.
/// Two things depend on it: entrance animations (fire once on first sight) and
/// the phone mockups (pause their loop while offscreen, so eight simultaneous
/// scroll animations don't burn frames on content nobody is looking at).
mixin ScrollVisibility<T extends StatefulWidget> on State<T> {
  ScrollPosition? _position;
  bool _isVisible = false;

  /// How far beyond the viewport edge still counts as visible. Positive values
  /// activate content slightly before it scrolls into view.
  double get visibilityMargin => 0;

  /// Fraction of the viewport height the widget's top edge must cross before it
  /// counts as visible. 0 = the moment any part enters, 1 = the very top.
  double get visibilityThreshold => 0.12;

  bool get isVisible => _isVisible;

  /// Called only on transitions, never on every scroll frame.
  void onVisibilityChanged(bool visible);

  @override
  void initState() {
    super.initState();
    // The render object has no size until after the first frame.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _attach();
      _evaluate();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attach();
  }

  void _attach() {
    final ScrollPosition? next = Scrollable.maybeOf(context)?.position;
    if (next == _position) return;
    _position?.removeListener(_evaluate);
    _position = next?..addListener(_evaluate);
  }

  @override
  void dispose() {
    _position?.removeListener(_evaluate);
    _position = null;
    super.dispose();
  }

  void _evaluate() {
    if (!mounted) return;

    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    final double viewportHeight = MediaQuery.sizeOf(context).height;
    final double top = renderObject.localToGlobal(Offset.zero).dy;
    final double bottom = top + renderObject.size.height;

    final bool visible =
        top < viewportHeight * (1 - visibilityThreshold) + visibilityMargin &&
        bottom > -visibilityMargin;

    if (visible == _isVisible) return;
    _isVisible = visible;
    onVisibilityChanged(visible);
  }
}
