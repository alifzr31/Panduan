import 'package:panduan/app/utils/app_strings.dart';
import 'package:panduan/app/views/update/widgets/update_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UpdatePage extends StatelessWidget {
  const UpdatePage({
    required this.isLoggedIn,
    required this.packageName,
    required this.currentVersion,
    required this.currentBuildNumber,
    required this.latestVersion,
    required this.latestBuildNumber,
    required this.updateDescription,
    required this.mandatoryUpdate,
    super.key,
  });

  final bool isLoggedIn;
  final String packageName;
  final String currentVersion;
  final int currentBuildNumber;
  final String latestVersion;
  final int latestBuildNumber;
  final String updateDescription;
  final bool mandatoryUpdate;

  static const String routeName = '/update';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: SvgPicture.asset(
                  '${AppStrings.assetsImages}/panduan-logo.svg',
                  width: 180,
                ),
              ),
              UpdateFooter(
                isLoggedIn: isLoggedIn,
                packageName: packageName,
                currentVersion: currentVersion,
                currentBuildNumber: currentBuildNumber,
                latestVersion: latestVersion,
                latestBuildNumber: latestBuildNumber,
                updateDescription: updateDescription,
                mandatoryUpdate: mandatoryUpdate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
