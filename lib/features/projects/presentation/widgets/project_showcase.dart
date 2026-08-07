import 'package:flutter/material.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/link_launcher.dart';
import '../../../../core/widgets/mono_badge.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../core/widgets/underline_link.dart';
import '../../domain/entities/project.dart';
import 'tilting_phone_mockup.dart';

/// One project, laid out as an editorial spread: a numbered hairline rule, an
/// oversized serif title, mono metadata, and the live device alongside.
///
/// Sides alternate down the page so the eye zig-zags rather than scanning a
/// column of identical cards — the layout does the work that a card border and
/// a drop shadow used to.
class ProjectShowcase extends StatelessWidget {
  const ProjectShowcase({
    required this.project,
    required this.index,
    super.key,
  });

  final Project project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool deviceRight = index.isEven;
    final Widget device = _Device(project: project);
    final Widget details = _Details(project: project, index: index);

    if (!context.isWide) {
      return RevealOnScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            details,
            const SizedBox(height: 48),
            Center(child: device),
          ],
        ),
      );
    }

    return RevealOnScroll(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: deviceRight
            ? [
                Expanded(flex: 7, child: details),
                const SizedBox(width: 64),
                Expanded(flex: 4, child: Center(child: device)),
              ]
            : [
                Expanded(flex: 4, child: Center(child: device)),
                const SizedBox(width: 64),
                Expanded(flex: 7, child: details),
              ],
      ),
    );
  }
}

class _Device extends StatelessWidget {
  const _Device({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return TiltingPhoneMockup.project(
      project: project,
      width: context.responsive<double>(
        mobile: 208,
        tablet: 236,
        desktop: 252,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.project, required this.index});

  final Project project;
  final int index;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final double titleSize = context.responsive<double>(
      mobile: 38,
      tablet: 46,
      desktop: 54,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              (index + 1).toString().padLeft(2, '0'),
              style: AppTypography.label(color: AppColors.iron),
            ),
            const SizedBox(width: 16),
            const Expanded(child: Divider(height: 1)),
            if (project.isCollaboration) ...[
              const SizedBox(width: 16),
              Text(
                'COLLABORATION',
                style: AppTypography.label(color: AppColors.iris),
              ),
            ],
          ],
        ),
        const SizedBox(height: 22),

        Text(
          project.name,
          style: AppTypography.display(fontSize: titleSize, height: 1.05),
        ),
        const SizedBox(height: 10),
        Text(
          project.tagline,
          style: AppTypography.mono(fontSize: 13, color: AppColors.smoke),
        ),
        const SizedBox(height: 24),

        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 540),
          child: Text(
            project.description,
            style: text.bodyMedium?.copyWith(color: AppColors.ash),
          ),
        ),

        if (project.highlights.isNotEmpty) ...[
          const SizedBox(height: 28),
          for (final String highlight in project.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // A mono arrow rather than a colored bullet: the list reads
                  // like terminal output, which is the identity of the page.
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      '→',
                      style: AppTypography.mono(
                        fontSize: 13,
                        color: AppColors.charcoal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      highlight,
                      style: text.bodySmall?.copyWith(color: AppColors.smoke),
                    ),
                  ),
                ],
              ),
            ),
        ],

        const SizedBox(height: 28),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final String tech in project.tech) MonoBadge(tech),
          ],
        ),

        if (project.hasLinks) ...[
          const SizedBox(height: 32),
          Wrap(
            spacing: 32,
            runSpacing: 16,
            children: [
              if (project.repoUrl case final String url)
                UnderlineLink(
                  label: 'Source',
                  icon: Icons.arrow_outward,
                  onTap: () => LinkLauncher.open(url),
                ),
              if (project.liveUrl case final String url)
                UnderlineLink(
                  label: 'Live demo',
                  icon: Icons.arrow_outward,
                  onTap: () => LinkLauncher.open(url),
                ),
              if (project.storeUrl case final String url)
                UnderlineLink(
                  label: 'App store',
                  icon: Icons.arrow_outward,
                  onTap: () => LinkLauncher.open(url),
                ),
            ],
          ),
        ],
      ],
    );
  }
}
