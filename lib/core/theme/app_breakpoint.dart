/// Window size classes (Material 3). Compact = phones.
enum ScreenSize { compact, medium, expanded }

abstract final class AppBreakpoint {
  static const double medium =
      600; // large phones in landscape, foldables, small tablets
  static const double expanded = 840; // tablets and larger

  static ScreenSize of(double width) {
    if (width >= expanded) return ScreenSize.expanded;
    if (width >= medium) return ScreenSize.medium;
    return ScreenSize.compact;
  }
}
