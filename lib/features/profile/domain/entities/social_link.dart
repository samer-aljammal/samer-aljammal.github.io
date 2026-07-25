import 'package:flutter/material.dart';

/// An outbound link rendered as an icon tile in the hero and footer.
@immutable
class SocialLink {
  const SocialLink({
    required this.label,
    required this.url,
    required this.icon,
  });

  final String label;
  final String url;
  final IconData icon;
}
