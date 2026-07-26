import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_portfolio/app/portfolio_app.dart';
import 'package:my_portfolio/core/di/service_locator.dart';
import 'package:my_portfolio/features/hero/presentation/hero_section.dart';
import 'package:my_portfolio/features/home/presentation/widgets/top_nav.dart';
import 'package:my_portfolio/features/projects/presentation/models/phone_screen.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/device_frame.dart';
import 'package:my_portfolio/features/projects/presentation/widgets/tilting_phone_mockup.dart';

void main() {
  setUpAll(() {
    // Without this, every text style triggers a font download attempt and the
    // tests fail on the network call rather than on anything meaningful.
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  /// Sizes the test viewport, since the layout branches on width.
  Future<void> pumpSite(
    WidgetTester tester, {
    Size size = const Size(1440, 1000),
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const PortfolioApp());

    // Settles the staggered entrance animations. This has to be many small
    // pumps, not one long one: each reveal flips itself on via a delayed
    // callback, and the implicit animation it starts then needs further frames.
    // pumpAndSettle is not an option — the ambient background and the screen
    // reels loop forever by design, so it would never return.
    for (int i = 0; i < 14; i++) {
      await tester.pump(const Duration(milliseconds: 150));
    }
  }

  testWidgets('renders the hero with name and headline', (tester) async {
    await pumpSite(tester);

    final profile = ServiceLocator.profile.getProfile();
    expect(find.text(profile.name), findsWidgets);
    expect(find.text('Available for work'), findsOneWidget);

    // Scoped to the hero: the highlight phrase may legitimately recur in the
    // bio copy further down the page.
    expect(
      find.descendant(
        of: find.byType(HeroSection),
        matching: find.textContaining(profile.heroHighlight),
      ),
      findsOneWidget,
    );
  });

  testWidgets('renders a phone mockup in the hero', (tester) async {
    await pumpSite(tester);

    expect(find.byType(TiltingPhoneMockup), findsWidgets);
    expect(find.byType(DeviceFrame), findsWidgets);
  });

  testWidgets('footer spells out every profile link', (tester) async {
    await pumpSite(tester);

    // Icon tiles elsewhere on the page are not readable; the footer is where
    // the handle itself has to be visible.
    expect(find.text('github.com/samer-aljammal'), findsOneWidget);
    expect(find.text('samoraaljammal@gmail.com'), findsWidgets);
  });

  testWidgets('nav exposes every section on desktop', (tester) async {
    await pumpSite(tester);

    expect(find.byType(TopNav), findsOneWidget);
    for (final String label in ['Home', 'About', 'Work', 'Contact']) {
      expect(find.text(label), findsWidgets, reason: 'missing nav item $label');
    }
  });

  testWidgets('nav collapses to a menu button on mobile', (tester) async {
    await pumpSite(tester, size: const Size(420, 900));

    expect(find.byIcon(Icons.menu_rounded), findsOneWidget);
  });

  testWidgets('offers both hero calls to action', (tester) async {
    await pumpSite(tester);

    expect(find.text('View my work'), findsOneWidget);
    expect(find.text('Get in touch'), findsOneWidget);
  });

  testWidgets('tapping a nav item scrolls the page down', (tester) async {
    await pumpSite(tester);

    final Finder scrollable = find.byType(Scrollable).first;
    final double before =
        tester.widget<Scrollable>(scrollable).controller!.offset;

    // Driven from the nav rather than the hero button: the nav is pinned, so
    // the tap target is on screen regardless of how tall the hero lays out.
    await tester.tap(find.text('Work'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));

    final double after =
        tester.widget<Scrollable>(scrollable).controller!.offset;
    expect(after, greaterThan(before));
  });

  test('every project has content and a unique id', () {
    final projects = ServiceLocator.projects.getProjects();

    expect(projects, isNotEmpty);
    expect(
      projects.map((p) => p.id).toSet().length,
      projects.length,
      reason: 'project ids must be unique — they name screenshot files',
    );

    for (final project in projects) {
      expect(project.name, isNotEmpty);
      expect(project.tagline, isNotEmpty);
      expect(project.description, isNotEmpty);
      expect(
        project.tech,
        isNotEmpty,
        reason: '${project.id} has no tech tags',
      );
    }
  });

  test('the hero reel mixes screens from every project', () {
    final projects = ServiceLocator.projects.getProjects();
    // Seeded so the assertion is about the sampling rule, not one lucky shuffle.
    final mixed = PhoneScreen.mixedAcross(projects, random: Random(7));

    expect(mixed.length, projects.length * 2);
    expect(
      mixed.map((s) => s.label).toSet(),
      projects.map((p) => p.name).toSet(),
      reason: 'every project must be represented, whatever the shuffle',
    );
  });

  test('hero reel sampling holds for any shuffle', () {
    final projects = ServiceLocator.projects.getProjects();
    for (int seed = 0; seed < 40; seed++) {
      final mixed = PhoneScreen.mixedAcross(projects, random: Random(seed));
      expect(mixed.map((s) => s.label).toSet().length, projects.length);
    }
  });

  test('about copy speaks generally, without hard counts', () {
    // Requested explicitly: no "4 apps", no "1 year". Counts date badly and
    // invite comparison on volume rather than on how the work is built.
    final profile = ServiceLocator.profile.getProfile();
    final digit = RegExp(r'\d');

    for (final paragraph in profile.bio) {
      expect(
        digit.hasMatch(paragraph),
        isFalse,
        reason: 'bio paragraph contains a number: $paragraph',
      );
    }
    for (final principle in profile.principles) {
      expect(digit.hasMatch(principle.detail), isFalse);
      expect(digit.hasMatch(principle.title), isFalse);
    }
    expect(digit.hasMatch(profile.heroSubtitle), isFalse);
  });

  testWidgets('a shared project is labelled a collaboration', (tester) async {
    await pumpSite(tester);

    final shared = ServiceLocator.projects
        .getProjects()
        .where((p) => p.isCollaboration);
    expect(shared, isNotEmpty, reason: 'offers is a collaboration');
    expect(find.text('COLLABORATION'), findsNWidgets(shared.length));
  });

  test('profile initials come from the first two names', () {
    expect(ServiceLocator.profile.getProfile().initials, 'SA');
  });

  test('every project screenshot path is declared under assets/projects', () {
    for (final project in ServiceLocator.projects.getProjects()) {
      for (final path in project.screenshots) {
        expect(
          path,
          startsWith('assets/projects/'),
          reason: 'pubspec only bundles assets/projects/',
        );
      }
    }
  });

  test('the avatar asset exists, or is explicitly absent', () {
    // Either state is valid — ProfileAvatar falls back to initials — but a path
    // that points at nothing means the portrait silently vanished.
    final avatar = ServiceLocator.profile.getProfile().avatarAsset;
    if (avatar != null) {
      expect(
        File(avatar).existsSync(),
        isTrue,
        reason: '$avatar is set but missing; set avatarAsset to null instead',
      );
    }
  });

  test('a self-hosted CV link has a file behind it', () {
    // The CV is served from this site's own domain, so the file must be in web/
    // to end up in the build. A rename would otherwise ship a button that 404s.
    final cvUrl = ServiceLocator.profile.getProfile().cvUrl;
    if (cvUrl == null) return;

    const origin = 'https://samer-aljammal.github.io/';
    if (!cvUrl.startsWith(origin)) return; // hosted elsewhere; nothing to check

    final fileName = cvUrl.substring(origin.length);
    expect(
      File('web/$fileName').existsSync(),
      isTrue,
      reason: 'cvUrl points at $fileName, but web/$fileName does not exist',
    );
  });

  testWidgets('the hero offers a CV download when one is linked', (
    tester,
  ) async {
    await pumpSite(tester);

    final hasCv = ServiceLocator.profile.getProfile().cvUrl != null;
    expect(find.text('Download CV'), hasCv ? findsOneWidget : findsNothing);
  });

  test('every declared screenshot exists on disk', () {
    for (final project in ServiceLocator.projects.getProjects()) {
      for (final path in project.screenshots) {
        expect(
          File(path).existsSync(),
          isTrue,
          reason: '$path is referenced by ${project.id} but is not there',
        );
      }
    }
  });

  test('screenshot filenames match their project id', () {
    // The reel falls back to a placeholder on a bad path rather than throwing,
    // so a typo would otherwise ship silently and just look unfinished.
    for (final project in ServiceLocator.projects.getProjects()) {
      for (final path in project.screenshots) {
        expect(
          path.split('/').last,
          startsWith('${project.id}_'),
          reason: '${project.id} references a screenshot named for another app',
        );
      }
    }
  });
}
