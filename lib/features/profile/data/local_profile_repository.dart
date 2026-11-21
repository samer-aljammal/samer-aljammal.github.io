import 'package:flutter/material.dart';

import '../domain/entities/profile.dart';
import '../domain/entities/social_link.dart';
import '../domain/repositories/profile_repository.dart';

/// Hardcoded site content — edit your copy, links and numbers here.
///
/// Values marked TODO could not be verified. The site renders correctly with
/// them as they are, but they should be corrected before you deploy. The two
/// commented-out socials are left out on purpose: a live portfolio linking to a
/// placeholder profile is worse than one that links only to email.
class LocalProfileRepository implements ProfileRepository {
  const LocalProfileRepository();

  @override
  Profile getProfile() => const Profile(
    name: 'Samer Aljammal',
    role: 'Flutter Developer',

    // Three short lines: each is masked and revealed separately, and each must
    // fit the hero column on one line at the desktop display size.
    heroLines: ['I build mobile', 'apps that feel', 'effortless.'],
    heroSubtitle:
        'Flutter developer in Damascus. I build tested, layered apps — '
        'including the order app my own business runs on every day.',

    // Concrete on purpose: recruiters skim past "passionate developer" lines,
    // so every sentence names something real they can check below or on
    // GitHub. Keep it in step with the summary in cv/cv.html.
    bio: [
      'I’m a Flutter developer building Android, iOS and web apps with BLoC, '
          'Clean Architecture, Supabase and Firebase.',
      'I run a small gift studio, Rasael, on an order app I built — so my '
          'code has real customers, real payments and a phone it has to work '
          'on every morning.',
      'I write tests for the logic that matters, keep CI on my recent '
          'projects, and build Arabic right-to-left interfaces as a native '
          'speaker. I’m studying Communications Engineering alongside.',
    ],

    location: 'Damascus, Syria',
    email: 'samerjmml@gmail.com',

    // International format so recruiters outside Syria can dial it directly.
    phone: '+963 983 896 568',

    // Drop your photo at this path and it appears in the about section. Until
    // then it falls back to an initials tile, so nothing breaks.
    avatarAsset: 'assets/profile/avatar.jpg',

    // Served from this site's own domain: the file lives at
    // web/Samer_Aljammal_CV.pdf, and Flutter copies web/ verbatim into the
    // build output. Hosting it here rather than on Drive or Dropbox means no
    // permission prompt and no expiring link between a recruiter and the CV.
    //
    // Must be absolute — the launcher opens it as an external target, so a bare
    // relative path would not resolve. Null hides the download button.
    cvUrl: 'https://samer-aljammal.github.io/Samer_Aljammal_CV.pdf',

    // Kept in step with the Skills section of cv/cv.html.
    stack: [
      'Flutter',
      'Dart',
      'BLoC',
      'Clean Architecture',
      'Supabase',
      'Firebase',
      'Drift (SQLite)',
      'REST APIs',
      'Arabic RTL',
      'Testing',
      'Git',
    ],

    principles: [
      ProfilePrinciple(
        icon: Icons.layers_outlined,
        title: 'Feature-first structure',
        detail: 'Separate layers. Nothing reaches across a boundary it owns.',
      ),
      ProfilePrinciple(
        icon: Icons.devices_outlined,
        title: 'Responsive by default',
        detail: 'Phone to desktop, not a phone screen stretched to fit.',
      ),
      ProfilePrinciple(
        icon: Icons.auto_stories_outlined,
        title: 'Written to be read',
        detail: 'Small widgets, predictable naming, no duplicated logic.',
      ),
    ],

    socials: [
      SocialLink(
        label: 'GitHub',
        url: 'https://github.com/samer-aljammal',
        icon: Icons.code_rounded,
      ),
      SocialLink(
        label: 'Email',
        url: 'mailto:samerjmml@gmail.com',
        icon: Icons.alternate_email_rounded,
      ),
      SocialLink(
        label: 'LinkedIn',
        url: 'https://www.linkedin.com/in/samer-aljammal',
        icon: Icons.work_outline_rounded,
      ),
    ],
  );
}
