import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/scroll/scroll_visibility.dart';
import '../models/phone_screen.dart';
import 'placeholder_screen.dart';

/// The content inside the phone: a vertical reel of screens that dwells on each
/// one, then glides to the next, looping forever.
///
/// The loop pauses whenever the reel scrolls out of view. With five mockups on
/// the page, five always-running tickers would spend most of their frame budget
/// animating pixels nobody can see.
class ProjectScreenReel extends StatefulWidget {
  const ProjectScreenReel({required this.screens, super.key});

  /// Screens to cycle, in order. May span several projects — see
  /// [PhoneScreen.mixedAcross].
  final List<PhoneScreen> screens;

  @override
  State<ProjectScreenReel> createState() => _ProjectScreenReelState();
}

class _ProjectScreenReelState extends State<ProjectScreenReel>
    with SingleTickerProviderStateMixin, ScrollVisibility {
  late final AnimationController _controller = AnimationController(vsync: this);

  /// Fraction of each screen's time spent holding still before gliding on.
  static const double _dwellFraction = 0.62;

  /// Keep animating slightly beyond the viewport, so a screen is never caught
  /// mid-transition as it scrolls into view.
  @override
  double get visibilityMargin => 200;

  @override
  double get visibilityThreshold => 0;

  int get _screenCount => widget.screens.length;

  @override
  void initState() {
    super.initState();
    _controller.duration = AppMotion.phoneScrollPerScreen * _screenCount;
  }

  @override
  void didUpdateWidget(ProjectScreenReel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.screens.length != _screenCount) {
      _controller.duration = AppMotion.phoneScrollPerScreen * _screenCount;
    }
  }

  @override
  void onVisibilityChanged(bool visible) {
    if (visible) {
      // repeat() from a stopped controller resumes at its current value, so the
      // reel picks up exactly where it paused.
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

  /// Maps loop progress to a vertical offset in screens, holding on each screen
  /// before easing to the next.
  double _screenOffset(double progress) {
    final int count = _screenCount;
    final double position = progress * count;
    final int index = position.floor();
    final double local = position - index;

    if (local <= _dwellFraction) return index.toDouble();

    final double transition = (local - _dwellFraction) / (1 - _dwellFraction);
    return index + AppMotion.emphasized.transform(transition);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.screens.isEmpty) return const SizedBox.shrink();

    final List<Widget> screens = [
      for (final PhoneScreen screen in widget.screens) _buildScreen(screen),
    ];

    return ClipRect(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double screenHeight = constraints.maxHeight;

          return AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) {
              final double travel =
                  _screenOffset(_controller.value) * screenHeight;

              // Positioned children rather than a translated Column: a Column
              // taller than its parent overflows (and screams about it in
              // debug) even when the parent clips it.
              return Stack(
                children: [
                  // One extra pass repeats the first screen at the end. When the
                  // controller wraps from 1 back to 0 the frame is identical, so
                  // the loop has no visible snap-back.
                  for (int i = 0; i <= screens.length; i++)
                    Positioned(
                      top: i * screenHeight - travel,
                      left: 0,
                      right: 0,
                      height: screenHeight,
                      child: screens[i % screens.length],
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildScreen(PhoneScreen screen) {
    final String? path = screen.imagePath;
    if (path == null) return _placeholder(screen);

    return Image.asset(
      path,
      fit: BoxFit.cover,
      filterQuality: FilterQuality.medium,
      // A typo'd or missing asset path degrades to the placeholder instead of
      // showing a broken-image box on a live portfolio.
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
        debugPrint('Missing project screenshot: $path');
        return _placeholder(screen);
      },
    );
  }

  Widget _placeholder(PhoneScreen screen) => PlaceholderScreen(
    accent: screen.accent,
    projectName: screen.label,
    variant: screen.placeholderVariant,
  );
}
