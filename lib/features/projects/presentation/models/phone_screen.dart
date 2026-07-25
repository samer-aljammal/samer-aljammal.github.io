import 'dart:math';

import 'package:flutter/material.dart';

import '../../domain/entities/project.dart';

/// One screen inside a phone mockup.
///
/// The reel is built from these rather than from a [Project] directly, so a
/// mockup can show screens from several apps at once — which is what the hero
/// does, cycling a shuffled mix of all four rather than only the first one.
@immutable
class PhoneScreen {
  const PhoneScreen({
    required this.accent,
    required this.label,
    this.imagePath,
    this.placeholderVariant = 0,
  });

  /// The owning project's brand color, used by placeholder screens.
  final Color accent;

  /// Project name. Only surfaces on placeholder screens.
  final String label;

  /// Asset path, or null to draw a generated placeholder instead.
  final String? imagePath;

  /// Which placeholder layout to draw when [imagePath] is null.
  final int placeholderVariant;

  /// Every screen belonging to one project, in authored order.
  static List<PhoneScreen> forProject(Project project) {
    if (!project.hasScreenshots) {
      return List<PhoneScreen>.generate(
        3,
        (int i) => PhoneScreen(
          accent: project.accent,
          label: project.name,
          placeholderVariant: i,
        ),
      );
    }

    return [
      for (final String path in project.screenshots)
        PhoneScreen(
          accent: project.accent,
          label: project.name,
          imagePath: path,
        ),
    ];
  }

  /// A shuffled sample drawn from every project.
  ///
  /// Samples per project first, then shuffles the result, so all four apps are
  /// guaranteed to appear — a flat shuffle across the whole pool could easily
  /// deal four screens from the same app. [random] is injectable so tests get a
  /// deterministic order; in the app it reshuffles on every page load.
  static List<PhoneScreen> mixedAcross(
    List<Project> projects, {
    int perProject = 2,
    Random? random,
  }) {
    final Random rng = random ?? Random();
    final List<PhoneScreen> mixed = [];

    for (final Project project in projects) {
      final List<PhoneScreen> screens = forProject(project)..shuffle(rng);
      mixed.addAll(screens.take(perProject));
    }

    return mixed..shuffle(rng);
  }
}
