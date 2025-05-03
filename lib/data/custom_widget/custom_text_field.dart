import 'package:flutter/material.dart';
import '../consts/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final TextEditingController textFieldControl;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final int? maxLines;
  const CustomTextFormField({super.key,this.labelText, required this.textFieldControl, required this.keyboardType, this.validator, this.contentPadding, this.maxLines, this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textFieldControl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction, // Automatically validates when the user interacts
      validator: validator,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        labelText: labelText,
        hintText: hintText,
        hintStyle: TextStyle(color: grayColor),
        labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 16,color: grayColor),
        border: OutlineInputBorder(),
      ),
    );
  }
}
