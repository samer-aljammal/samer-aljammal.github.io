import 'package:flutter/material.dart';

import '../responsive/breakpoints.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'line_reveal.dart';
import 'reveal_on_scroll.dart';

/// Section header: a hairline rule with a mono index above an editorial serif
/// headline.
///
/// The numbered rule doing the separating — rather than a colored eyebrow chip
/// — is what gives the page its editorial rhythm. Every section opens the same
/// way, so the structure is legible before any of the copy is read.
class SectionHeading extends StatelessWidget {
  const SectionHeading({
    required this.index,
    required this.label,
    required this.lines,
    this.trailing,
    super.key,
  });

  /// Two-digit section number, e.g. `01`.
  final String index;

  /// Uppercase mono label, e.g. `WORK`.
  final String label;

  /// Headline, one entry per rendered line — see [LineReveal].
  final List<String> lines;

  /// Optional supporting paragraph under the headline.
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    final double size = context.responsive<double>(
      mobile: 40,
      tablet: 56,
      desktop: 72,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RevealOnScroll(
          child: Row(
            children: [
              Text(index, style: AppTypography.label(color: AppColors.iron)),
              const SizedBox(width: 16),
              Text(label.toUpperCase(), style: AppTypography.label()),
              const SizedBox(width: 20),
              const Expanded(child: Divider(height: 1)),
            ],
          ),
        ),
        SizedBox(height: context.responsive<double>(mobile: 28, desktop: 40)),
        LineReveal(
          lines: lines,
          style: AppTypography.display(fontSize: size, height: 1.06),
        ),
        if (trailing case final String trailing) ...[
          const SizedBox(height: 24),
          RevealOnScroll(
            delay: const Duration(milliseconds: 120),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Text(
                trailing,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.ash),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
