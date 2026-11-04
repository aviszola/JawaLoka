import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/screens/language_selection_screen.dart';
import '../widgets/animated_loading_dots.dart';
import '../widgets/animated_logo_card.dart';
import '../widgets/batik_kawung_painter.dart';
import '../widgets/javanese_glyph_painter.dart';
import '../widgets/javanese_landscape_painter.dart';

/// JawaLoka Splash Screen.
/// Pixel-accurate implementation of Google Stitch Project #17251431980647989546
/// Screen #556120f80baf469ba46efa7fc181d3b6.
///
/// Features:
/// - Traditional Kawung Batik texture overlay
/// - Ghosted Aksara Jawa "ꦗ" background watermark
/// - Centered Logo Tile (96x96, 28px radius, diffused soft shadows)
/// - Stylized Aksara Jawa glyph "ꦗ" (Ja) with vector precision fallback
/// - Wordmark "JawaLoka" & Tagline
/// - Animated 3-dot traveling wave loading indicator
/// - High-fidelity vector panorama: Mount Merapi/Lawu, sunrise aura, 4-tier terraced rice fields
/// - Staggered entrance and continuous organic floating animations
class SplashScreen extends StatefulWidget {
  final bool autoNavigate;
  final Duration displayDuration;

  const SplashScreen({
    super.key,
    this.autoNavigate = true,
    this.displayDuration = const Duration(milliseconds: 3800),
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _ambientController;

  late final Animation<double> _kawungAnimation;
  late final Animation<double> _watermarkAnimation;
  late final Animation<double> _landscapeEntrance;
  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;
  late final Animation<double> _dotsFadeAnimation;

  Timer? _navigationTimer;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();

    // Set immersive status bar styling matching warm amber theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.terraceTier4,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // 1. Staggered Entrance Controller (2200ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // 2. Continuous Ambient Controller (3000ms loop for floating, sun aura, dots wave)
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat();

    // Staggered animation curves
    _kawungAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );

    _watermarkAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.1, 0.55, curve: Curves.easeOut),
    );

    _landscapeEntrance = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.15, 0.70, curve: Curves.easeOutCubic),
    );

    _logoScaleAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.35, 0.78, curve: Curves.easeOutBack),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.50, 0.85, curve: Curves.easeOut),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.50, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _dotsFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.68, 0.95, curve: Curves.easeIn),
    );

    // Start entrance animation
    _entranceController.forward();

    // Auto-advance to Home/Learning screen after loading duration
    if (widget.autoNavigate) {
      _navigationTimer = Timer(widget.displayDuration, _navigateToHome);
    }
  }

  void _navigateToHome() {
    if (_hasNavigated || !mounted) return;
    _hasNavigated = true;
    _navigationTimer?.cancel();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LanguageSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _entranceController.dispose();
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: Center(
        child: GestureDetector(
          onTap: _navigateToHome,
          behavior: HitTestBehavior.opaque,
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 412,
              maxHeight: 892,
            ),
            decoration: BoxDecoration(
              color: AppColors.amber,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 40,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: Listenable.merge([_entranceController, _ambientController]),
              builder: (context, _) {
                return Stack(
                  children: [
                    // Layer 1: Traditional Kawung Batik pattern overlay
                    Positioned.fill(
                      child: RepaintBoundary(
                        child: CustomPaint(
                          painter: BatikKawungPainter(
                            animationProgress: _kawungAnimation.value,
                            opacity: 0.075,
                          ),
                        ),
                      ),
                    ),

                    // Layer 2: Ghosted Aksara Jawa "ꦗ" Watermark in upper right
                    Positioned(
                      top: 100,
                      right: -35,
                      child: Opacity(
                        opacity: 0.05 * _watermarkAnimation.value,
                        child: Transform.rotate(
                          angle: -10 * math.pi / 180,
                          child: const JavaneseGlyphWidget(
                            size: 260,
                            color: AppColors.ink,
                            isGhost: true,
                          ),
                        ),
                      ),
                    ),

                    // Layer 3: Main UI Content (Status bar, Brand block, Loading & Landscape)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top Android Status Bar Area
                        _buildStatusBarArea(),

                        // Center Brand Block (Logo, Wordmark, Tagline)
                        Expanded(
                          child: _buildCenterBrandBlock(),
                        ),

                        // Bottom Section (Loading Dots, Terraced Landscape & Nav Bar)
                        _buildBottomSection(),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// Android Status Bar Area (09:41, Signal, Wifi, Battery)
  Widget _buildStatusBarArea() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '09:41',
              style: TextStyle(
                color: AppColors.ink,
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
            ),
            Row(
              children: [
                // Cellular Signal Icon
                Icon(
                  Icons.signal_cellular_alt_rounded,
                  size: 15.0,
                  color: AppColors.ink.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 4),
                // Wifi Icon
                Icon(
                  Icons.wifi_rounded,
                  size: 15.0,
                  color: AppColors.ink.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 4),
                // Battery Icon
                Transform.rotate(
                  angle: math.pi / 2,
                  child: Icon(
                    Icons.battery_full_rounded,
                    size: 16.0,
                    color: AppColors.ink.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Center Brand Block: Animated Logo Tile + Wordmark + Tagline
  Widget _buildCenterBrandBlock() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo Tile with soft diffused shadow & floating oscillation
        AnimatedLogoCard(
          scaleProgress: _logoScaleAnimation.value,
          floatPhase: _ambientController.value,
        ),
        const SizedBox(height: 24),

        // Brand Wordmark & Tagline with slide up and fade in
        SlideTransition(
          position: _textSlideAnimation,
          child: FadeTransition(
            opacity: _textFadeAnimation,
            child: Column(
              children: [
                const Text(
                  AppStrings.appName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 36.0,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    AppStrings.appTagline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.ink.withValues(alpha: 0.72),
                      fontSize: 14.0,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Bottom Section: 3 Pulsing Wave Loading Dots + Panoramic Landscape + Navigation Indicator
  Widget _buildBottomSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 3 Animated Loading Dots with continuous traveling wave
        FadeTransition(
          opacity: _dotsFadeAnimation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: AnimatedLoadingDots(
              animationValue: _ambientController.value,
            ),
          ),
        ),

        // Flat Landscape Illustration (Merapi volcano, sunrise, rice terraces)
        SizedBox(
          width: double.infinity,
          height: 220,
          child: RepaintBoundary(
            child: CustomPaint(
              size: const Size(double.infinity, 220),
              painter: JavaneseLandscapePainter(
                entranceProgress: _landscapeEntrance.value,
                sunPulse: _ambientController.value,
                shimmerProgress: _ambientController.value,
              ),
            ),
          ),
        ),

        // Android Navigation Bar Indicator (Grounded in deep forest terrace green)
        Container(
          width: double.infinity,
          color: AppColors.terraceTier4,
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Center(
            child: Container(
              width: 128,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.navPill,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

