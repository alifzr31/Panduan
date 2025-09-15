import 'package:flutter/material.dart';

PageRoute customPageRouteBuilder(
  RouteSettings settings, {
  bool bottomSafeArea = true,
  required Widget child,
}) {
  return MaterialPageRoute(
    settings: settings,
    builder: (context) {
      return SafeArea(top: false, bottom: bottomSafeArea, child: child);
    },
  );
}
