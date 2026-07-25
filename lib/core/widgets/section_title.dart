import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'highlighted_text.dart';
import 'reveal_on_scroll.dart';

/// Section heading: a monospace eyebrow, a large title with an optional
/// gradient-highlighted tail, and an optional supporting line.
class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.eyebrow,
    required this.title,
    this.highlight,
    this.subtitle,
    super.key,
  });

  /// Small uppercase label, e.g. `02 — WORK`.
  final String eyebrow;

  final String title;

  /// Trailing words rendered in the accent gradient.
  final String? highlight;

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    final TextStyle? titleStyle = context.responsive(
      mobile: text.headlineMedium,
      tablet: text.headlineLarge,
      desktop: text.headlineLarge,
    );

    return RevealOnScroll(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 2,
                decoration: const BoxDecoration(gradient: AppColors.accent),
              ),
              const SizedBox(width: 12),
              Text(
                eyebrow.toUpperCase(),
                style: AppTypography.mono(letterSpacing: 2.4),
              ),
            ],
          ),
          const SizedBox(height: 18),
          HighlightedText(
            text: title,
            highlight: highlight,
            style: titleStyle,
          ),
          if (subtitle case final String subtitle) ...[
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                subtitle,
                style: text.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
