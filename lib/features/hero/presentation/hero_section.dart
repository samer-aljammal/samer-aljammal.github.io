import 'package:flutter/material.dart';

import '../../../core/constants/app_motion.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/utils/link_launcher.dart';
import '../../../core/widgets/ghost_button.dart';
import '../../../core/widgets/line_reveal.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import '../../../core/widgets/section_shell.dart';
import '../../profile/domain/entities/profile.dart';
import '../../projects/presentation/models/phone_screen.dart';
import '../../projects/presentation/widgets/tilting_phone_mockup.dart';
import 'widgets/status_pill.dart';

/// Above the fold: an editorial serif statement, a mono sub-line, two ghost
/// actions, and the work already moving in a device beside it.
///
/// No gradient wash, no glow, no illustration — the type and the product are
/// the only things on the canvas.
class HeroSection extends StatelessWidget {
  const HeroSection({
    required this.profile,
    required this.showcaseScreens,
    required this.onViewWork,
    required this.onContact,
    super.key,
  });

  final Profile profile;
  final List<PhoneScreen> showcaseScreens;
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final bool wide = context.isWide;

    return SectionShell(
      topSpacing: context.responsive<double>(
        mobile: 132,
        tablet: 150,
        desktop: 168,
      ),
      bottomSpacing: context.responsive<double>(
        mobile: 72,
        tablet: 88,
        desktop: 104,
      ),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(flex: 7, child: _Copy(profile: profile, onViewWork: onViewWork, onContact: onContact)),
                const SizedBox(width: 56),
                Expanded(
                  flex: 4,
                  child: Center(child: _Device(screens: showcaseScreens)),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Copy(
                  profile: profile,
                  onViewWork: onViewWork,
                  onContact: onContact,
                ),
                const SizedBox(height: 72),
                Center(child: _Device(screens: showcaseScreens)),
              ],
            ),
    );
  }
}

class _Copy extends StatelessWidget {
  const _Copy({
    required this.profile,
    required this.onViewWork,
    required this.onContact,
  });

  final Profile profile;
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final double displaySize = context.responsive<double>(
      mobile: 46,
      tablet: 64,
      desktop: 82,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const RevealOnScroll(child: StatusPill(label: 'Available for work')),
        const SizedBox(height: 32),

        // Line breaks are authored, not wrapped: the mask needs to know where
        // they are, and a hand-set break is what makes the headline scan.
        LineReveal(
          lines: profile.heroLines,
          style: AppTypography.display(fontSize: displaySize, height: 1.04),
        ),
        const SizedBox(height: 28),

        RevealOnScroll(
          delay: const Duration(milliseconds: 220),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              profile.heroSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.ash),
            ),
          ),
        ),
        const SizedBox(height: 40),

        RevealOnScroll(
          delay: const Duration(milliseconds: 300),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              GhostButton(
                label: 'View work',
                icon: Icons.arrow_downward,
                emphasis: true,
                onPressed: onViewWork,
              ),
              GhostButton(label: 'Get in touch', onPressed: onContact),
              if (profile.cvUrl case final String cvUrl)
                GhostButton(
                  label: 'CV',
                  icon: Icons.arrow_outward,
                  onPressed: () => LinkLauncher.open(cvUrl),
                ),
            ],
          ),
        ),
        const SizedBox(height: 44),

        RevealOnScroll(
          delay: const Duration(milliseconds: 380),
          // Wrap, not Row: on a narrow phone the role and location together
          // exceed the viewport, and a meta line is exactly the kind of thing
          // that should fold onto a second line rather than clip.
          child: Wrap(
            spacing: 14,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                profile.role.toUpperCase(),
                style: AppTypography.label(color: AppColors.iron),
              ),
              Container(width: 28, height: 1, color: AppColors.hairline),
              Text(
                profile.location.toUpperCase(),
                style: AppTypography.label(color: AppColors.iron),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Device extends StatelessWidget {
  const _Device({required this.screens});

  final List<PhoneScreen> screens;

  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      delay: AppMotion.stagger * 4,
      offset: const Offset(0, 0.06),
      child: TiltingPhoneMockup(
        screens: screens,
        width: context.responsive<double>(
          mobile: 220,
          tablet: 248,
          desktop: 268,
        ),
      ),
    );
  }
}
