import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

/// A generated, app-like screen used when a project has no screenshots yet.
///
/// Deliberately abstract — blocked-out shapes rather than fake text — so it
/// reads as a design placeholder rather than as a real screen you shipped.
/// Three variants keep a looping reel from repeating the same frame.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({
    required this.accent,
    required this.projectName,
    required this.variant,
    super.key,
  });

  final Color accent;
  final String projectName;

  /// Which layout to draw. Any int is valid; it wraps.
  final int variant;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.lerp(const Color(0xFF120C22), accent, 0.22)!,
            const Color(0xFF0A0714),
          ],
        ),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // Everything scales off screen width so the placeholder looks correct
          // at any mockup size.
          final double unit = constraints.maxWidth / 100;

          return Padding(
            padding: EdgeInsets.fromLTRB(unit * 7, unit * 12, unit * 7, unit * 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _StatusBar(unit: unit),
                SizedBox(height: unit * 7),
                _Bar(width: unit * 46, height: unit * 5, color: Colors.white70),
                SizedBox(height: unit * 3),
                _Bar(width: unit * 28, height: unit * 3, color: Colors.white24),
                SizedBox(height: unit * 8),
                Expanded(child: _body(unit)),
                SizedBox(height: unit * 5),
                _NavBar(unit: unit, accent: accent),
                SizedBox(height: unit * 3),
                Center(
                  child: Text(
                    projectName.toUpperCase(),
                    style: AppTypography.mono(
                      fontSize: unit * 2.6,
                      color: Colors.white24,
                      letterSpacing: unit * 0.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _body(double unit) => switch (variant % 3) {
    0 => _ListLayout(unit: unit, accent: accent),
    1 => _GridLayout(unit: unit, accent: accent),
    _ => _DetailLayout(unit: unit, accent: accent),
  };
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.unit});

  final double unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Bar(width: unit * 9, height: unit * 2.4, color: Colors.white38),
        const Spacer(),
        _Bar(width: unit * 5, height: unit * 2.4, color: Colors.white24),
        SizedBox(width: unit * 1.5),
        _Bar(width: unit * 7, height: unit * 2.4, color: Colors.white24),
      ],
    );
  }
}

class _ListLayout extends StatelessWidget {
  const _ListLayout({required this.unit, required this.accent});

  final double unit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(4, (int i) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: unit * 3.5),
            child: _Panel(
              unit: unit,
              accent: accent,
              // The first row reads as "selected", which gives the frame a
              // focal point instead of a flat stack.
              emphasized: i == 0,
              child: Row(
                children: [
                  Container(
                    width: unit * 16,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: i == 0 ? 0.45 : 0.18),
                      borderRadius: BorderRadius.circular(unit * 2.5),
                    ),
                  ),
                  SizedBox(width: unit * 4),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Bar(
                          width: unit * 34,
                          height: unit * 3,
                          color: Colors.white54,
                        ),
                        SizedBox(height: unit * 2.4),
                        _Bar(
                          width: unit * 22,
                          height: unit * 2.4,
                          color: Colors.white24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _GridLayout extends StatelessWidget {
  const _GridLayout({required this.unit, required this.accent});

  final double unit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: unit * 3.5,
      crossAxisSpacing: unit * 3.5,
      childAspectRatio: 0.82,
      children: List<Widget>.generate(6, (int i) {
        return _Panel(
          unit: unit,
          accent: accent,
          emphasized: i == 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.10 + (i % 3) * 0.09),
                    borderRadius: BorderRadius.circular(unit * 2),
                  ),
                ),
              ),
              SizedBox(height: unit * 2.5),
              _Bar(width: unit * 20, height: unit * 2.6, color: Colors.white38),
            ],
          ),
        );
      }),
    );
  }
}

class _DetailLayout extends StatelessWidget {
  const _DetailLayout({required this.unit, required this.accent});

  final double unit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  accent.withValues(alpha: 0.55),
                  accent.withValues(alpha: 0.12),
                ],
              ),
              borderRadius: BorderRadius.circular(unit * 4),
            ),
          ),
        ),
        SizedBox(height: unit * 4),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Bar(width: unit * 52, height: unit * 3, color: Colors.white38),
              SizedBox(height: unit * 2.6),
              _Bar(width: unit * 44, height: unit * 2.6, color: Colors.white24),
              SizedBox(height: unit * 2.6),
              _Bar(width: unit * 48, height: unit * 2.6, color: Colors.white24),
              const Spacer(),
              Container(
                width: double.infinity,
                height: unit * 11,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.75),
                  borderRadius: BorderRadius.circular(unit * 3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({required this.unit, required this.accent});

  final double unit;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(4, (int i) {
        return Container(
          width: unit * 7,
          height: unit * 7,
          decoration: BoxDecoration(
            color: i == 0
                ? accent.withValues(alpha: 0.85)
                : Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(unit * 2),
          ),
        );
      }),
    );
  }
}

/// Rounded surface used for every card in the placeholder layouts.
class _Panel extends StatelessWidget {
  const _Panel({
    required this.unit,
    required this.accent,
    required this.child,
    this.emphasized = false,
  });

  final double unit;
  final Color accent;
  final Widget child;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(unit * 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: emphasized ? 0.09 : 0.05),
        borderRadius: BorderRadius.circular(unit * 3.5),
        border: Border.all(
          color: emphasized
              ? accent.withValues(alpha: 0.45)
              : Colors.white.withValues(alpha: 0.07),
        ),
      ),
      child: child,
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.width,
    required this.height,
    required this.color,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.withValues(alpha: color.a * 0.5),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
