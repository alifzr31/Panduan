import 'package:flutter/material.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/widgets/base_button.dart';

class MapLocationHandle extends StatelessWidget {
  const MapLocationHandle({
    required this.icon,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressedButton,
    super.key,
  });

  final IconData icon;
  final String title;
  final String description;
  final String buttonLabel;
  final void Function() onPressedButton;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: AppColors.blueColor),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            BaseButton(
              height: 36,
              label: buttonLabel,
              labelSize: 12,
              onPressed: onPressedButton,
            ),
          ],
        ),
      ),
    );
  }
}
