import 'package:flutter/material.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/link_launcher.dart';
import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/hover_region.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../core/widgets/section_shell.dart';
import '../../profile/domain/entities/profile.dart';
import '../../profile/domain/entities/social_link.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      bottomSpacing: context.responsive<double>(mobile: 88, desktop: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            index: '03',
            label: 'Contact',
            lines: ['Have something', 'worth building?'],
          ),
          SizedBox(height: context.responsive<double>(mobile: 48, desktop: 64)),

          RevealOnScroll(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                'Open to full-time roles, contract work and freelance Flutter '
                'projects. Tell me what you are building and what is in the '
                'way — I answer every message.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.fog),
              ),
            ),
          ),
          const SizedBox(height: 40),

          RevealOnScroll(
            delay: const Duration(milliseconds: 120),
            child: GhostButton(
              label: 'Email me',
              icon: Icons.arrow_outward,
              emphasis: true,
              onPressed: () => LinkLauncher.email(
                profile.email,
                subject: 'Project enquiry',
              ),
            ),
          ),

          const SizedBox(height: 64),
          // A definition list rather than cards: keys in mono on the left,
          // values as links. Reads like documentation, which is the identity.
          _Row(
            label: 'EMAIL',
            value: profile.email,
            onTap: () => LinkLauncher.email(profile.email),
          ),
          if (profile.phone case final String phone)
            _Row(
              label: 'PHONE',
              value: phone,
              onTap: () => LinkLauncher.phone(phone),
            ),
          _Row(label: 'LOCATION', value: profile.location),
          for (final SocialLink link in profile.socials)
            if (!link.url.startsWith('mailto:'))
              _Row(
                label: link.label.toUpperCase(),
                value: link.url.replaceFirst(RegExp(r'^https?://(www\.)?'), ''),
                onTap: () => LinkLauncher.open(link.url),
              ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      child: HoverRegion(
        onTap: onTap,
        builder: (BuildContext context, bool hovered) => Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.ashBorder)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              SizedBox(
                width: context.responsive<double>(mobile: 96, desktop: 140),
                child: Text(label, style: AppTypography.label()),
              ),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 150),
                  style: AppTypography.sans(
                    fontSize: 14,
                    color: onTap == null
                        ? AppColors.fog
                        : (hovered ? AppColors.bone : AppColors.bone),
                  ),
                  child: Text(value),
                ),
              ),
              if (onTap != null)
                AnimatedSlide(
                  offset: Offset(hovered ? 0.25 : 0, hovered ? -0.25 : 0),
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    Icons.arrow_outward,
                    size: 14,
                    color: hovered ? AppColors.bone : AppColors.ashBorder,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
