import 'package:flutter/material.dart';

class LightCard extends StatelessWidget {
  const LightCard({
    super.key,
    required this.child,
    this.width = 340,
    this.padding = const EdgeInsets.all(24),
    this.color = const Color(0xFFF4FBFF),
  });

  final Widget child;
  final double width;
  final EdgeInsets padding;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF237497).withOpacity(0.12),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
