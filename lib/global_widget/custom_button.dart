

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
  final bool iconRight;
  final Color? borderColor;

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
    this.iconRight = false,
    this.borderColor,
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
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (icon != null && !iconRight) ...[
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

            if (icon != null && iconRight) ...[
              const SizedBox(width: 6),
              Icon(icon, size: iconSize),
            ],
          ],
        ),
      ),
    );
  }
}

class CustomButton2 extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget textWidget;
  final TextStyle? textStyle;
  final EdgeInsets? padding;
  final double? elevation;
  final bool iconRight;
  final Color? borderColor;

  /// NEW
  final IconData? icon;
  final double? iconSize;

  const CustomButton2({
    super.key,
    required this.onPressed,
    this.width,
    this.height = 54,
    this.borderRadius,
    this.backgroundColor,
    this.foregroundColor = Colors.white,
    required this.textWidget,
    this.textStyle,
    this.padding,
    this.elevation = 0,
    this.icon,
    this.iconSize = 18,
    this.iconRight = false,
    this.borderColor,
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
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if (icon != null && !iconRight) ...[
              Icon(icon, size: iconSize),
              const SizedBox(width: 6),
            ],

            textWidget,

            if (icon != null && iconRight) ...[
              const SizedBox(width: 6),
              Icon(icon, size: iconSize),
            ],
          ],
        ),
      ),
    );
  }
}