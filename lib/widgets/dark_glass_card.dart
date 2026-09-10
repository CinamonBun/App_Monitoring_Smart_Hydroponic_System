import 'dart:ui';
import 'package:flutter/material.dart';

class DarkGlassCard extends StatelessWidget {
  const DarkGlassCard({
    super.key,
    required this.child,
    this.width = 340,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final double width;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          width: width,
          padding: padding,
          decoration: BoxDecoration(
            color: const Color(0xFF1A3B47).withOpacity(0.48),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: child,
        ),
      ),
    );
  }
}
