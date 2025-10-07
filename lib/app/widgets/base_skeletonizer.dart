import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BaseSkeletonizer extends StatelessWidget {
  const BaseSkeletonizer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(duration: Duration(milliseconds: 600)),
      child: child,
    );
  }
}
