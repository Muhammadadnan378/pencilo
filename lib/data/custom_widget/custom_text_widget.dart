import 'package:flutter/material.dart';
import '../../data/consts/colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? size;
  final double? height;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final Color? color;
  final String? fontFamily;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;

  const CustomText({
    Key? key,
    required this.text,
    this.size,
    this.height,
    this.textAlign,
    this.fontWeight,
    this.color,
    this.fontFamily,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? whiteColor,
        fontSize: size,
        fontWeight: fontWeight,
        fontFamily: fontFamily,
        height: height,
        shadows: [
          Shadow(
            color: shadowColor ?? Colors.black,
            blurRadius: shadowBlurRadius ?? 0.0,
            offset: shadowOffset ?? const Offset(0, 0),
          ),
        ],
        letterSpacing: letterSpacing,
      ),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines ?? 100,
      overflow: overflow ?? TextOverflow.ellipsis,
    );
  }
}
