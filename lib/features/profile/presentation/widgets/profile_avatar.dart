import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/hover_region.dart';
import '../../domain/entities/profile.dart';

/// Portrait with a gradient ring, falling back to an initials tile.
///
/// The fallback is deliberately load-bearing rather than defensive: the site is
/// expected to run before a photo exists, and a missing file must look like a
/// design choice, not a bug. Any failure to decode the asset lands here too.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({required this.profile, this.size = 200, super.key});

  final Profile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      builder: (BuildContext context, bool hovered) => AnimatedContainer(
        duration: AppMotion.medium,
        curve: AppMotion.enter,
        width: size,
        height: size,
        transform: Matrix4.translationValues(0, hovered ? -5 : 0, 0),
        transformAlignment: Alignment.center,
        // The ring is the container's own gradient; the portrait sits inside a
        // padding of 3, so the gradient reads as a stroke rather than a fill.
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.accent,
          boxShadow: AppColors.glow(
            hovered ? AppColors.magenta : AppColors.violet,
            strength: hovered ? 1.5 : 0.9,
          ),
        ),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.background,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: ClipOval(child: _portrait(context)),
          ),
        ),
      ),
    );
  }

  Widget _portrait(BuildContext context) {
    final String? asset = profile.avatarAsset;
    if (asset == null) return _Initials(profile: profile, size: size);

    return Image.asset(
      asset,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      filterQuality: FilterQuality.medium,
      errorBuilder: (BuildContext context, Object error, StackTrace? stack) =>
          _Initials(profile: profile, size: size),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.profile, required this.size});

  final Profile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        gradient: AppColors.cardSheen,
      ),
      child: Center(
        child: Text(
          profile.initials,
          style: AppTypography.mono(
            fontSize: size * 0.26,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
}
