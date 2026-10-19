import 'package:flutter/material.dart';

class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({super.key, this.height = 110});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFE8ECE5),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
