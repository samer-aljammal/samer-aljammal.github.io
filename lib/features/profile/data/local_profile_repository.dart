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
    role: 'Mobile App Developer',

    // Three short lines: each is masked and revealed separately, and each must
    // fit the hero column on one line at the desktop display size.
    heroLines: ['I build mobile', 'apps that feel', 'effortless.'],
    heroSubtitle:
        'Flutter developer. Clean, layered codebases that stay easy to change '
        '— and interfaces that hold their shape on every screen size.',

    // Your words, unedited. Split into three entries so each sentence gets its
    // own line and the section stays airy rather than becoming a paragraph.
    bio: [
      'I’m a Flutter Developer passionate about building modern, responsive, '
          'and high-performance mobile applications.',
      'I enjoy creating clean, intuitive user experiences with smooth '
          'animations and scalable architecture.',
      'I’m always learning new technologies and continuously improving my '
          'skills by building real-world projects.',
    ],

    location: 'Damascus, Syria',
    email: 'samerjmml@gmail.com',

    // Local Syrian format. Consider '+963 983 896 568' if you want recruiters
    // outside Syria to be able to dial it straight from the page.
    phone: '0983896568',

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

    // Firebase and clean architecture are taken from your own repo
    // descriptions. TODO(you): add the specific state-management library
    // (Bloc / Riverpod / Provider) — your repos say "state management" without
    // naming it.
    stack: [
      'Flutter',
      'Dart',
      'Clean Architecture',
      'Firebase',
      'State management',
      'REST APIs',
      'Localization',
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
      // TODO(you): uncomment once you have a LinkedIn profile to point at.
      // SocialLink(
      //   label: 'LinkedIn',
      //   url: 'https://www.linkedin.com/in/<your-handle>',
      //   icon: Icons.work_outline_rounded,
      // ),
    ],
  );
}
