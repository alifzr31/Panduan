import 'package:flutter/material.dart';

class BaseListTile extends StatelessWidget {
  const BaseListTile({
    required this.title,
    this.titleColor = Colors.black,
    this.subtitle,
    this.subtitleColor,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  final String title;
  final Color titleColor;
  final String? subtitle;
  final Color? subtitleColor;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      horizontalTitleGap: 8,
      onTap: onTap,
      leading: leading,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle ?? '',
              style: TextStyle(fontSize: 12, color: subtitleColor),
            ),
      trailing: trailing,
    );
  }
}
