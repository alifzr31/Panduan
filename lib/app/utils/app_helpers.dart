import 'package:flutter/material.dart';

class AppHelpers {
  static double getHeightDevice(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double getWidthDevice(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getBottomViewPaddingDevice(BuildContext context) {
    return MediaQuery.of(context).viewPadding.bottom;
  }

  static Map<String, dynamic> addOnHeaders() {
    return {'Content-type': 'application/json', 'Accept': 'application/json'};
  }
}
