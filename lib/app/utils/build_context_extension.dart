import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  double get deviceWidth => MediaQuery.sizeOf(this).width;

  double get deviceHeight => MediaQuery.sizeOf(this).height;

  EdgeInsets get devicePadding => MediaQuery.paddingOf(this);

  EdgeInsets get deviceViewPadding => MediaQuery.viewPaddingOf(this);

  double widthPct(double percent) => deviceWidth * (percent / 100);
  double heightPct(double percent) => deviceHeight * (percent / 100);
}
