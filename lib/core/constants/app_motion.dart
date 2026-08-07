import 'package:flutter/animation.dart';

/// Motion vocabulary.
///
/// The rule this design follows: motion is frequent but quiet. Hover feedback
/// is near-instant (150ms), entrances are slow and travel a short distance, and
/// nothing bounces, pulses or glows. Elastic curves and long springs are what
/// make a page feel generated; a tight ease-out feels engineered.
abstract final class AppMotion {
  const AppMotion._();

  /// Hover and focus feedback. Kept well under the 500ms house duration —
  /// a cursor state that takes half a second to answer feels broken.
  static const Duration hover = Duration(milliseconds: 220);

  /// The house duration. Most state changes run at this.
  static const Duration base = Duration(milliseconds: 500);

  /// Entrance of a revealed element.
  static const Duration enter = Duration(milliseconds: 800);

  /// Smooth scroll to a section.
  static const Duration navigate = Duration(milliseconds: 900);

  /// Delay between lines in a headline reveal, and between sibling cards.
  static const Duration stagger = Duration(milliseconds: 70);

  /// One full pass of the technology marquee.
  static const Duration marquee = Duration(seconds: 38);

  /// Dwell on one screen inside a phone mockup before it advances.
  static const Duration phoneScrollPerScreen = Duration(milliseconds: 2600);

  /// The signature curve, and the reason the motion reads as expensive: a
  /// slow start that then commits and stops decisively, like a lens pulling
  /// focus. Springs and bounces are explicitly rejected — confidence reads
  /// through stillness, not overshoot.
  static const Curve ease = Cubic(0.52, 0.01, 0, 1);

  /// Same character, applied to large travel (headline lines, section blocks).
  static const Curve easeStrong = Cubic(0.52, 0.01, 0, 1);
}
