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

class _MainShellScreenState extends State<MainShellScreen> {
  late int _selectedTab;
  final Set<int> _loadedPageIndices = {};

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialIndex;
    _loadedPageIndices.add(_pageIndexFromTab(_selectedTab));
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
          setState(() {
            _selectedTab = 0;
            _loadedPageIndices.add(0);
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: IndexedStack(
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
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x12231C14),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
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

              // 2. Quest: Central Elevated 56 px amber button with pen icon
              Expanded(
                child: _buildCenterQuestButton(context.l10n.navQuest),
              ),

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
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.amber,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.amberDark.withValues(alpha: 0.38),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: AppColors.ink,
                size: 26,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              questLabel,
              style: const TextStyle(
                fontSize: 12,
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
    final color = isSelected ? AppColors.accentOrange : AppColors.inkMuted;

    return InkWell(
      onTap: () => _onTabSelected(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSelected ? activeIcon : icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
