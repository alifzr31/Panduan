import 'package:flutter/cupertino.dart';
import 'package:panduan/app/utils/app_colors.dart';

class BaseTextButton extends StatelessWidget {
  const BaseTextButton({
    super.key,
    required this.text,
    this.color = AppColors.amberColor,
    this.size = 12,
    this.decoration,
    this.onPressed,
  });

  final String text;
  final Color color;
  final double size;
  final TextDecoration? decoration;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      alignment: Alignment.center,
      minimumSize: Size.zero,
      padding: const EdgeInsets.all(2),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          fontFamily: 'Jost',
          fontWeight: FontWeight.w500,
          decoration: decoration,
          color: color,
        ),
      ),
    );
  }
}
