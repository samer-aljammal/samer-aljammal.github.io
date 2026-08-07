import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_motion.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/hover_region.dart';
import '../portfolio_section_id.dart';

/// Fixed header: mono wordmark, mono nav, one ghost action.
///
/// Transparent over the hero, then a black scrim with a hairline underline once
/// the page moves. The active item is marked with a small violet dot rather
/// than a filled pill — a chip in the nav is the sort of thing that makes a
/// custom layout look like a component library.
class TopNav extends StatelessWidget {
  const TopNav({
    required this.name,
    required this.activeSection,
    required this.onNavigate,
    required this.isScrolled,
    super.key,
  });

  final String name;
  final PortfolioSectionId activeSection;
  final ValueChanged<PortfolioSectionId> onNavigate;
  final bool isScrolled;

  static const double height = 68;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: AnimatedContainer(
        duration: AppMotion.base,
        curve: AppMotion.ease,
        decoration: BoxDecoration(
          color: isScrolled ? const Color(0xF2000000) : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: isScrolled ? AppColors.ashBorder : Colors.transparent,
            ),
          ),
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: isScrolled
                ? ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20)
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
                      _Wordmark(
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

class _Wordmark extends StatelessWidget {
  const _Wordmark({required this.name, required this.onTap});

  final String name;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoverRegion(
      onTap: onTap,
      builder: (BuildContext context, bool hovered) => Row(
        children: [
          // A violet square standing in for a logo: the one piece of brand
          // colour in the chrome, at the smallest possible size.
          Container(width: 7, height: 7, color: AppColors.bone),
          const SizedBox(width: 12),
          AnimatedDefaultTextStyle(
            duration: AppMotion.hover,
            style: AppTypography.sans(
              fontSize: 13,
              color: hovered ? AppColors.bone : AppColors.bone,
              letterSpacing: 0.4,
            ),
            child: Text(name),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppMotion.hover,
              width: isActive ? 5 : 0,
              height: 5,
              margin: EdgeInsets.only(right: isActive ? 9 : 0),
              decoration: const BoxDecoration(
                color: AppColors.bone,
                shape: BoxShape.circle,
              ),
            ),
            AnimatedDefaultTextStyle(
              duration: AppMotion.hover,
              style: AppTypography.sans(
                fontSize: 13,
                color: isActive || hovered ? AppColors.bone : AppColors.fog,
              ),
              child: Text(section.label),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.activeSection, required this.onNavigate});

  final PortfolioSectionId activeSection;
  final ValueChanged<PortfolioSectionId> onNavigate;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PortfolioSectionId>(
      onSelected: onNavigate,
      tooltip: 'Menu',
      color: AppColors.obsidian,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: const BorderSide(color: AppColors.ashBorder),
      ),
      icon: const Icon(Icons.menu, color: AppColors.bone, size: 20),
      itemBuilder: (BuildContext context) => [
        for (final PortfolioSectionId section in PortfolioSectionId.values)
          PopupMenuItem<PortfolioSectionId>(
            value: section,
            height: 42,
            child: Text(
              section.label,
              style: AppTypography.sans(
                fontSize: 13,
                color: section == activeSection
                    ? AppColors.bone
                    : AppColors.bone,
              ),
            ),
          ),
      ],
    );
  }
}
