import 'package:bloom/core/theme/app_colors.dart';
import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Darkness of the pink scrim over the background photo.
/// Raise it for more text contrast. At 0.55 white text is about 3.2:1.
const double kWelcomeScrimOpacity = 0.55;

TextStyle welcomeHeadline(BuildContext context, {bool long = false}) {
  final t = Theme.of(context).textTheme;
  final short = MediaQuery.sizeOf(context).height < 700;
  final base = (short || long) ? t.displayMedium! : t.displayLarge!;
  return base.copyWith(color: AppColor.softWhite, fontWeight: FontWeight.w800);
}

class WelcomeScaffold extends StatelessWidget {
  const WelcomeScaffold({super.key, required this.child, this.artwork});

  final Widget child;

  /// Optional hero layer. Must be a Positioned widget.
  final Widget? artwork;

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/bloom_bg.jpg', fit: BoxFit.cover),
          ColoredBox(
            color: AppColor.primaryDeep.withValues(alpha: kWelcomeScrimOpacity),
          ),
          if (artwork != null) artwork!,
          SafeArea(
            child: LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: box.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        r.screenPadding,
                        AppSpacing.standard,
                        r.screenPadding,
                        AppSpacing.group,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: r.contentMaxWidth,
                          ),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WelcomeLogo extends StatelessWidget {
  const WelcomeLogo({super.key, this.size = 60});
  final double size;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    'assets/images/bloom_logo.svg',
    width: size,
    height: size,
    semanticsLabel: 'Bloom',
    colorFilter: const ColorFilter.mode(AppColor.softWhite, BlendMode.srcIn),
  );
}

/// Round arrow button. No visible text. The label is for screen readers only.
class WelcomeArrowButton extends StatelessWidget {
  const WelcomeArrowButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    label: 'Next',
    excludeSemantics: true,
    child: Material(
      color: AppColor.deepPlum,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const SizedBox(
          width: 64,
          height: 64,
          child: Center(
            child: PhosphorIcon(
              PhosphorIcons.arrowRight,
              color: AppColor.softWhite,
              size: 24,
            ),
          ),
        ),
      ),
    ),
  );
}
