import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final bool? obscureText;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(String)? onChanged;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.obscureText,
    this.onChanged,
    this.contentPadding,
    this.hintStyle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyle(color: Colors.white54), // Hint text style
        labelStyle: const TextStyle(color: Colors.white), // Label text color
        prefixIcon: prefixIcon ?? const SizedBox(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white), // Default border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 1.5), // White border when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white, width: 2.0), // White border when focused
        ),
      ),
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      style: const TextStyle(color: Colors.white), // Text input color
    );
  }
}
