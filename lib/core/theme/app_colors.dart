import 'package:flutter/material.dart';

/// Prismatic light through obsidian.
///
/// The canvas is obsidian rather than pure black, and content sits on bands of
/// cool slate — that tonal step is what stops the page reading as a dead flat
/// void. All type is a single warm off-white; the only muted tone is a fog
/// blue for metadata.
///
/// Colour proper exists in exactly one place: the prism artifact. Red, cyan and
/// lime are channel-split edges inside that illustration and must never become
/// UI tokens — no coloured buttons, no coloured badges, no gradient text. The
/// restraint is what makes the prism read as light rather than decoration.
abstract final class AppColors {
  const AppColors._();

  // --- Surfaces -----------------------------------------------------------

  /// Page canvas. Deep, but not #000 — pure black is what flattens a dark page.
  static const Color obsidian = Color(0xFF101010);

  /// Cool slate band behind content sections. The lift that gives the canvas
  /// depth. Never go lighter than this or bone-white type loses its footing.
  static const Color graphiteVeil = Color(0xFF495764);

  /// Midpoint between canvas and veil, for gradient transitions between bands.
  static const Color slateShadow = Color(0xFF1E252C);

  // --- Type ---------------------------------------------------------------

  /// Every piece of type and UI chrome on the dark canvas.
  static const Color bone = Color(0xFFFFFDF9);

  /// De-emphasised metadata: taxonomy labels, captions, inactive nav.
  static const Color fog = Color(0xFF6F879C);

  /// Lighter fog for metadata sitting on the slate band, where plain fog is
  /// too close to its background.
  static const Color fogOnVeil = Color(0xFFC3CED8);

  // --- Lines --------------------------------------------------------------

  /// Hairline dividers and card outlines. Barely visible by design.
  static const Color ashBorder = Color(0xFF403F3F);

  /// Border on the slate band, where ash disappears.
  static const Color ashOnVeil = Color(0x33FFFDF9);

  /// Hover state for any hairline. Brightened, never coloured.
  static const Color ashBright = Color(0x66FFFDF9);

  // --- Prism --------------------------------------------------------------
  // Illustration only. Using these on UI breaks the entire system.

  static const Color prismRed = Color(0xFFFF2A2A);
  static const Color prismCyan = Color(0xFF2A7FFF);
  static const Color prismLime = Color(0xFF2AFF2A);

  /// The three dispersion channels in draw order.
  static const List<Color> prism = [prismRed, prismLime, prismCyan];
}
