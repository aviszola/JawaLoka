import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/get_started_brand_mark.dart';
import '../widgets/get_started_illustration_painter.dart';

/// Authentic "Get Started" / Welcome Screen for JawaLoka.
///
/// Features rich, orchestrated animations:
/// 1. Staggered Entrance: Header slides down, gamelan vista emerges, CTA bounces in.
/// 2. Live Gamelan Ambient Loop: Kendang drumming, Saron mallet striking, Gong swaying, Sun halo breathing.
/// 3. Interactive CTA: Breathing pulse, dynamic shadow, and tactile tap spring feedback.
class GetStartedScreen extends StatefulWidget {
  final VoidCallback? onGetStarted;
  final VoidCallback? onSignIn;
  final bool enableAmbientAnimation;
  final Duration idleTimeout;
  final Duration? minimumDuration;

  const GetStartedScreen({
    super.key,
    this.onGetStarted,
    this.onSignIn,
    this.enableAmbientAnimation = true,
    this.idleTimeout = const Duration(seconds: 10),
    this.minimumDuration,
    bool autoProceedAfterDuration = true,
  });

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen>
    with TickerProviderStateMixin {
  late final AnimationController _entranceCtrl;
  late final AnimationController _ambientCtrl;

  late final Animation<double> _headerFade;
  late final Animation<Offset> _headerSlide;
  late final Animation<double> _illustrationFade;
  late final Animation<Offset> _illustrationSlide;
  late final Animation<double> _buttonScale;
  late final Animation<double> _buttonFade;

  Timer? _idleTimer;
  bool _hasProceeded = false;
  @override
  void initState() {
    super.initState();

    // 1. Staggered Entrance Controller (950ms)
    _entranceCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    _headerFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.06), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.0, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _illustrationFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.18, 0.75, curve: Curves.easeOut),
    );
    _illustrationSlide =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceCtrl,
            curve: const Interval(0.18, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    _buttonScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceCtrl,
        curve: const Interval(0.40, 1.0, curve: Curves.easeOutBack),
      ),
    );
    _buttonFade = CurvedAnimation(
      parent: _entranceCtrl,
      curve: const Interval(0.40, 0.85, curve: Curves.easeOut),
    );

    // 2. Continuous Ambient Controller for Gamelan Rhythms & Button Breathing (2400ms)
    _ambientCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    if (widget.enableAmbientAnimation) {
      _ambientCtrl.repeat();
    }

    // 3. Idle / Inactivity 10-second Timer (auto-advances if no interaction)
    _startIdleTimer();
    _entranceCtrl.forward();
  }

  Duration get _effectiveTimeout =>
      widget.minimumDuration ?? widget.idleTimeout;

  void _startIdleTimer() {
    _idleTimer?.cancel();
    if (_effectiveTimeout > Duration.zero) {
      _idleTimer = Timer(_effectiveTimeout, () {
        if (!mounted || _hasProceeded) return;
        _handleGetStarted();
      });
    }
  }

  void _onUserInteraction() {
    if (_hasProceeded) return;
    _startIdleTimer();
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _entranceCtrl.dispose();
    _ambientCtrl.dispose();
    super.dispose();
  }

  void _handleGetStarted() {
    if (_hasProceeded || !mounted) return;
    _hasProceeded = true;
    _idleTimer?.cancel();

    HapticFeedback.mediumImpact();
    if (widget.onGetStarted != null) {
      widget.onGetStarted!();
      return;
    }

    // Default flow: proceed to language selection
    Navigator.of(context).pushReplacementNamed(AppRouter.languageSelection);
  }

  void _handleSignIn() {
    if (_hasProceeded || !mounted) return;
    _hasProceeded = true;
    _idleTimer?.cancel();

    HapticFeedback.lightImpact();
    if (widget.onSignIn != null) {
      widget.onSignIn!();
      return;
    }

    Navigator.of(context).pushNamed(AppRouter.profileSetup);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: (_) => _onUserInteraction(),
        onPointerMove: (_) => _onUserInteraction(),
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: AppColors.canvas,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 18),

                // ── 1. Top Branding Block (Staggered Entrance Animation) ──────
                FadeTransition(
                  opacity: _headerFade,
                  child: SlideTransition(
                    position: _headerSlide,
                    child: _buildBrandingHeader(),
                  ),
                ),

                // ── 2. Middle Vector Illustration with Putra & Putri SVG ──────
                Expanded(
                  child: SizedBox.expand(
                    child: FadeTransition(
                      opacity: _illustrationFade,
                      child: SlideTransition(
                        position: _illustrationSlide,
                        child: AnimatedBuilder(
                          animation: _ambientCtrl,
                          builder: (context, _) {
                            final double bob = widget.enableAmbientAnimation
                                ? math.sin(_ambientCtrl.value * math.pi * 2) *
                                      2.5
                                : 0.0;
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: GetStartedIllustrationPainter(
                                      animationProgress:
                                          widget.enableAmbientAnimation
                                          ? _ambientCtrl.value
                                          : 0.0,
                                      drawCharacters: false,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 24,
                                  right: 24,
                                  bottom: 8 + bob,
                                  top: 24,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Flexible(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 160,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/characters/karakter_putra.svg',
                                            fit: BoxFit.contain,
                                            alignment: Alignment.bottomCenter,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Flexible(
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(
                                            maxWidth: 160,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/characters/karakter_putri.svg',
                                            fit: BoxFit.contain,
                                            alignment: Alignment.bottomCenter,
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
                      ),
                    ),
                  ),
                ),

                // ── 3. Bottom CTA & Info Disclaimer (Animated Button) ──────────
                FadeTransition(
                  opacity: _buttonFade,
                  child: ScaleTransition(
                    scale: _buttonScale,
                    child: _buildBottomActionSection(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          // Circular emblem
          GetStartedBrandMark(size: 60),
          SizedBox(height: 12),

          // Aksara Jawa Dual-Script Overline
          Text(
            'ꦗꦮꦭꦺꦴꦏ',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'NotoSansJavanese',
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.inkSecondary,
              letterSpacing: 2.5,
            ),
          ),
          SizedBox(height: 2),

          // App Title using Distinct Serif Display Typography
          Text(
            'JawaLoka',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'serif',
              fontFamilyFallback: [
                'Georgia',
                'Palatino',
                'Noto Serif',
                'PlusJakartaSans',
              ],
              fontSize: 38,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: 1.0,
              height: 1.15,
            ),
          ),
          SizedBox(height: 8),

          // Tagline using Poetic Humanist Serif Italic
          Text(
            'Sinau basa & aksara Jawa luwih gampang',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'serif',
              fontFamilyFallback: [
                'Georgia',
                'Palatino',
                'Noto Serif',
                'PlusJakartaSans',
              ],
              fontStyle: FontStyle.italic,
              fontSize: 15.5,
              fontWeight: FontWeight.w500,
              color: AppColors.inkSecondary,
              letterSpacing: 0.2,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 6, 24, 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated "Get Started" CTA Button with breathing pulse & tactile spring
          AnimatedBuilder(
            animation: _ambientCtrl,
            builder: (context, child) {
              // Subtle breathing scale (1.0 to 1.02)
              final double breath = widget.enableAmbientAnimation
                  ? math.sin(_ambientCtrl.value * math.pi * 2) * 0.012
                  : 0.0;

              // Shimmer highlight pass phase
              final double shimmerPos = widget.enableAmbientAnimation
                  ? _ambientCtrl.value
                  : 0.0;

              return Transform.scale(
                scale: 1.0 + breath,
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(29)),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.ink.withValues(
                            alpha: 0.22 + (breath * 3.0),
                          ),
                          blurRadius: 18 + (breath * 200),
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(29)),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Base Ink Button
                          ElevatedButton(
                            onPressed: _handleGetStarted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.ink,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Get Started',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),

                          // Subtle Shimmer Beam Sweep
                          if (widget.enableAmbientAnimation)
                            Positioned.fill(
                              child: IgnorePointer(
                                child: FractionalTranslation(
                                  translation: Offset(
                                    (shimmerPos * 3.5) - 1.2,
                                    0,
                                  ),
                                  child: Transform.rotate(
                                    angle: 0.35,
                                    child: Container(
                                      width: 45,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.white.withValues(alpha: 0.0),
                                            Colors.white.withValues(
                                              alpha: 0.16,
                                            ),
                                            Colors.white.withValues(alpha: 0.0),
                                          ],
                                        ),
                                      ),
                                    ),
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
            },
          ),
          const SizedBox(height: 14),

          // Secondary Action: "Sudah punya akun? Masuk"
          // Secondary Action: "Mau atur karakter? Isi Data Diri"
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Mau atur karakter? ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkSecondary,
                ),
              ),
              GestureDetector(
                onTap: _handleSignIn,
                child: const Text(
                  'Isi Data Diri',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.amberDark,
                    decorationThickness: 1.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Cultural/Educational Disclaimer using AppColors.inkMuted
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.info_outline_rounded,
                size: 16,
                color: AppColors.inkMuted,
              ),
              SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Aplikasi pasinaon budaya & aksara Jawa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkMuted,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
