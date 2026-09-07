import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

const _warnAmber = Color(0xFFE8A317);
const _waterAccent = Color(0xFF5BA8C4);
const _darkText = Color(0xFF222424);
const _mutedDark = Color(0xFF2F647B);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Urbanist'),
      home: const _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  int _menuIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.3, 1.0, 2.0],
          colors: [Color(0xFF237497), Color(0xFFCEEFFE), Color(0xFFEDFAFF)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 120),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DarkGlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Avg Water Temperature',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.thermostat,
                              color: Colors.white.withOpacity(0.9),
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 80,
                          width: double.infinity,
                          child: CustomPaint(painter: _WavePainter()),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '28°C',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Max',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Min',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '40°',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '18°',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _DarkGlassCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Avg pH Level',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.95),
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.sync,
                              color: Colors.white.withOpacity(0.9),
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final progress = 0.38;
                            return Stack(
                              alignment: Alignment.centerLeft,
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  height: 6,
                                  width: width,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.22),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                                Container(
                                  height: 6,
                                  width: width * progress,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFFFFFFF),
                                    borderRadius: BorderRadius.circular(3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFFFFFFF).withOpacity(0.7),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: (width * progress) - 1,
                                  top: -18,
                                  bottom: -30,
                                  child: Container(
                                    width: 1.8,
                                    color: Colors.white.withOpacity(0.35),
                                  ),
                                ),
                                Positioned(
                                  left: (width * progress) - 8,
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF567D91),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.75),
                                        width: 2.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '7',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              '14',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.55),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '9',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 52,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                              ),
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Max',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Min',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.55),
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '10',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '8',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _LightCard(
                        width: 160,
                        padding: EdgeInsets.all(18),
                        color: Color(0xFFF4FBFF),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.science, color: _mutedDark, size: 20),
                                Icon(Icons.sync, color: _mutedDark, size: 16),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'TDS Level',
                              style: TextStyle(
                                color: _darkText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            _MetricBar(
                              progress: 0.6,
                              color: _warnAmber,
                              trackColor: Color(0x14237497),
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '600',
                                  style: TextStyle(
                                    color: _darkText,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'ppm',
                                  style: TextStyle(
                                    color: _mutedDark,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16),
                      _LightCard(
                        width: 160,
                        padding: EdgeInsets.all(18),
                        color: Color(0xFFF4FBFF),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.water, color: _mutedDark, size: 20),
                                Icon(Icons.sync, color: _mutedDark, size: 16),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Water Level',
                              style: TextStyle(
                                color: _darkText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 16),
                            _MetricBar(
                              progress: 0.8,
                              color: _waterAccent,
                              trackColor: Color(0x14237497),
                            ),
                            SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '75',
                                  style: TextStyle(
                                    color: _darkText,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w600,
                                    height: 1.0,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '%',
                                  style: TextStyle(
                                    color: _mutedDark,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: _DummyFloatingMenu(
                  selectedIndex: _menuIndex,
                  onSelect: (index) => setState(() => _menuIndex = index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DummyFloatingMenu extends StatelessWidget {
  const _DummyFloatingMenu({
    required this.selectedIndex,
    required this.onSelect,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  static const _items = [
    Icons.home_rounded,
    Icons.bar_chart_rounded,
    Icons.notifications_none_rounded,
    Icons.settings_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF1A3B47).withOpacity(0.55),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withOpacity(0.16)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < _items.length; i++)
                _DummyMenuItem(
                  icon: _items[i],
                  selected: selectedIndex == i,
                  onTap: () => onSelect(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DummyMenuItem extends StatelessWidget {
  const _DummyMenuItem({
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
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.92) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 22,
          color: selected ? _darkText : Colors.white.withOpacity(0.75),
        ),
      ),
    );
  }
}

class _DarkGlassCard extends StatelessWidget {
  const _DarkGlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          width: 340,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF1A3B47).withOpacity(0.48),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: Colors.white.withOpacity(0.16),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _LightCard extends StatelessWidget {
  const _LightCard({
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
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF237497).withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _MetricBar extends StatelessWidget {
  const _MetricBar({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  final double progress;
  final Color color;
  final Color trackColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: trackColor,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        FractionallySizedBox(
          widthFactor: progress,
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.4,
      size.width * 0.4,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.65,
      size.height * 1.1,
      size.width * 0.75,
      size.height * 0.2,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      -size.height * 0.3,
      size.width,
      size.height * 0.5,
    );

    final paint = Paint()
      ..color = const Color(0xFFffffff)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(path, paint);

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFFffffff).withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final dotPaint = Paint()..color = const Color(0xFF567D91);
    final dotBorder = Paint()
      ..color = Colors.white.withOpacity(0.75)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.2),
      6,
      dotPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.2),
      6,
      dotBorder,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
