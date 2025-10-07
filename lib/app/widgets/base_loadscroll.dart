import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:panduan/app/utils/app_strings.dart';

class BaseLoadScroll extends StatelessWidget {
  const BaseLoadScroll({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Center(
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAlias,
          elevation: 1,
          shape: const CircleBorder(),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Lottie.asset(
                '${AppStrings.assetsLotties}/panduan-logo-loader.json',
                width: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
