import 'package:flutter/cupertino.dart';
import 'package:panduan/app/utils/app_colors.dart';

class BaseIconButton extends StatelessWidget {
  const BaseIconButton({
    super.key,
    required this.icon,
    this.size,
    this.color = AppColors.pinkColor,
    this.onPressed,
  });

  final IconData icon;
  final double? size;
  final Color color;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      alignment: Alignment.center,
      minimumSize: Size.zero,
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Icon(icon, size: size, color: color),
    );
  }
}
