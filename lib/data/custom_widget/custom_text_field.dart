import 'package:flutter/material.dart';
import '../consts/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController? textFieldControl;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  final FocusNode? focusNode;
  final bool? isEditable;  // Added this field to control if the field is editable
  final VoidCallback? onTap;  // Added onTap callback
  final TextStyle? lableStyle;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    this.labelText,
    this.textFieldControl,
    this.keyboardType,
    this.validator,
    this.contentPadding,
    this.maxLines,
    this.hintText,
    this.focusNode,
    this.isEditable = true,  // Default to true, meaning the text field is editable
    this.onTap,
    this.lableStyle,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditable! ? null : onTap,  // If the field is not editable, trigger onTap
      child: TextFormField(
        controller: textFieldControl,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        enabled: isEditable,  // Make the field non-editable if isEditable is false
        readOnly: !isEditable!,  // Also, make the field read-only when not editable
        decoration: InputDecoration(
          contentPadding: contentPadding,
          labelText: labelText,
          hintText: hintText,
          suffixIcon: suffixIcon ?? SizedBox(),
          hintStyle: TextStyle(color: grayColor),
          labelStyle: lableStyle ?? TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: grayColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: blackColor),  // Always set border color to black
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blackColor),  // Always set border color to black
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),  // Always set border color to black
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blackColor),  // Always set border color to black
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: blackColor),  // Always set border color to black
          )
        ),
      ),
    );
  }
}
