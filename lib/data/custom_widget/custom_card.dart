import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final AlignmentGeometry? alignment;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? color;
  final Gradient? gradient;
  final double? borderRadius;
  final BorderRadius? borderRadiusOnly;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final Widget? child;
  final DecorationImage? bgImage;

  const CustomCard({
    Key? key,
    this.alignment,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.gradient,
    this.borderRadius,
    this.borderRadiusOnly,
    this.border,
    this.boxShadow,
    this.child,
    this.bgImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: width,
        height: height,
        padding: padding,
        alignment: alignment,
        decoration: BoxDecoration(
          gradient: gradient,
          color: color,
          borderRadius:
          borderRadiusOnly ?? BorderRadius.circular(borderRadius ?? 0),
          image: bgImage,
          border: border ?? Border.all(color: Colors.transparent),
          boxShadow: boxShadow,
        ),
        child: child ?? const SizedBox(),
      ),
    );
  }
}
