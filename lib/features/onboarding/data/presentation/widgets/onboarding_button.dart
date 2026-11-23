import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  const OnboardingButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
