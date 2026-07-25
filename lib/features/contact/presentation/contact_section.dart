import 'package:flutter/material.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/link_launcher.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/glow_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/hover_region.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/section_title.dart';
import '../../profile/domain/entities/profile.dart';
import '../../profile/presentation/widgets/social_row.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return SectionShell(
      bottomSpacing: context.responsive(mobile: 72, tablet: 96, desktop: 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: '03 — Contact',
            title: 'Have something worth',
            highlight: 'building?',
          ),
          const SizedBox(height: 48),

          RevealOnScroll(
            child: GlassCard(
              padding: EdgeInsets.all(context.responsive(mobile: 26, tablet: 40)),
              borderRadius: 26,
              child: context.isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 6, child: _Pitch(profile: profile)),
                        const SizedBox(width: 48),
                        Expanded(flex: 5, child: _Channels(profile: profile)),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _Pitch(profile: profile),
                        const SizedBox(height: 40),
                        _Channels(profile: profile),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 40),
          RevealOnScroll(
            child: Text(
              'Prefer a different channel?',
              style: text.bodySmall?.copyWith(color: AppColors.textTertiary),
            ),
          ),
          const SizedBox(height: 14),
          RevealOnScroll(child: SocialRow(links: profile.socials)),
        ],
      ),
    );
  }
}

class _Pitch extends StatelessWidget {
  const _Pitch({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          'Let us talk.',
          style: context.responsive(
            mobile: text.headlineMedium,
            desktop: text.headlineLarge,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'I am open to full-time roles, contract work and freelance Flutter '
          'projects. Tell me what you are building and what is in your way — '
          'I answer every message.',
          style: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 30),
        GlowButton(
          label: 'Email me',
          icon: Icons.arrow_outward_rounded,
          onPressed: () => LinkLauncher.email(
            profile.email,
            subject: 'Project enquiry — ${profile.name}',
          ),
        ),
      ],
    );
  }
}

class _Channels extends StatelessWidget {
  const _Channels({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _ChannelRow(
          icon: Icons.alternate_email_rounded,
          label: 'Email',
          value: profile.email,
          onTap: () => LinkLauncher.email(profile.email),
        ),
        if (profile.phone case final String phone)
          _ChannelRow(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: phone,
            onTap: () => LinkLauncher.phone(phone),
          ),
        _ChannelRow(
          icon: Icons.place_outlined,
          label: 'Location',
          value: profile.location,
        ),
      ],
    );
  }
}

class _ChannelRow extends StatelessWidget {
  const _ChannelRow({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;

  /// Null for informational rows, which then render without hover affordance.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: hovered && onTap != null
                ? AppColors.violet.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: hovered && onTap != null
                    ? AppColors.magenta
                    : AppColors.violet,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: text.bodySmall?.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                AnimatedOpacity(
                  opacity: hovered ? 1 : 0,
                  duration: const Duration(milliseconds: 160),
                  child: const Icon(
                    Icons.arrow_outward_rounded,
                    size: 15,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
