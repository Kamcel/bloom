// import 'package:bloom/core/theme/app_dimension.dart';
// import 'package:bloom/core/theme/app_utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

// class OnboardingAppbar extends StatelessWidget implements PreferredSizeWidget {
//   final int currentStep;
//   final int totalSteps;
//   final VoidCallback? onBack;
//   const OnboardingAppbar({
//     super.key,
//     required this.currentStep,
//     required this.totalSteps,
//     this.onBack,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final textTheme = Theme.of(context).textTheme;

//     return SafeArea(
//       bottom: false,

//       child: Padding(
//         padding: EdgeInsets.fromLTRB(
//           AppSpacing.group,
//           AppSpacing.tight,
//           AppSpacing.group,
//           AppSpacing.tight,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             GestureDetector(
//               onTap: onBack,
//               behavior: HitTestBehavior.opaque,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(vertical: AppSpacing.tight),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     PhosphorIcon(
//                       PhosphorIcons.arrowLeft,
//                       size: 18,
//                       color: colors.onPrimary,
//                     ),
//                     const SizedBox(width: AppSpacing.tight),
//                     Text(
//                       'Back',
//                       style: textTheme.bodyMedium?.copyWith(
//                         color: colors.onPrimary,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Text(
//               'Step $currentStep of $totalSteps',
//               style: textTheme.bodyMedium?.copyWith(
//                 color: colors.onPrimary,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Gap.vMin,
//             Row(
//               children: List.generate(totalSteps, ((index) {
//                 final isCompletedOrActive = index < currentStep;
//                 return Expanded(
//                   child: Container(
//                     height: 4,
//                     margin: EdgeInsets.only(
//                       right: index == totalSteps - 1 ? 0 : AppSpacing.tight,
//                     ),
//                     decoration: BoxDecoration(
//                       color: isCompletedOrActive
//                           ? colors.primary
//                           : colors.primaryContainer,
//                       borderRadius: BorderRadius.circular(999),
//                     ),
//                   ),
//                 );
//               })),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(64);
// }

import 'package:bloom/core/theme/app_dimension.dart';
import 'package:bloom/core/theme/app_utils.dart';
import 'package:flutter/material.dart';

class OnboardingAppbar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;
  final int currentStep;
  final int totalSteps;
  const OnboardingAppbar({
    super.key,
    this.onBack,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.group,
          AppSpacing.tight,
          AppSpacing.group,
          AppSpacing.tight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: onBack,
                  child: Text(
                    'Back',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  'Step $currentStep of $totalSteps',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Gap.vStandard,
            Row(
              children: List.generate(totalSteps, (((index) {
                final isCompletedOrActive = index < currentStep;
                return Expanded(
                  child: Container(
                    height: 6,
                    margin: EdgeInsets.only(
                      right: index == totalSteps - 1 ? 0 : AppSpacing.tight,
                    ),
                    decoration: BoxDecoration(
                      color: isCompletedOrActive
                          ? colors.primary
                          : colors.primaryContainer,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                );
              }))),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
