import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/hover_region.dart';
import '../../domain/entities/profile.dart';

/// Editorial portrait: a 4:5 frame with a hairline border, desaturated until
/// hovered, captioned in mono.
///
/// The greyscale-to-colour transition is the point. A circular avatar with a
/// glowing ring is a profile widget; a rectangular plate that resolves into
/// colour under the cursor is a photograph, and it belongs to the same
/// monochrome discipline as the rest of the page.
class ProfilePortrait extends StatelessWidget {
  const ProfilePortrait({required this.profile, super.key});

  final Profile profile;

  /// Fully desaturating matrix — luminance weights, not a flat average, so
  /// skin tones keep their natural relative brightness.
  static const List<double> _greyscale = <double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0, 0, 0, 1, 0,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HoverRegion(
          builder: (BuildContext context, bool hovered) => AspectRatio(
            aspectRatio: 4 / 5,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: hovered
                      ? AppColors.hairlineBright
                      : AppColors.hairline,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: _image(hovered),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              profile.name.toUpperCase(),
              style: AppTypography.label(color: AppColors.ash),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 1, color: AppColors.hairline)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          profile.role,
          style: AppTypography.mono(fontSize: 12, color: AppColors.iron),
        ),
      ],
    );
  }

  Widget _image(bool hovered) {
    final String? asset = profile.avatarAsset;
    if (asset == null) return _Fallback(profile: profile);

    final Widget photo = Image.asset(
      asset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      filterQuality: FilterQuality.medium,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          _Fallback(profile: profile),
    );

    return Stack(
      fit: StackFit.expand,
      children: [
        photo,
        // The colour copy fades out over the greyscale one, rather than
        // animating the matrix itself — cheaper, and it cannot flash.
        AnimatedOpacity(
          opacity: hovered ? 0 : 1,
          duration: AppMotion.base,
          curve: AppMotion.ease,
          child: ColorFiltered(
            colorFilter: const ColorFilter.matrix(_greyscale),
            child: photo,
          ),
        ),
      ],
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.surfaceLift,
      child: Center(
        child: Text(
          profile.initials,
          style: AppTypography.mono(fontSize: 28, color: AppColors.charcoal),
        ),
      ),
    );
  }
}
