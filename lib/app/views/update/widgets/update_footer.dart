import 'package:flutter/foundation.dart';
import 'package:panduan/app/utils/app_colors.dart';
import 'package:panduan/app/views/dashboard/dashboard_page.dart';
import 'package:panduan/app/views/login/login_page.dart';
import 'package:panduan/app/widgets/base_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateFooter extends StatelessWidget {
  const UpdateFooter({
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

  @override
  Widget build(BuildContext context) {
    print(mandatoryUpdate);

    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pembaruan Tersedia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(
                    context,
                  ).style.copyWith(fontSize: 12),
                  children: [
                    const TextSpan(text: 'Versi Sekarang : '),
                    TextSpan(
                      text: currentVersion,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(
                    context,
                  ).style.copyWith(fontSize: 12),
                  children: [
                    const TextSpan(text: 'Versi Terbaru : '),
                    TextSpan(
                      text: latestVersion,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.greyFormField,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Deskripsi :', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 2),
                    Text(
                      updateDescription,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 40,
          width: double.infinity,
          child: BaseButton(
            label: 'Perbarui Sekarang',
            onPressed: () async {
              final url = Uri.parse(
                'https://play.google.com/store/apps/details?id=$packageName',
              );

              try {
                await launchUrl(url);
              } catch (e) {
                if (kDebugMode) print(e);
              }
            },
          ),
        ),
        if (!mandatoryUpdate) ...{
          const SizedBox(height: 10),
          SizedBox(
            height: 40,
            width: double.infinity,
            child: BaseOutlineButton(
              borderColor: AppColors.amberColor,
              fgColor: AppColors.amberColor,
              label: 'Nanti Saja',
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  isLoggedIn ? DashboardPage.routeName : LoginPage.routeName,
                );
              },
            ),
          ),
        },
      ],
    );
  }
}
