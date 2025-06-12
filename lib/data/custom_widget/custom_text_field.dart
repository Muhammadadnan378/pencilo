import 'package:flutter/material.dart';
import '../consts/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool? isEditable;  // Added this field to control if the field is editable
  final VoidCallback? onTap;  // Added onTap callback
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Color? borderColor;


  const CustomTextFormField({
    super.key,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.validator,
    this.contentPadding,
    this.maxLines,
    this.hintText,
    this.focusNode,
    this.isEditable = true,  // Default to true, meaning the text field is editable
    this.onTap,
    this.labelStyle,
    this.hintStyle,
    this.suffixIcon,
    this.onChanged,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditable! ? null : onTap,  // If the field is not editable, trigger onTap
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        enabled: isEditable,  // Make the field non-editable if isEditable is false
        readOnly: !isEditable!,  // Also, make the field read-only when not editable
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon ?? SizedBox(),
          hintStyle: hintStyle ?? TextStyle(color: grayColor),
          labelStyle: labelStyle ?? TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: grayColor),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? blackColor),  // Always set border color to black
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? blackColor),  // Always set border color to black
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? blackColor),  // Always set border color to black
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? Colors.red),  // Always set border color to black
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? blackColor),  // Always set border color to black
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor ?? blackColor),  // Always set border color to black
          )
        ),
      ),
    );
  }
}
