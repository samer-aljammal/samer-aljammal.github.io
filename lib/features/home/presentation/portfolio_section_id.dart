/// The scrollable anchors on the single-page site.
///
/// Order matters: it drives the nav order and the active-section calculation.
enum PortfolioSectionId {
  home('Home'),
  about('About'),
  work('Work'),
  contact('Contact');

  const PortfolioSectionId(this.label);

  final String label;
}
