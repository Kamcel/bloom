import 'package:flutter/material.dart';

class AuthTextfield extends StatelessWidget {
  final String? iconName;
  final String? label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final InputDecoration? inputDecoration;
  final ValueChanged<String>? onChanged;

  const AuthTextfield({
    super.key,
    this.iconName,
    this.label,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.textInputAction,
    this.inputDecoration,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveDecoration = (inputDecoration ?? const InputDecoration())
        .copyWith(
          labelText:
              inputDecoration?.labelText ??
              (label != null && label!.isNotEmpty ? label : null),
        );

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: effectiveDecoration,
    );
  }
}
