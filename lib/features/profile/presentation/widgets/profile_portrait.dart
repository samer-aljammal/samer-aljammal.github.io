import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/hover_region.dart';
import '../../domain/entities/profile.dart';

/// Editorial portrait: a 4:5 plate with a hairline border, always in full
/// colour, captioned underneath.
///
/// It used to desaturate until hovered. That is a common editorial device, but
/// it hides the subject on first read and does nothing at all on touch, where
/// there is no hover — so the photograph now simply reads as a photograph. The
/// hover state moved to the frame instead: a brighter rim and a small lift.
class ProfilePortrait extends StatelessWidget {
  const ProfilePortrait({required this.profile, super.key});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        HoverRegion(
          builder: (BuildContext context, bool hovered) => AspectRatio(
            aspectRatio: 4 / 5,
            child: AnimatedContainer(
              duration: AppMotion.base,
              curve: AppMotion.ease,
              // Lifts a few pixels under the cursor. The whole hover state now
              // lives in the frame, since the photograph itself no longer
              // changes — and a lift still works on touch, where hover cannot.
              transform: Matrix4.translationValues(0, hovered ? -6 : 0, 0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hovered ? AppColors.ashBright : AppColors.ashBorder,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: _image(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              profile.name.toUpperCase(),
              style: AppTypography.label(color: AppColors.fog),
            ),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 1, color: AppColors.ashBorder)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          profile.role,
          style: AppTypography.sans(fontSize: 12, color: AppColors.fog),
        ),
      ],
    );
  }

  Widget _image() {
    final String? asset = profile.avatarAsset;
    if (asset == null) return _Fallback(profile: profile);

    return Image.asset(
      asset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      filterQuality: FilterQuality.medium,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          _Fallback(profile: profile),
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.slateShadow,
      child: Center(
        child: Text(
          profile.initials,
          style: AppTypography.sans(fontSize: 28, color: AppColors.ashBorder),
        ),
      ),
    );
  }
}
