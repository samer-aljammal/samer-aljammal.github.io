import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A single paragraph whose trailing [highlight] is painted in a gradient.
///
/// This exists because the obvious approach — a [Wrap] holding a plain [Text]
/// and a gradient one — forces a line break between them, which turns a
/// three-line heading into six. Here both parts are spans in one paragraph, so
/// the highlight wraps inline like any other word, and the gradient is applied
/// through the span's `foreground` paint.
class HighlightedText extends StatelessWidget {
  const HighlightedText({
    required this.text,
    this.highlight,
    this.style,
    this.gradient = AppColors.accent,
    this.textAlign,
    super.key,
  });

  final String text;

  /// Trailing words to paint in [gradient]. Null renders [text] alone.
  final String? highlight;

  final TextStyle? style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final TextStyle base = style ?? DefaultTextStyle.of(context).style;
    final String? highlight = this.highlight;

    if (highlight == null) {
      return Text(text, style: base, textAlign: textAlign);
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Sweeps horizontally across the available width, so a word's color
        // depends on where it sits on the line — stable regardless of how the
        // paragraph happens to wrap.
        final double width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;

        final ui.Shader shader = gradient.createShader(
          Rect.fromLTWH(0, 0, width, base.fontSize ?? 16),
        );

        return Text.rich(
          TextSpan(
            style: base,
            children: [
              TextSpan(text: '$text '),
              TextSpan(text: highlight, style: _withShader(base, shader)),
            ],
          ),
          textAlign: textAlign,
        );
      },
    );
  }

  /// [TextStyle] asserts that `color` and `foreground` are never both set, and
  /// `copyWith` cannot clear a color — so the shader style is rebuilt field by
  /// field from [base], carrying the font identity across but dropping color.
  static TextStyle _withShader(TextStyle base, ui.Shader shader) => TextStyle(
    inherit: false,
    foreground: Paint()..shader = shader,
    fontFamily: base.fontFamily,
    fontFamilyFallback: base.fontFamilyFallback,
    fontSize: base.fontSize,
    fontWeight: base.fontWeight,
    fontStyle: base.fontStyle,
    letterSpacing: base.letterSpacing,
    wordSpacing: base.wordSpacing,
    height: base.height,
    leadingDistribution: base.leadingDistribution,
    textBaseline: base.textBaseline ?? TextBaseline.alphabetic,
    decoration: TextDecoration.none,
  );
}
