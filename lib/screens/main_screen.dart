import 'package:flutter/material.dart';

import '../widgets/floating_menu.dart';
import 'dashboard_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _menuIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _menuIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onMenuSelect(int index) {
    if (_menuIndex == index) return;
    setState(() => _menuIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeInOutCubic,
    );
  }

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
            PageView(
              controller: _pageController,
              onPageChanged: (index) {
                if (_menuIndex != index) {
                  setState(() => _menuIndex = index);
                }
              },
              children: const [
                DashboardScreen(),
                HistoryScreen(),
                ProfileScreen(),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 28),
                child: FloatingMenu(
                  selectedIndex: _menuIndex,
                  onSelect: _onMenuSelect,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
