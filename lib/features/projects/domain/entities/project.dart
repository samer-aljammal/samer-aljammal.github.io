import 'package:flutter/material.dart';

/// One portfolio project, including the screens shown inside the phone mockup.
@immutable
class Project {
  const Project({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.tech,
    required this.accent,
    this.highlights = const [],
    this.screenshots = const [],
    this.repoUrl,
    this.liveUrl,
    this.storeUrl,
    this.isCollaboration = false,
  });

  /// Stable slug. Also the screenshot filename prefix.
  final String id;

  final String name;

  /// One line, shown under the name.
  final String tagline;

  final String description;

  final List<String> tech;

  /// Tints this project's phone glow and placeholder screens, so consecutive
  /// projects don't read as identical blocks.
  final Color accent;

  /// Short "what I actually built" bullets.
  final List<String> highlights;

  /// Asset paths, in display order. Empty means the mockup falls back to a
  /// generated placeholder screen — the site still builds and looks intentional
  /// before any real screenshots exist.
  final List<String> screenshots;

  final String? repoUrl;
  final String? liveUrl;
  final String? storeUrl;

  /// Built with others rather than solo. Surfaces as a badge next to the name,
  /// so a shared project is never implicitly claimed as individual work.
  final bool isCollaboration;

  bool get hasScreenshots => screenshots.isNotEmpty;

  bool get hasLinks => repoUrl != null || liveUrl != null || storeUrl != null;
}
