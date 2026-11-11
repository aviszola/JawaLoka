import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import 'home_screen.dart';
import '../../../learn/presentation/screens/learn_hub_screen.dart';
import '../../../quiz/presentation/screens/quiz_path_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

/// Main Navigation Shell for JawaLoka.
///
/// Implements the 5-item bottom navigation:
/// 0. Beranda (Home dashboard)
/// 1. Belajar (Learning material hub)
/// 2. Quest (Center circular elevated amber 56 px button with pen icon - action button)
/// 3. Kuis (Duolingo-style quiz path)
/// 4. Profil (User profile & avatar customizer)
///
/// Performance optimizations:
/// - Lazy tab building: tabs are instantiated only upon first access, then retained.
/// - Inactive tabs are wrapped in [TickerMode(enabled: false)] to stop hidden animations.
/// - Android back button handled via [PopScope]: non-Home tabs navigate back to Home first;
///   Home tab exits the app.
class MainShellScreen extends StatefulWidget {
  final int initialIndex;

  const MainShellScreen({super.key, this.initialIndex = 0});

  static const String routeName = '/home';

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen>
    with SingleTickerProviderStateMixin {
  late int _selectedTab;
  final Set<int> _loadedPageIndices = {};

  late final AnimationController _tabTransitionCtrl;
  late final Animation<double> _tabFadeAnimation;
  late final Animation<Offset> _tabSlideAnimation;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialIndex;
    _loadedPageIndices.add(_pageIndexFromTab(_selectedTab));

    _tabTransitionCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1.0,
    );
    _tabFadeAnimation = CurvedAnimation(
      parent: _tabTransitionCtrl,
      curve: Curves.easeOutCubic,
    );
    _tabSlideAnimation =
        Tween<Offset>(begin: const Offset(0.04, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _tabTransitionCtrl,
            curve: Curves.easeOutCubic,
          ),
        );
  }

  @override
  void dispose() {
    _tabTransitionCtrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MainShellScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      setState(() {
        _selectedTab = widget.initialIndex;
        _loadedPageIndices.add(_pageIndexFromTab(widget.initialIndex));
      });
    }
  }

  void _onTabSelected(int index) {
    if (index == 2) {
      // Quest: center action button that opens full-screen drawing canvas without changing tab index
      Navigator.pushNamed(context, AppRouter.drawingCanvas);
      return;
    }
    if (_selectedTab != index) {
      _tabTransitionCtrl.forward(from: 0.0);
    }
    setState(() {
      _selectedTab = index;
      _loadedPageIndices.add(_pageIndexFromTab(index));
    });
  }

  int _pageIndexFromTab(int tab) {
    switch (tab) {
      case 0:
        return 0; // Beranda
      case 1:
        return 1; // Belajar
      case 3:
        return 2; // Kuis
      case 4:
        return 3; // Profil
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activePageIndex = _pageIndexFromTab(_selectedTab);
    final canPopNow = _selectedTab == 0;

    return PopScope(
      canPop: canPopNow,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // In tabs other than Beranda, back button returns to Beranda first
        if (_selectedTab != 0) {
          _tabTransitionCtrl.forward(from: 0.0);
          setState(() {
            _selectedTab = 0;
            _loadedPageIndices.add(0);
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: FadeTransition(
          opacity: _tabFadeAnimation,
          child: SlideTransition(
            position: _tabSlideAnimation,
            child: IndexedStack(
              index: activePageIndex,
              children: [
                // Page 0: Beranda
                TickerMode(
                  enabled: activePageIndex == 0,
                  child: _loadedPageIndices.contains(0)
                      ? HomeScreen(onNavigateTab: _onTabSelected)
                      : const SizedBox.shrink(),
                ),

                // Page 1: Belajar
                TickerMode(
                  enabled: activePageIndex == 1,
                  child: _loadedPageIndices.contains(1)
                      ? const LearnHubScreen()
                      : const SizedBox.shrink(),
                ),

                // Page 2: Kuis
                TickerMode(
                  enabled: activePageIndex == 2,
                  child: _loadedPageIndices.contains(2)
                      ? const QuizPathScreen()
                      : const SizedBox.shrink(),
                ),

                // Page 3: Profil
                TickerMode(
                  enabled: activePageIndex == 3,
                  child: _loadedPageIndices.contains(3)
                      ? const ProfileScreen()
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.8),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.ink.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          height: 64,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 0. Beranda
              Expanded(
                child: _buildNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: context.l10n.navHome,
                ),
              ),

              // 1. Belajar
              Expanded(
                child: _buildNavItem(
                  index: 1,
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book_rounded,
                  label: context.l10n.navLearn,
                ),
              ),

              // 2. Quest: Central Elevated 54 px amber button with pen icon
              Expanded(child: _buildCenterQuestButton(context.l10n.navQuest)),

              // 3. Kuis
              Expanded(
                child: _buildNavItem(
                  index: 3,
                  icon: Icons.quiz_outlined,
                  activeIcon: Icons.quiz_rounded,
                  label: context.l10n.navQuiz,
                ),
              ),

              // 4. Profil
              Expanded(
                child: _buildNavItem(
                  index: 4,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: context.l10n.navProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterQuestButton(String questLabel) {
    return GestureDetector(
      onTap: () => _onTabSelected(2),
      behavior: HitTestBehavior.opaque,
      child: OverflowBox(
        maxHeight: 90,
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.amber, AppColors.accentOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentOrange.withValues(alpha: 0.40),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              questLabel,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _selectedTab == index;
    final color = isSelected ? AppColors.accentOrange : AppColors.inkSecondary;

    return InkWell(
      onTap: () => _onTabSelected(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSelected ? activeIcon : icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
