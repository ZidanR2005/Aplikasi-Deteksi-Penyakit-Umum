// lib/pages/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomePage(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
              Color(0xFF1976D2),
              Color(0xFF42A5F5),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon utama
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '🩺',
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scale(begin: const Offset(0.5, 0.5))
                  .then()
                  .shimmer(duration: 1200.ms),

              const SizedBox(height: 32),

              Text(
                'SISTEM PAKAR',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ).animate(delay: 400.ms).fadeIn().slideY(begin: 0.3, end: 0),

              Text(
                'Deteksi Penyakit Umum',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.9),
                  letterSpacing: 1,
                ),
              ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.3, end: 0),

              const SizedBox(height: 8),

              Text(
                'Metode Dempster-Shafer',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.white.withOpacity(0.7),
                  fontStyle: FontStyle.italic,
                ),
              ).animate(delay: 800.ms).fadeIn(),

              const SizedBox(height: 60),

              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ).animate(delay: 1000.ms).fadeIn(),

              const SizedBox(height: 20),

              Text(
                'Memuat aplikasi...',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.7),
                ),
              ).animate(delay: 1200.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}
