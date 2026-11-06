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
/// Authentic warm amber splash screen with edge-to-edge system chrome,
/// theme-aligned typography, single-mark logo, and Javanese panorama.
class SplashScreen extends StatefulWidget {
  static const Duration splashMinDuration = Duration(
    milliseconds: 3000,
  ); // [ASUMSI: durasi ~1 detik]

  final bool autoNavigate;
  final Duration displayDuration;

  const SplashScreen({
    super.key,
    this.autoNavigate = true,
    this.displayDuration = splashMinDuration,
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

    // Enable true edge-to-edge system chrome with dark icons on warm amber
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    // 1. Staggered Entrance Controller (850ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );

    // 2. Continuous Ambient Controller for subtle loop
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();

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
      curve: const Interval(0.25, 0.75, curve: Curves.easeOutBack),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.40, 0.85, curve: Curves.easeOut),
    );

    _textSlideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.20), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: const Interval(0.40, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    _dotsFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.60, 0.95, curve: Curves.easeIn),
    );

    _entranceController.forward();

    // Auto-advance to Language Selection screen after minimum splash duration
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
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.amber,
      body: AnimatedBuilder(
        animation: Listenable.merge([_entranceController, _ambientController]),
        builder: (context, _) {
          return Stack(
            children: [
              // Layer 1: Traditional Kawung Batik pattern overlay (RepaintBoundary)
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: BatikKawungPainter(
                      animationProgress: _kawungAnimation.value,
                      opacity: 0.04,
                    ),
                  ),
                ),
              ),

              // Layer 2: Ghosted Aksara Jawa "ꦗ" Watermark in upper right corner
              // Opacity <= 0.06, does not overlap the central brand card or text
              Positioned(
                top: 24,
                right: -16,
                child: RepaintBoundary(
                  child: Opacity(
                    opacity: (0.05 * _watermarkAnimation.value).clamp(
                      0.0,
                      0.05,
                    ),
                    child: Transform.rotate(
                      angle: -8 * math.pi / 180,
                      child: const JavaneseGlyphWidget(
                        size: 130,
                        color: AppColors.ink,
                        isGhost: true,
                      ),
                    ),
                  ),
                ),
              ),

              // Layer 3: Main UI Content wrapped in SafeArea
              SafeArea(
                child: Column(
                  children: [
                    // Top breathing space
                    const Spacer(flex: 2),

                    // Center Brand Block (Logo Tile, Wordmark, Tagline)
                    _buildCenterBrandBlock(theme),

                    // Middle breathing space
                    const Spacer(flex: 3),

                    // Subtle loading activity indicator (6 dp, non-pager)
                    FadeTransition(
                      opacity: _dotsFadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: RepaintBoundary(
                          child: AnimatedLoadingDots(
                            animationValue: _ambientController.value,
                          ),
                        ),
                      ),
                    ),

                    // Vector Panorama (Matahari jingga #F5A31A, gunung tengah menimpa matahari, 3 nuansa hijau)
                    SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: RepaintBoundary(
                        child: CustomPaint(
                          size: const Size(double.infinity, 180),
                          painter: JavaneseLandscapePainter(
                            entranceProgress: _landscapeEntrance.value,
                            shimmerProgress: _ambientController.value,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Center Brand Block: Animated Logo Tile + Wordmark + Tagline
  Widget _buildCenterBrandBlock(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo Tile with soft diffused shadow & floating oscillation (single mark)
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
                Text(
                  AppStrings.appName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    AppStrings.appTagline,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.ink.withValues(
                        alpha: 0.85,
                      ), // >= 80% opasitas, kontras > 4.5:1
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      height: 1.45,
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
}
