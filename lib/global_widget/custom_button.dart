

import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String text;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final double? elevation;

  /// NEW
  final IconData? icon;
  final double? iconSize;

  const CustomButton({
    super.key,
    required this.onPressed,
    this.width,
    this.height = 54,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    required this.text,
    this.textStyle,
    this.padding,
    this.elevation = 0,
    this.icon,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: elevation,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            if (icon != null) ...[
              Icon(icon, size: iconSize),
              const SizedBox(width: 6),
            ],

            Text(
              text,
              style: textStyle ??
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}