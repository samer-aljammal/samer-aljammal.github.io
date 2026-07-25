import 'package:flutter/material.dart';

import '../../../core/constants/app_motion.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import '../../../core/widgets/section_shell.dart';
import '../../../core/widgets/section_title.dart';
import '../../../core/widgets/tech_chip.dart';
import '../../profile/domain/entities/profile.dart';
import '../../profile/presentation/widgets/profile_avatar.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(
            eyebrow: '01 — About',
            title: 'Clean, fast, and always',
            highlight: 'improving.',
          ),
          const SizedBox(height: 56),

          if (context.isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: _Bio(profile: profile)),
                const SizedBox(width: 64),
                Expanded(flex: 4, child: _Principles(profile: profile)),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bio(profile: profile),
                const SizedBox(height: 48),
                _Principles(profile: profile),
              ],
            ),

          const SizedBox(height: 64),
          _Stack(profile: profile),
        ],
      ),
    );
  }
}

class _Bio extends StatelessWidget {
  const _Bio({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = Theme.of(context).textTheme.bodyLarge?.copyWith(
      color: AppColors.textSecondary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: RevealOnScroll.staggered([
        for (final String paragraph in profile.bio)
          Padding(
            // Tighter than a prose paragraph gap: these are single sentences
            // meant to read as a short stack, not as body copy.
            padding: const EdgeInsets.only(bottom: 15),
            child: Text(paragraph, style: style),
          ),
      ]),
    );
  }
}

class _Principles extends StatelessWidget {
  const _Principles({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: RevealOnScroll.staggered([
        Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Align(
            alignment: context.isWide
                ? Alignment.centerLeft
                : Alignment.topCenter,
            child: ProfileAvatar(
              profile: profile,
              size: context.responsive<double>(mobile: 168, desktop: 196),
            ),
          ),
        ),
        for (final ProfilePrinciple principle in profile.principles)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              interactive: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.violet.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.violet.withValues(alpha: 0.22),
                          ),
                        ),
                        child: Icon(
                          principle.icon,
                          size: 17,
                          color: AppColors.violet,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(principle.title, style: text.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    principle.detail,
                    style: text.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              const Icon(
                Icons.place_outlined,
                size: 18,
                color: AppColors.violet,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  profile.location,
                  style: text.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ], step: AppMotion.stagger),
    );
  }
}

class _Stack extends StatelessWidget {
  const _Stack({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WHAT I WORK WITH',
            style: AppTypography.mono(
              fontSize: 11,
              letterSpacing: 2.4,
              color: AppColors.textTertiary,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final String item in profile.stack) TechChip(item),
            ],
          ),
        ],
      ),
    );
  }
}
