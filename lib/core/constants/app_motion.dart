import 'package:flutter/animation.dart';

/// Every duration and curve in the app, in one place.
///
/// Motion only feels designed when it's consistent, so widgets never invent
/// their own timings — they pick a role from here.
abstract final class AppMotion {
  const AppMotion._();

  /// Hover/press feedback. Must feel instantaneous.
  static const Duration fast = Duration(milliseconds: 180);

  /// Standard state change: color, elevation, layout nudge.
  static const Duration medium = Duration(milliseconds: 320);

  /// Entrance animations for revealed content.
  static const Duration slow = Duration(milliseconds: 620);

  /// Scroll-to-section.
  static const Duration navigate = Duration(milliseconds: 850);

  /// One full loop of a screenshot column inside the phone frame, per screen.
  static const Duration phoneScrollPerScreen = Duration(milliseconds: 2600);

  /// One full cycle of the ambient background orbs. Deliberately very long so
  /// the movement is felt rather than watched.
  static const Duration ambient = Duration(seconds: 34);

  /// Delay between siblings in a staggered reveal.
  static const Duration stagger = Duration(milliseconds: 90);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve emphasized = Curves.easeOutQuint;
  static const Curve spring = Curves.elasticOut;
}
