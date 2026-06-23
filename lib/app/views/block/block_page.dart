import 'dart:io' show exit, Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:panduan/app/utils/app_strings.dart';
import 'package:panduan/app/widgets/base_button.dart';

class BlockPage extends StatelessWidget {
  const BlockPage({super.key});

  static const String routeName = '/block';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        SystemNavigator.pop();
        exit(0);
      },
      child: Scaffold(
        body: Center(
          child: SafeArea(
            child: Padding(
              padding: const .all(16),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: .center,
                      children: [
                        Material(
                          color: Colors.white,
                          elevation: 1,
                          clipBehavior: .antiAlias,
                          borderRadius: .circular(16),
                          child: Padding(
                            padding: const .all(12),
                            child: SvgPicture.asset(
                              '${AppStrings.assetsIcons}/block.svg',
                              width: 60,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: .infinity,
                          child: Material(
                            elevation: 1,
                            color: Colors.white,
                            clipBehavior: .antiAlias,
                            borderRadius: .circular(10),
                            child: Padding(
                              padding: const .all(16),
                              child: Column(
                                children: [
                                  const Text(
                                    'Aplikasi Tidak Aman',
                                    textAlign: .center,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: .w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Demi keamanan data, aplikasi tidak dapat dijalankan karena perangkat terdeteksi dimodifikasi atau aplikasi diunduh dari luar sumber resmi.',
                                    textAlign: .center,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  if (Platform.isAndroid) ...{
                                    Padding(
                                      padding: const .symmetric(vertical: 10),
                                      child: Divider(
                                        height: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    BaseButton(
                                      height: 36,
                                      width: .infinity,
                                      label: 'Tutup Aplikasi',
                                      labelSize: 12,
                                      onPressed: () {
                                        SystemNavigator.pop();
                                        exit(0);
                                      },
                                    ),
                                  },
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '© ${DateTime.now().year} Pemerintah Kota Bandung',
                    textAlign: .center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: .w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
