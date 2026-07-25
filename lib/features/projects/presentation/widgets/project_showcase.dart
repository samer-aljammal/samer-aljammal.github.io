import 'package:flutter/material.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/reveal_on_scroll.dart';
import '../../../../core/widgets/tech_chip.dart';
import '../../domain/entities/project.dart';
import 'project_link_button.dart';
import 'tilting_phone_mockup.dart';

/// One project: live phone mockup on one side, the write-up on the other.
///
/// Sides alternate down the page so the eye zig-zags instead of scanning a
/// single column of identical cards.
class ProjectShowcase extends StatelessWidget {
  const ProjectShowcase({
    required this.project,
    required this.index,
    super.key,
  });

  final Project project;

  /// Zero-based position, used for the displayed number and the alternation.
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool mockupOnRight = index.isEven;

    final Widget mockup = _Mockup(project: project);
    final Widget details = _Details(project: project, index: index);

    if (!context.isWide) {
      return RevealOnScroll(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            details,
            const SizedBox(height: 44),
            Center(child: mockup),
          ],
        ),
      );
    }

    return RevealOnScroll(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (mockupOnRight) ...[
            Expanded(flex: 6, child: details),
            const SizedBox(width: 48),
            Expanded(flex: 5, child: mockup),
          ] else ...[
            Expanded(flex: 5, child: mockup),
            const SizedBox(width: 48),
            Expanded(flex: 6, child: details),
          ],
        ],
      ),
    );
  }
}

class _Mockup extends StatelessWidget {
  const _Mockup({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    return TiltingPhoneMockup.project(
      project: project,
      width: context.responsive<double>(
        mobile: 218,
        tablet: 248,
        desktop: 272,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              (index + 1).toString().padLeft(2, '0'),
              style: AppTypography.mono(
                fontSize: 13,
                color: project.accent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      project.accent.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          runSpacing: 8,
          children: [
            Text(project.name, style: text.headlineMedium),
            if (project.isCollaboration)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: project.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: project.accent.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'COLLABORATION',
                  style: AppTypography.mono(
                    fontSize: 10,
                    letterSpacing: 1.4,
                    color: project.accent,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          project.tagline,
          style: text.titleMedium?.copyWith(color: project.accent),
        ),
        const SizedBox(height: 20),

        Text(
          project.description,
          style: text.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),

        if (project.highlights.isNotEmpty) ...[
          const SizedBox(height: 24),
          for (final String highlight in project.highlights)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    // Optically centers the marker on the first text line.
                    padding: const EdgeInsets.only(top: 7),
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: project.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      highlight,
                      style: text.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],

        const SizedBox(height: 26),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final String tech in project.tech) TechChip(tech, dense: true),
          ],
        ),

        if (project.hasLinks) ...[
          const SizedBox(height: 28),
          Wrap(
            spacing: 28,
            runSpacing: 16,
            children: [
              if (project.liveUrl case final String url)
                ProjectLinkButton(
                  label: 'Live demo',
                  url: url,
                  icon: Icons.arrow_outward_rounded,
                ),
              if (project.storeUrl case final String url)
                ProjectLinkButton(
                  label: 'App store',
                  url: url,
                  icon: Icons.shop_outlined,
                ),
              if (project.repoUrl case final String url)
                ProjectLinkButton(
                  label: 'Source',
                  url: url,
                  icon: Icons.code_rounded,
                ),
            ],
          ),
        ],
      ],
    );
  }
}
