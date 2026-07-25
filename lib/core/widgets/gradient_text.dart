import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Paints [text] with a gradient instead of a flat color.
///
/// [ShaderMask] needs a concrete rect, so the gradient is anchored to the
/// text's own bounds — meaning the sweep looks identical whether it wraps to one
/// line or three.
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    this.style,
    this.gradient = AppColors.accent,
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) => gradient.createShader(bounds),
      child: Text(
        text,
        textAlign: textAlign,
        // srcIn takes color from the shader, but the glyphs must be opaque for
        // the mask to land at full strength.
        style: (style ?? const TextStyle()).copyWith(color: Colors.white),
      ),
    );
  }
}
