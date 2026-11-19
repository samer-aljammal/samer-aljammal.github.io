import 'package:flutter/material.dart';

import '../domain/entities/project.dart';
import '../domain/repositories/projects_repository.dart';

/// Hardcoded project list — the single place project content is edited.
///
/// The copy below is written from what the screenshots show, with the tech tags
/// cross-checked against the descriptions on github.com/samer-aljammal.
///
/// TODO(you): name the state-management library per app — your repo descriptions
/// say "state management" without saying which. Add `storeUrl` / `liveUrl` too
/// if any of these are published anywhere; null links simply do not render.
///
/// Each project's `accent` is its own brand color, which tints that phone's
/// glow and the numbered rule above its write-up.
class LocalProjectsRepository implements ProjectsRepository {
  const LocalProjectsRepository();

  @override
  List<Project> getProjects() => const [
    // First on the page: the deepest piece of engineering here, and the only
    // one whose selling points are architectural rather than featural.
    Project(
      id: 'nexaai',
      name: 'Nexa AI',
      tagline: 'Cross-platform AI assistant',
      description:
          'A production AI assistant built provider-agnostically: Claude, '
          'Gemini, an OpenAI-compatible endpoint and a mock all sit behind one '
          'interface, so switching model vendors is a single line rather than a '
          'migration. Replies stream token by token over a hand-written '
          'Server-Sent Events parser, and the whole app stays usable with no '
          'backend configured at all.',
      tech: ['Flutter', 'Clean Architecture', 'BLoC', 'SSE streaming'],
      highlights: [
        'Four interchangeable AI adapters behind one interface — no vendor '
            'payload format leaks above the service boundary',
        'Token-by-token streaming over a hand-written SSE parser that handles '
            'partial chunks and mid-stream errors',
        'A sealed Result type forces every caller to handle the failure branch, '
            'with a retryable flag so retry is only offered when it can work',
        '73 passing tests, against a domain layer with zero Flutter, Firebase '
            'or dart:io imports',
        'Fully usable offline — local data sources resolved through GetIt at '
            'startup, with no secrets compiled into release builds',
      ],
      accent: Color(0xFF7C4DFF),
      screenshots: [
        'assets/projects/nexaai_1.jpg',
        'assets/projects/nexaai_2.jpg',
        'assets/projects/nexaai_3.jpg',
        'assets/projects/nexaai_4.jpg',
        'assets/projects/nexaai_5.jpg',
        'assets/projects/nexaai_6.jpg',
      ],
      repoUrl: 'https://github.com/samer-aljammal/nexa-ai',
    ),
    // Second: the most design-led piece, and the one with two explainable
    // rule engines at its core rather than a feature list.
    Project(
      id: 'drivio',
      name: 'Drivio',
      tagline: 'Vehicle health, service and cost tracking',
      description:
          'A vehicle companion app that answers the questions owners actually '
          'ask: how healthy is my car, what is due next, and what is it costing '
          'me per kilometre. A rule-based health score and a maintenance '
          'interval engine turn service, fuel and expense records into a '
          'dashboard that only highlights what needs attention. Offline-first '
          'on a local SQL database, with a custom motion system built on '
          "Flutter's spring physics.",
      tech: ['Flutter', 'BLoC', 'Drift (SQLite)', 'Clean Architecture'],
      highlights: [
        'Explainable 0–100 health score from five weighted, documented '
            'factors — tap it and every point is accounted for',
        'Service intervals tracked by distance and time, ordered by an '
            'estimated due date from the car’s real driving rate',
        'Offline-first and reactive: watched Drift queries update the '
            'dashboard live, with no refresh logic anywhere',
        'Spring-driven press and selection, a shared-element photo '
            'transition, and charts that draw in once — all honouring '
            'reduce-motion',
        '68 passing tests across the health, interval, fuel and cost '
            'engines, plus cubit orchestration and widgets',
      ],
      accent: Color(0xFF43C08D),
      screenshots: [
        'assets/projects/drivio_1.jpg',
        'assets/projects/drivio_2.jpg',
        'assets/projects/drivio_3.jpg',
        'assets/projects/drivio_4.jpg',
        'assets/projects/drivio_5.jpg',
      ],
      repoUrl: 'https://github.com/samer-aljammal/drivio',
    ),
    Project(
      id: 'chattr',
      name: 'Chattr',
      tagline: 'Real-time messaging with presence',
      description:
          'A full messaging app: one-to-one conversations with last-seen '
          'presence, voice notes, photo and file attachments, reply quoting, '
          'read receipts and unread counts, plus search across messages. '
          'Settings cover light/dark/system appearance, language, notification '
          'and privacy controls, and blocked-user management.',
      tech: ['Flutter', 'Firebase', 'Clean Architecture', 'Real-time chat'],
      highlights: [
        'Real-time messaging backed by Firebase',
        'Voice notes with inline playback and duration',
        'Reply quoting that keeps the original message in context',
        'Read receipts and live last-seen presence',
        'Sign-in with email, Google, Facebook or Apple',
      ],
      accent: Color(0xFFA855F7),
      screenshots: [
        'assets/projects/chattr_1.jpg',
        'assets/projects/chattr_2.jpg',
        'assets/projects/chattr_3.jpg',
        'assets/projects/chattr_4.jpg',
        'assets/projects/chattr_5.jpg',
      ],
      repoUrl: 'https://github.com/samer-aljammal/chattr',
    ),
    Project(
      id: 'spendwise',
      name: 'SpendWise',
      tagline: 'Expense tracking and budgets',
      description:
          'A personal finance tracker built around a single balance view: '
          'income and expense totals, a spend-frequency graph filterable by '
          'day, week, month and year, and a categorised transaction feed. '
          'Entries capture amount, category, wallet, notes, an optional '
          'receipt image and a repeat rule; budgets can raise an alert as '
          'spending approaches the limit.',
      tech: ['Flutter', 'Dart', 'Interactive charts', 'Budget alerts'],
      highlights: [
        'Spend-frequency chart with day/week/month/year ranges',
        'Transactions with receipt attachments and repeat rules',
        'Per-category budgets with threshold alerts',
        'Onboarding carousel into sign-up and login flows',
      ],
      accent: Color(0xFF7F3DFF),
      screenshots: [
        'assets/projects/spendwise_1.jpg',
        'assets/projects/spendwise_2.jpg',
        'assets/projects/spendwise_3.jpg',
        'assets/projects/spendwise_4.jpg',
      ],
      repoUrl: 'https://github.com/samer-aljammal/spendWise',
    ),
    Project(
      id: 'mealgo',
      name: 'MealGo',
      tagline: 'Food delivery, ordering to checkout',
      description:
          'A food delivery app covering the whole order path end to end: '
          'search with recent keywords and suggested restaurants, dish detail '
          'with size and ingredient selection, a cart with quantities and '
          'delivery address, checkout across cash, Visa, Mastercard and '
          'PayPal, and live courier tracking on a map until the order lands. '
          'Fully localised in English and Arabic, with light, dark and system '
          'themes.',
      tech: [
        'Flutter',
        'Localization (EN/AR)',
        'Live map tracking',
        'Payments',
      ],
      highlights: [
        'Live courier tracking on a map, with route and updating ETA',
        'English and Arabic localisation, including RTL layout',
        'Search with recent keywords and suggested restaurants',
        'Checkout across four payment methods with saved cards',
      ],
      accent: Color(0xFFF58634),
      screenshots: [
        'assets/projects/mealgo_1.jpg',
        'assets/projects/mealgo_2.jpg',
        'assets/projects/mealgo_3.jpg',
        'assets/projects/mealgo_4.jpg',
        'assets/projects/mealgo_5.jpg',
        'assets/projects/mealgo_6.jpg',
      ],
      repoUrl: 'https://github.com/samer-aljammal/mealGo',
    ),
    Project(
      id: 'flowerly',
      name: 'Flowerly',
      tagline: 'Florist storefront with order tracking',
      description:
          'A flower delivery storefront: searchable and filterable catalog, '
          'promotional offer carousel, browsing by occasion, and a popularity '
          'feed with ratings and favourites. Orders are followed through a '
          'live status timeline from confirmation to delivery, with an '
          'estimated arrival window.',
      tech: ['Flutter', 'Clean Architecture', 'E-commerce', 'Responsive UI'],
      highlights: [
        'Order tracking timeline with an estimated arrival window',
        'Catalog browsing by occasion, with favourites and ratings',
        'Currency and language selection per account',
        'Delivery address and payment method management',
      ],
      accent: Color(0xFF4C9A62),
      screenshots: [
        'assets/projects/flowerly_1.jpg',
        'assets/projects/flowerly_2.jpg',
        'assets/projects/flowerly_3.jpg',
        'assets/projects/flowerly_4.jpg',
      ],
      repoUrl: 'https://github.com/samer-aljammal/flowerly',
    ),
    Project(
      id: 'offers',
      name: 'Offers',
      tagline: 'Local marketplace for deals',
      description:
          'A two-sided marketplace for local offers. Vendors publish an '
          'offering with price, currency, category, stock and location; buyers '
          'browse the catalog with availability and stock shown up front, open '
          'a detail view with the average rating, and leave a rating of their '
          'own. Prices are currency-aware rather than dollar-only, and the app '
          'ships with language switching and a dark theme.',
      tech: ['Flutter', 'Dart', 'Multi-currency', 'Ratings'],
      highlights: [
        'Vendor-side publishing form with stock and currency selection',
        'Availability and stock surfaced on every offer card',
        'Star ratings with a per-offer average',
        'Language switching and dark mode',
      ],
      accent: Color(0xFFF2B01E),
      screenshots: [
        'assets/projects/offers_1.jpg',
        'assets/projects/offers_2.jpg',
        'assets/projects/offers_3.jpg',
        'assets/projects/offers_4.jpg',
      ],
      // Under a collaborator's account, and currently returning 404 — it is
      // private or the path has changed. Either publish it or drop this line;
      // a portfolio link that 404s costs more than a missing one.
      repoUrl: 'https://github.com/MHDN55/offers',
      isCollaboration: true,
    ),
  ];
}
