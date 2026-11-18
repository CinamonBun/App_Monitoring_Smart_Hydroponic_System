import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../services/hydroponic_service.dart';
import '../services/plant_storage_service.dart';
import 'main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _animController;
  late final AnimationController _exitController;

  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _exitFadeAnimation;

  String _loadingMessage = 'Memuat sistem hidroponik...';

  @override
  void initState() {
    super.initState();

    // Kontroler animasi masuk (intro)
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
          ),
        );

    // Kontroler animasi keluar (fade-out halus sebelum/saat pindah halaman)
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );

    _exitFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _exitController, curve: Curves.easeOutCubic),
    );

    _animController.forward();
    _startBootSequence();
  }

  Future<void> _startBootSequence() async {
    final stopwatch = Stopwatch()..start();

    try {
      // Langkah 1: Siapkan penyimpanan modul tanaman
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() => _loadingMessage = 'Menyiapkan modul & jadwal tanaman...');
      await PlantStorageService.loadPlantSlots();

      // Langkah 2: Hubungkan & ambil data awal sensor hidroponik
      if (!mounted) return;
      setState(() => _loadingMessage = 'Menghubungkan ke sensor...');
      await HydroponicService.instance.fetchSensorData();
    } catch (_) {
      // Abaikan error agar navigasi tetap berjalan normal
    }

    // Pastikan durasi splash screen minimal 2.0 detik agar animasi terasa mulus
    final elapsed = stopwatch.elapsedMilliseconds;
    const minSplashDuration = 2000;
    if (elapsed < minSplashDuration) {
      await Future.delayed(Duration(milliseconds: minSplashDuration - elapsed));
    }

    if (!mounted) return;

    // Fade out elemen splash screen dengan sangat halus
    await _exitController.forward();

    if (!mounted) return;

    // Transisi smooth fade ke MainScreen (durasi 800ms dengan kurva easeInOutCubic)
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curvedFade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOutCubic,
          );
          final curvedScale = Tween<double>(begin: 0.98, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          );

          return FadeTransition(
            opacity: curvedFade,
            child: ScaleTransition(scale: curvedScale, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.1, 0.65, 1.0],
            colors: [Color(0xFF143B4E), Color(0xFF1F5975), Color(0xFF2B7A9B)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _exitFadeAnimation,
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Logo & Judul Animasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge Logo Glassmorphism
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.28),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0A222C).withOpacity(0.4),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                              BoxShadow(
                                color: kWaterAccent.withOpacity(0.35),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ikon Tetesan Air di latar
                              Positioned(
                                top: 24,
                                child: Icon(
                                  Icons.water_drop_rounded,
                                  size: 54,
                                  color: const Color(0xFF7CE4FF)
                                      .withOpacity(0.45),
                                ),
                              ),
                              // Ikon Daun Hidroponik di depan
                              const Positioned(
                                bottom: 22,
                                child: Icon(
                                  Icons.eco_rounded,
                                  size: 48,
                                  color: Color(0xFF69F0AE),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Teks Judul Aplikasi
                        SlideTransition(
                          position: _slideAnimation,
                          child: Column(
                            children: [
                              const Text(
                                'Smart Hydroponic',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: const Text(
                                  'SISTEM MONITORING & NUTRISI OTOMATIS',
                                  style: TextStyle(
                                    color: Color(0xFFD6F3FF),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 3),

                // Indikator Loading & Status
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 160,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: const LinearProgressIndicator(
                              minHeight: 4,
                              backgroundColor: Color(0x33FFFFFF),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF69F0AE),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          _loadingMessage,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // Footer Versi Aplikasi
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      'v1.0.0 • IoT Smart Agriculture',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.45),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
