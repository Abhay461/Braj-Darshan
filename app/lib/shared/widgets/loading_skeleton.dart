import 'package:flutter/material.dart';

class LoadingSkeleton extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;

  const LoadingSkeleton({
    super.key,
    this.height = 100,
    this.width = double.infinity,
    this.borderRadius = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFFE4E4E7).withOpacity(0.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
