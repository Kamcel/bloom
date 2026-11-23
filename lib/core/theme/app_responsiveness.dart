import 'package:flutter/material.dart';

import 'app_breakpoint.dart';

/// Screen-size helpers. `Responsive.of(context)` or `context.responsive`.
class Responsive {
  const Responsive(this.width);
  factory Responsive.of(BuildContext context) =>
      Responsive(MediaQuery.sizeOf(context).width);

  final double width;

  ScreenSize get size => AppBreakpoint.of(width);
  bool get isCompact => size == ScreenSize.compact;
  bool get isMedium => size == ScreenSize.medium;
  bool get isExpanded => size == ScreenSize.expanded;

  T value<T>({required T compact, T? medium, T? expanded}) => switch (size) {
    ScreenSize.compact => compact,
    ScreenSize.medium => medium ?? compact,
    ScreenSize.expanded => expanded ?? medium ?? compact,
  };

  double get screenPadding => value(compact: 20, medium: 32, expanded: 48);
  double get contentMaxWidth =>
      value(compact: double.infinity, medium: 560, expanded: 640);
}

/// Centres content and limits its width on large screens.
class ResponsiveBody extends StatelessWidget {
  const ResponsiveBody({super.key, required this.child, this.padding = true});
  final Widget child;
  final bool padding;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: r.contentMaxWidth),
        child: padding
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: r.screenPadding),
                child: child,
              )
            : child,
      ),
    );
  }
}

abstract final class AppResponsiveness {
  /// Use in MaterialApp.builder. Applies the user's text-size setting on top of
  /// the system setting, and keeps the result in a readable range.
  static Widget wrap(
    BuildContext context,
    Widget? child, {
    double userTextScale = 1.0,
  }) {
    final media = MediaQuery.of(context);
    final factor = (media.textScaler.scale(1) * userTextScale)
        .clamp(0.9, 1.6)
        .toDouble();
    return MediaQuery(
      data: media.copyWith(textScaler: TextScaler.linear(factor)),
      child: child ?? const SizedBox.shrink(),
    );
  }
}
