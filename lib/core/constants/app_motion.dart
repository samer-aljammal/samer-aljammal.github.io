import 'package:flutter/animation.dart';

/// Motion vocabulary.
///
/// The rule this design follows: motion is frequent but quiet. Hover feedback
/// is near-instant (150ms), entrances are slow and travel a short distance, and
/// nothing bounces, pulses or glows. Elastic curves and long springs are what
/// make a page feel generated; a tight ease-out feels engineered.
abstract final class AppMotion {
  const AppMotion._();

  /// Hover and focus feedback. Anything slower feels laggy on a cursor.
  static const Duration hover = Duration(milliseconds: 150);

  /// Standard state change.
  static const Duration base = Duration(milliseconds: 280);

  /// Entrance of a revealed element.
  static const Duration enter = Duration(milliseconds: 720);

  /// Smooth scroll to a section.
  static const Duration navigate = Duration(milliseconds: 900);

  /// Delay between lines in a headline reveal, and between sibling cards.
  static const Duration stagger = Duration(milliseconds: 70);

  /// One full pass of the technology marquee.
  static const Duration marquee = Duration(seconds: 38);

  /// Dwell on one screen inside a phone mockup before it advances.
  static const Duration phoneScrollPerScreen = Duration(milliseconds: 2600);

  /// Standard easing — decelerate into place, never overshoot.
  static const Curve ease = Curves.easeOutCubic;

  /// Stronger deceleration for large travel (headline lines, section blocks).
  static const Curve easeStrong = Curves.easeOutQuint;
}
