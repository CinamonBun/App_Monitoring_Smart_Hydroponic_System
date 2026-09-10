import 'dart:ui';

import 'package:flutter/material.dart';

import '../constants/colors.dart';

class FloatingMenu extends StatelessWidget {
  const FloatingMenu({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _items = [
    Icons.home_rounded,
    Icons.history_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    const double menuWidth = 250;
    const double horizontalPadding = 8;
    const double verticalPadding = 8;
    const double innerWidth = menuWidth - (horizontalPadding * 2);
    const double itemWidth = innerWidth / 3;
    const double indicatorWidth = 54;
    const double indicatorHeight = 44;

    final double indicatorLeft =
        (selectedIndex * itemWidth) + ((itemWidth - indicatorWidth) / 2);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: menuWidth,
          height: 60,
          padding: const EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF1A3B47).withOpacity(0.55),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0C242E).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Smooth sliding indicator pill
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                left: indicatorLeft,
                top: (44 - indicatorHeight) / 2,
                width: indicatorWidth,
                height: indicatorHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              // Menu items row
              Row(
                children: [
                  for (var i = 0; i < _items.length; i++)
                    Expanded(
                      child: _FloatingMenuItem(
                        icon: _items[i],
                        selected: selectedIndex == i,
                        onTap: () => onSelect(i),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingMenuItem extends StatelessWidget {
  const _FloatingMenuItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 44,
        child: Center(
          child: AnimatedScale(
            scale: selected ? 1.15 : 1.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            child: TweenAnimationBuilder<Color?>(
              tween: ColorTween(
                end: selected ? kDarkText : Colors.white.withOpacity(0.75),
              ),
              duration: const Duration(milliseconds: 250),
              builder: (context, color, child) {
                return Icon(icon, size: 22, color: color);
              },
            ),
          ),
        ),
      ),
    );
  }
}
