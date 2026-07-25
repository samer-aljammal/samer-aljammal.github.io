import 'package:flutter/material.dart';

import '../core/di/service_locator.dart';
import '../core/theme/app_theme.dart';
import '../features/home/presentation/home_page.dart';

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String name = ServiceLocator.profile.getProfile().name;

    return MaterialApp(
      title: '$name — Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark(),
      home: const HomePage(),
      // The site is one page with anchored sections, so there is no router. Add
      // one only when a section needs its own URL.
    );
  }
}
