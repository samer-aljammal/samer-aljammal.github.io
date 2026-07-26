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
      tech: ['Flutter', 'Localization (EN/AR)', 'Live map tracking', 'Payments'],
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
