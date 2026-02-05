import 'package:flutter/material.dart';
import 'package:panduan/app/utils/app_colors.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    required this.label,
    this.labelSize,
    this.height = 40,
    this.width,
    this.onPressed,
    this.bgColor = AppColors.blueColor,
    this.fgColor,
    super.key,
  });

  final String label;
  final double? labelSize;
  final double height;
  final double? width;
  final void Function()? onPressed;
  final Color bgColor;
  final Color? fgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: fgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          minimumSize: Size.zero,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: labelSize,
              fontWeight: FontWeight.w500,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}

class BaseOutlineButton extends StatelessWidget {
  const BaseOutlineButton({
    required this.label,
    this.labelSize,
    this.height = 40,
    this.width,
    this.onPressed,
    this.borderColor = AppColors.blueColor,
    this.fgColor = AppColors.blueColor,
    super.key,
  });

  final String label;
  final double? labelSize;
  final double height;
  final double? width;
  final void Function()? onPressed;
  final Color borderColor;
  final Color fgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: fgColor,
          side: BorderSide(width: 1.3, color: borderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          minimumSize: Size.zero,
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: labelSize,
              fontWeight: FontWeight.w500,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}

class BaseButtonIcon extends StatelessWidget {
  const BaseButtonIcon({
    required this.icon,
    required this.label,
    this.iconSize,
    this.labelSize,
    this.height = 40,
    this.width,
    this.bgColor = AppColors.blueColor,
    this.fgColor,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final double? iconSize;
  final double? labelSize;
  final double height;
  final double? width;
  final Color bgColor;
  final Color? fgColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FilledButton.icon(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(bgColor),
          foregroundColor: WidgetStatePropertyAll(fgColor),
          iconColor: WidgetStatePropertyAll(fgColor),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10),
          ),
          overlayColor: WidgetStatePropertyAll(fgColor?.withValues(alpha: 0.1)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          minimumSize: const WidgetStatePropertyAll(Size.zero),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: labelSize,
              fontWeight: FontWeight.w500,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}

class BaseOutlineButtonIcon extends StatelessWidget {
  const BaseOutlineButtonIcon({
    required this.icon,
    required this.label,
    this.iconSize,
    this.labelSize,
    this.height = 40,
    this.width,
    this.borderColor = AppColors.blueColor,
    this.fgColor = AppColors.blueColor,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final String label;
  final double? iconSize;
  final double? labelSize;
  final double height;
  final double? width;
  final Color borderColor;
  final Color fgColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton.icon(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(fgColor),
          iconColor: WidgetStatePropertyAll(fgColor),
          overlayColor: WidgetStatePropertyAll(fgColor.withValues(alpha: 0.1)),
          side: WidgetStatePropertyAll(
            BorderSide(width: 1.3, color: borderColor),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 10),
          ),
          minimumSize: const WidgetStatePropertyAll(Size.zero),
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: iconSize),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: labelSize,
              fontWeight: FontWeight.w500,
              color: fgColor,
            ),
          ),
        ),
      ),
    );
  }
}
