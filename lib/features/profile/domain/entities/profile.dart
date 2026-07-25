import 'package:flutter/widgets.dart';

import 'social_link.dart';

/// A card in the about section describing how the work is built.
///
/// This replaced a set of headline numbers ("4 apps shipped"). Counts date
/// badly and invite comparison on volume; how the code is structured is the
/// actual claim being made.
@immutable
class ProfilePrinciple {
  const ProfilePrinciple({
    required this.icon,
    required this.title,
    required this.detail,
  });

  final IconData icon;
  final String title;
  final String detail;
}

/// Everything the hero, about, contact and footer sections render about you.
@immutable
class Profile {
  const Profile({
    required this.name,
    required this.role,
    required this.heroHeadline,
    required this.heroHighlight,
    required this.heroSubtitle,
    required this.bio,
    required this.location,
    required this.email,
    required this.stack,
    required this.principles,
    required this.socials,
    this.phone,
    this.cvUrl,
    this.avatarAsset,
  });

  final String name;

  /// Short professional title, e.g. "Flutter Developer".
  final String role;

  /// Hero heading, minus the gradient tail.
  final String heroHeadline;

  /// Tail of the hero heading, painted in the accent gradient.
  final String heroHighlight;

  final String heroSubtitle;

  /// About-section paragraphs. Rendered in order with spacing between.
  final List<String> bio;

  final String location;
  final String email;

  /// Technologies listed in the about section.
  final List<String> stack;

  final List<ProfilePrinciple> principles;
  final List<SocialLink> socials;

  final String? phone;

  /// Link to a hosted CV. The download button hides when this is null.
  final String? cvUrl;

  /// Portrait asset path. Null — or a path with no file behind it — falls back
  /// to an initials tile, so the site never shows a broken image.
  final String? avatarAsset;

  /// Initials for the avatar fallback.
  String get initials => name
      .trim()
      .split(RegExp(r'\s+'))
      .take(2)
      .where((String part) => part.isNotEmpty)
      .map((String part) => part.substring(0, 1).toUpperCase())
      .join();
}
