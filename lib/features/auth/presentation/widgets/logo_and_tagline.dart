import 'package:bloom/core/theme/app_dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LogoAndTagline extends StatelessWidget {
  final String logoUrl;
  final String tagline;
  final TextStyle? style;
  const LogoAndTagline({
    super.key,
    required this.logoUrl,
    required this.tagline,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.headlineMedium
        ?.copyWith(fontWeight: FontWeight.w600);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(logoUrl, fit: BoxFit.contain, height: 100, width: 100),
        SizedBox(height: AppSpacing.standard),
        Text(
          tagline,
          style: defaultStyle?.merge(style) ?? style,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
