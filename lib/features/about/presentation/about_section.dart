import 'package:flutter/material.dart';

import '../../../core/constants/app_motion.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../core/widgets/section_shell.dart';
import '../../profile/domain/entities/profile.dart';
import '../../profile/presentation/widgets/profile_portrait.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      // The one slate band on the page. Sitting between the hero and the work,
      // it breaks the canvas into three tonal zones so the scroll has rhythm
      // instead of running as a single unbroken dark field.
      band: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeading(
            index: '01',
            label: 'About',
            lines: ['Clean, fast, and', 'always improving.'],
          ),
          SizedBox(height: context.responsive<double>(mobile: 56, desktop: 72)),

          if (context.isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 4, child: ProfilePortrait(profile: profile)),
                const SizedBox(width: 72),
                Expanded(flex: 7, child: _Body(profile: profile)),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfilePortrait(profile: profile),
                const SizedBox(height: 48),
                _Body(profile: profile),
              ],
            ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Lead paragraph set larger than the rest: an editorial convention that
        // gives the block a clear entry point.
        ...RevealOnScroll.staggered([
          for (final (int i, String paragraph) in profile.bio.indexed)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                paragraph,
                style: i == 0
                    ? text.bodyLarge?.copyWith(color: AppColors.bone)
                    : text.bodyMedium?.copyWith(color: AppColors.fog),
              ),
            ),
        ], step: AppMotion.stagger),

        const SizedBox(height: 44),
        const Divider(height: 1),
        const SizedBox(height: 36),

        ...RevealOnScroll.staggered([
          for (final ProfilePrinciple principle in profile.principles)
            Padding(
              padding: const EdgeInsets.only(bottom: 28),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 132,
                    child: Text(
                      principle.title.toUpperCase(),
                      style: AppTypography.label(color: AppColors.fog),
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      principle.detail,
                      style: text.bodySmall?.copyWith(color: AppColors.fog),
                    ),
                  ),
                ],
              ),
            ),
        ], step: AppMotion.stagger),
      ],
    );
  }
}
