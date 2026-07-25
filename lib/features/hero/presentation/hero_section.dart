import 'package:flutter/material.dart';

import '../../../core/constants/app_motion.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/link_launcher.dart';
import '../../../core/widgets/glow_button.dart';
import '../../../core/widgets/highlighted_text.dart';
import '../../../core/widgets/reveal_on_scroll.dart';
import '../../../core/widgets/section_shell.dart';
import '../../profile/domain/entities/profile.dart';
import '../../profile/presentation/widgets/social_row.dart';
import '../../projects/presentation/models/phone_screen.dart';
import '../../projects/presentation/widgets/tilting_phone_mockup.dart';
import 'widgets/availability_badge.dart';
import 'widgets/scroll_cue.dart';

/// Above-the-fold introduction, with the featured project already animating in
/// a phone beside the copy.
class HeroSection extends StatelessWidget {
  const HeroSection({
    required this.profile,
    required this.showcaseScreens,
    required this.onViewWork,
    required this.onContact,
    super.key,
  });

  final Profile profile;

  /// Screens cycled by the hero mockup — a shuffled mix across every project,
  /// so the first thing a visitor sees is the range of work, not one app.
  final List<PhoneScreen> showcaseScreens;

  final VoidCallback onViewWork;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final bool wide = context.isWide;

    return SectionShell(
      topSpacing: context.responsive<double>(
        mobile: 112,
        tablet: 124,
        desktop: 128,
      ),
      bottomSpacing: context.responsive<double>(
        mobile: 40,
        tablet: 52,
        desktop: 56,
      ),
      child: ConstrainedBox(
        // Fills the first viewport on desktop without forcing a fixed height
        // that could clip the copy on short windows.
        constraints: BoxConstraints(
          minHeight: wide ? context.screen.height * 0.66 : 0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (wide)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 7,
                    child: _Copy(
                      profile: profile,
                      onViewWork: onViewWork,
                      onContact: onContact,
                    ),
                  ),
                  const SizedBox(width: 48),
                  Expanded(flex: 5, child: _Mockup(screens: showcaseScreens)),
                ],
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Copy(
                    profile: profile,
                    onViewWork: onViewWork,
                    onContact: onContact,
                  ),
                  const SizedBox(height: 64),
                  _Mockup(screens: showcaseScreens),
                ],
              ),
            if (wide) ...[
              const SizedBox(height: 56),
              const RevealOnScroll(
                delay: Duration(milliseconds: 900),
                child: ScrollCue(),
              ),
            ],
          ],
        ),
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
    final TextTheme text = Theme.of(context).textTheme;
    final TextStyle? headlineStyle = context.responsive(
      mobile: text.displayMedium?.copyWith(fontSize: 40),
      tablet: text.displayMedium,
      desktop: text.displayLarge,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: AvailabilityBadge(label: 'Available for work'),
        ),
        const SizedBox(height: 28),

        // Headline is revealed as one block: splitting it per-line makes the
        // most important text on the page arrive in pieces.
        RevealOnScroll(
          delay: AppMotion.stagger,
          child: HighlightedText(
            text: profile.heroHeadline,
            highlight: profile.heroHighlight,
            style: headlineStyle,
          ),
        ),
        const SizedBox(height: 26),

        RevealOnScroll(
          delay: AppMotion.stagger * 2,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              profile.heroSubtitle,
              style: text.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ),
        const SizedBox(height: 40),

        RevealOnScroll(
          delay: AppMotion.stagger * 3,
          child: Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              GlowButton(
                label: 'View my work',
                icon: Icons.arrow_downward_rounded,
                onPressed: onViewWork,
              ),
              GlowButton(
                label: 'Get in touch',
                icon: Icons.arrow_outward_rounded,
                variant: GlowButtonVariant.ghost,
                onPressed: onContact,
              ),
              if (profile.cvUrl case final String cvUrl)
                GlowButton(
                  label: 'Download CV',
                  icon: Icons.download_rounded,
                  variant: GlowButtonVariant.ghost,
                  onPressed: () => LinkLauncher.open(cvUrl),
                ),
            ],
          ),
        ),
        const SizedBox(height: 40),

        RevealOnScroll(
          delay: AppMotion.stagger * 4,
          child: SocialRow(links: profile.socials),
        ),
      ],
    );
  }
}

class _Mockup extends StatelessWidget {
  const _Mockup({required this.screens});

  final List<PhoneScreen> screens;

  @override
  Widget build(BuildContext context) {
    return RevealOnScroll(
      delay: AppMotion.stagger * 3,
      offset: const Offset(0, 0.08),
      child: Align(
        alignment: context.isWide ? Alignment.center : Alignment.topCenter,
        child: TiltingPhoneMockup(
          screens: screens,
          width: context.responsive<double>(
            mobile: 232,
            tablet: 262,
            desktop: 292,
          ),
        ),
      ),
    );
  }
}
