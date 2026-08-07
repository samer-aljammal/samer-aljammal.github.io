import 'package:flutter/material.dart';

import '../../../core/constants/app_motion.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/marquee_strip.dart';
import '../../../core/widgets/scroll_progress_bar.dart';
import '../../about/presentation/about_section.dart';
import '../../contact/presentation/contact_section.dart';
import '../../hero/presentation/hero_section.dart';
import '../../profile/domain/entities/profile.dart';
import '../../projects/domain/entities/project.dart';
import '../../projects/presentation/models/phone_screen.dart';
import '../../projects/presentation/projects_section.dart';
import 'portfolio_section_id.dart';
import 'widgets/site_footer.dart';
import 'widgets/top_nav.dart';

/// The single page. Owns scroll state: section anchors, smooth navigation, and
/// which nav item is active.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  final Map<PortfolioSectionId, GlobalKey> _sectionKeys = {
    for (final PortfolioSectionId id in PortfolioSectionId.values)
      id: GlobalKey(),
  };

  late final Profile _profile = ServiceLocator.profile.getProfile();
  late final List<Project> _projects = ServiceLocator.projects.getProjects();

  /// Built once per page load, not per rebuild: reshuffling on setState would
  /// make the hero device jump to another app whenever the nav highlight moved.
  late final List<PhoneScreen> _heroScreens = PhoneScreen.mixedAcross(
    _projects,
  );

  PortfolioSectionId _activeSection = PortfolioSectionId.home;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final bool scrolled = _scrollController.offset > 12;
    final PortfolioSectionId active = _resolveActiveSection();
    if (scrolled == _isScrolled && active == _activeSection) return;
    setState(() {
      _isScrolled = scrolled;
      _activeSection = active;
    });
  }

  PortfolioSectionId _resolveActiveSection() {
    PortfolioSectionId active = PortfolioSectionId.values.first;
    for (final PortfolioSectionId id in PortfolioSectionId.values) {
      final double? top = _sectionTop(id);
      if (top == null || top > TopNav.height + 40) break;
      active = id;
    }
    return active;
  }

  double? _sectionTop(PortfolioSectionId id) {
    final RenderObject? object = _sectionKeys[id]?.currentContext
        ?.findRenderObject();
    if (object is! RenderBox || !object.hasSize) return null;
    return object.localToGlobal(Offset.zero).dy;
  }

  void _scrollTo(PortfolioSectionId id) {
    final double? top = _sectionTop(id);
    if (top == null || !_scrollController.hasClients) return;
    final double target = _scrollController.offset + top - TopNav.height;
    _scrollController.animateTo(
      target.clamp(0, _scrollController.position.maxScrollExtent),
      duration: AppMotion.navigate,
      curve: AppMotion.easeStrong,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.void_,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KeyedSubtree(
                  key: _sectionKeys[PortfolioSectionId.home],
                  child: HeroSection(
                    profile: _profile,
                    showcaseScreens: _heroScreens,
                    onViewWork: () => _scrollTo(PortfolioSectionId.work),
                    onContact: () => _scrollTo(PortfolioSectionId.contact),
                  ),
                ),
                MarqueeStrip(items: _profile.stack),
                KeyedSubtree(
                  key: _sectionKeys[PortfolioSectionId.about],
                  child: AboutSection(profile: _profile),
                ),
                KeyedSubtree(
                  key: _sectionKeys[PortfolioSectionId.work],
                  child: ProjectsSection(projects: _projects),
                ),
                KeyedSubtree(
                  key: _sectionKeys[PortfolioSectionId.contact],
                  child: ContactSection(profile: _profile),
                ),
                SiteFooter(
                  name: _profile.name,
                  links: _profile.socials,
                  onBackToTop: () => _scrollTo(PortfolioSectionId.home),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: TopNav(
              name: _profile.name,
              activeSection: _activeSection,
              isScrolled: _isScrolled,
              onNavigate: _scrollTo,
            ),
          ),
          // Sits above the nav so the read position is always visible.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ScrollProgressBar(controller: _scrollController),
          ),
        ],
      ),
    );
  }
}
