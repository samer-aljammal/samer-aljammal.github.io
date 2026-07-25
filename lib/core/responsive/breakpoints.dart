import 'package:flutter/widgets.dart';

enum ScreenSize { mobile, tablet, desktop }

abstract final class Breakpoints {
  const Breakpoints._();

  static const double mobile = 720;
  static const double tablet = 1100;

  /// Content never stretches past this, regardless of monitor width.
  static const double maxContentWidth = 1180;
}

extension ResponsiveContext on BuildContext {
  Size get screen => MediaQuery.sizeOf(this);

  ScreenSize get screenSize {
    final double width = screen.width;
    if (width < Breakpoints.mobile) return ScreenSize.mobile;
    if (width < Breakpoints.tablet) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  bool get isMobile => screenSize == ScreenSize.mobile;
  bool get isTablet => screenSize == ScreenSize.tablet;
  bool get isDesktop => screenSize == ScreenSize.desktop;

  /// True where side-by-side (phone + copy) layouts still fit.
  bool get isWide => screenSize == ScreenSize.desktop;

  /// Picks a value per breakpoint, falling back down the chain.
  T responsive<T>({required T mobile, T? tablet, T? desktop}) =>
      switch (screenSize) {
        ScreenSize.mobile => mobile,
        ScreenSize.tablet => tablet ?? mobile,
        ScreenSize.desktop => desktop ?? tablet ?? mobile,
      };

  /// Horizontal page gutter.
  double get gutter => responsive(mobile: 20, tablet: 40, desktop: 64);

  /// Vertical rhythm between major sections.
  double get sectionSpacing => responsive(mobile: 88, tablet: 120, desktop: 160);
}
