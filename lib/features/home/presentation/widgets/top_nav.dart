import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/hover_region.dart';
import '../portfolio_section_id.dart';

/// Fixed header. Transparent over the hero, then frosted once the page scrolls.
class TopNav extends StatelessWidget {
  const TopNav({
    required this.initials,
    required this.name,
    required this.activeSection,
    required this.onNavigate,
    required this.isScrolled,
    super.key,
  });

  final String initials;
  final String name;
  final PortfolioSectionId activeSection;
  final ValueChanged<PortfolioSectionId> onNavigate;

  /// True once the page has scrolled off the top.
  final bool isScrolled;

  /// Height reserved for the bar. Sections offset their scroll target by this.
  static const double height = 76;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AnimatedContainer(
        duration: AppMotion.medium,
        curve: AppMotion.enter,
        decoration: BoxDecoration(
          color: isScrolled
              ? AppColors.background.withValues(alpha: 0.72)
              : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isScrolled ? AppColors.border : Colors.transparent,
            ),
          ),
        ),
        // The blur is only mounted while scrolled; a permanent full-width
        // backdrop filter is one of the more expensive things you can leave
        // running on Flutter web.
        child: ClipRect(
          child: BackdropFilter(
            filter: isScrolled
                ? ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18)
                : ui.ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.gutter),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: Breakpoints.maxContentWidth,
                  ),
                  child: Row(
                    children: [
                      _Logo(
                        initials: initials,
                        name: name,
                        onTap: () => onNavigate(PortfolioSectionId.home),
                      ),
                      const Spacer(),
                      if (context.isMobile)
                        _MobileMenu(
                          activeSection: activeSection,
                          onNavigate: onNavigate,
                        )
                      else
                        Row(
                          children: [
                            for (final PortfolioSectionId section
                                in PortfolioSectionId.values)
                              _NavItem(
                                section: section,
                                isActive: section == activeSection,
                                onTap: () => onNavigate(section),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({
    required this.initials,
    required this.name,
    required this.onTap,
  });

  final String initials;
  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) => Row(
        children: [
          AnimatedContainer(
            duration: AppMotion.fast,
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: AppColors.accent,
              borderRadius: BorderRadius.circular(11),
              boxShadow: hovered
                  ? AppColors.glow(AppColors.violet, strength: 0.9)
                  : null,
            ),
            child: Text(
              initials,
              style: AppTypography.mono(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (!context.isMobile) ...[
            const SizedBox(width: 14),
            Text(name, style: Theme.of(context).textTheme.titleMedium),
          ],
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.section,
    required this.isActive,
    required this.onTap,
  });

  final PortfolioSectionId section;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AnimatedContainer(
          duration: AppMotion.fast,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.violet.withValues(alpha: 0.12)
                : (hovered ? AppColors.surface : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? AppColors.borderStrong : Colors.transparent,
            ),
          ),
          child: Text(
            section.label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: isActive || hovered
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Compact nav for narrow viewports. A popup rather than a drawer: four links
/// don't justify a full-screen overlay.
class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.activeSection, required this.onNavigate});

  final PortfolioSectionId activeSection;
  final ValueChanged<PortfolioSectionId> onNavigate;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PortfolioSectionId>(
      onSelected: onNavigate,
      tooltip: 'Menu',
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
      itemBuilder: (BuildContext context) => [
        for (final PortfolioSectionId section in PortfolioSectionId.values)
          PopupMenuItem<PortfolioSectionId>(
            value: section,
            child: Text(
              section.label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: section == activeSection
                    ? AppColors.violet
                    : AppColors.textPrimary,
              ),
            ),
          ),
      ],
    );
  }
}
