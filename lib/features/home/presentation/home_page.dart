import 'package:flutter/material.dart';

import '../../../core/constants/app_motion.dart';
import '../../../core/di/service_locator.dart';
import '../../../core/widgets/gradient_orb_background.dart';
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
/// which nav item is currently active.
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

  /// Built once per page load, not per rebuild — reshuffling on every setState
  /// would make the hero mockup jump to a different app whenever the nav
  /// highlight changed.
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

  /// The last section whose top edge has passed under the nav bar.
  PortfolioSectionId _resolveActiveSection() {
    PortfolioSectionId active = PortfolioSectionId.values.first;

    for (final PortfolioSectionId id in PortfolioSectionId.values) {
      final double? top = _sectionTop(id);
      // A slack of 40px means a section counts as active just before its
      // heading reaches the bar, which matches where attention actually is.
      if (top == null || top > TopNav.height + 40) break;
      active = id;
    }
    return active;
  }

  /// Global y position of a section, or null if it is not laid out yet.
  double? _sectionTop(PortfolioSectionId id) {
    final RenderObject? renderObject = _sectionKeys[id]?.currentContext
        ?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;
    return renderObject.localToGlobal(Offset.zero).dy;
  }

  void _scrollTo(PortfolioSectionId id) {
    final double? top = _sectionTop(id);
    if (top == null || !_scrollController.hasClients) return;

    // Converts the section's on-screen position into an absolute scroll offset,
    // then backs off by the nav height so the heading isn't hidden behind it.
    final double target = _scrollController.offset + top - TopNav.height;

    _scrollController.animateTo(
      target.clamp(0, _scrollController.position.maxScrollExtent),
      duration: AppMotion.navigate,
      curve: AppMotion.emphasized,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientOrbBackground(
        child: Stack(
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
                initials: _profile.initials,
                name: _profile.name,
                activeSection: _activeSection,
                isScrolled: _isScrolled,
                onNavigate: _scrollTo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
