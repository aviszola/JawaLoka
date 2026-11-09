import '../../../../core/profile/profile_scope.dart';
import 'package:flutter/material.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../data/vocab_word.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';
import '../widgets/module_card.dart';
import 'aksara_detail_screen.dart';
import '../../../translator/presentation/screens/translator_screen.dart';

/// Learning Hub – the main screen for all learning materials in JawaLoka.
///
/// Route name: `/learn`
/// Contains learning modules (Aksara, Kosa Kata, Penerjemah, Penggunaan Bahasa, Peribahasa).
/// Does NOT contain quiz path (which is separated to Kuis tab).
class LearnHubScreen extends StatefulWidget {
  const LearnHubScreen({super.key});

  static const routeName = '/learn';

  @override
  State<LearnHubScreen> createState() => _LearnHubScreenState();
}

class _LearnHubScreenState extends State<LearnHubScreen>
    with TickerProviderStateMixin {
  late final AnimationController _greetingCtrl;
  late final Animation<double> _greetingFade;

  final List<VocabWord> _dailyWords = VocabWord.sampleWords;

  List<ModuleCardData> _getModules(BuildContext context) {
    final l10n = context.l10n;
    return [
      ModuleCardData(
        id: 'aksara',
        title: l10n.learnModuleAksaraTitle,
        subtitle: l10n.learnModuleAksaraSubtitle,
        iconGlyph: 'ꦲ',
        bgColor: AppColors.amberSoft,
        iconTextColor: AppColors.amberDark,
        progressLabel: l10n.learnModuleAksaraLabel,
        tag: l10n.learnTagAksara,
      ),
      ModuleCardData(
        id: 'kosakata',
        title: l10n.learnModuleVocabTitle,
        subtitle: l10n.learnModuleVocabSubtitle,
        iconData: Icons.menu_book_rounded,
        bgColor: AppColors.pastelSand,
        iconTextColor: AppColors.ink,
        progressLabel: l10n.learnModuleVocabLabel,
        tag: l10n.learnTagKamus,
      ),
      ModuleCardData(
        id: 'penerjemah',
        title: l10n.learnModuleTranslatorTitle,
        subtitle: l10n.learnModuleTranslatorSubtitle,
        iconData: Icons.translate_rounded,
        bgColor: const Color(0xFFEBE6DC),
        iconTextColor: AppColors.inkSecondary,
        progressLabel: l10n.learnModuleTranslatorLabel,
        tag: l10n.learnTagUtilitas,
        isTool: true,
      ),
      ModuleCardData(
        id: 'unggah_ungguh',
        title: l10n.learnModuleEtiquetteTitle,
        subtitle: l10n.learnModuleEtiquetteSubtitle,
        iconData: Icons.record_voice_over_rounded,
        bgColor: const Color(0xFFF7ECDC),
        iconTextColor: const Color(0xFF8C5424),
        progressLabel: l10n.learnModuleEtiquetteLabel,
        tag: l10n.learnTagWicara,
      ),
      ModuleCardData(
        id: 'peribahasa',
        title: l10n.learnModuleProverbsTitle,
        subtitle: l10n.learnModuleProverbsSubtitle,
        iconData: Icons.auto_stories_rounded,
        bgColor: const Color(0xFFF3ECE0),
        iconTextColor: const Color(0xFF6E563E),
        progressLabel: l10n.learnModuleProverbsLabel,
        tag: l10n.learnTagSastra,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _greetingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _greetingFade = CurvedAnimation(
      parent: _greetingCtrl,
      curve: Curves.easeOut,
    );
    _greetingCtrl.forward();
  }

  @override
  void dispose() {
    _greetingCtrl.dispose();
    super.dispose();
  }

  void _onModuleTap(ModuleCardData data) {
    if (data.id == 'aksara') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AksaraDetailScreen()),
      );
    } else if (data.id == 'kosakata') {
      Navigator.pushNamed(context, AppRouter.vocabularyDetail, arguments: 0);
    } else if (data.id == 'penerjemah') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TranslatorScreen()),
      );
    } else if (data.id == 'unggah_ungguh') {
      _showUnggahUngguhSheet();
    } else if (data.id == 'peribahasa') {
      _showPeribahasaSheet();
    }
  }

  void _showUnggahUngguhSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final sheetL10n = sheetContext.l10n;
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: ListView(
                controller: scrollCtrl,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    sheetL10n.learnUnggahSheetTitle,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    sheetL10n.learnUnggahSheetSubtitle,
                    style: const TextStyle(
                      color: AppColors.inkSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildUnggahCard(
                    title: sheetL10n.learnUnggahNgokoLuguTitle,
                    desc: sheetL10n.learnUnggahNgokoLuguDesc,
                    example: 'Kowe arep mangan apa?',
                    color: AppColors.pastelSand,
                  ),
                  const SizedBox(height: 12),
                  _buildUnggahCard(
                    title: sheetL10n.learnUnggahNgokoAlusTitle,
                    desc: sheetL10n.learnUnggahNgokoAlusDesc,
                    example: 'Panjenengan apa wis dhahar?',
                    color: AppColors.pastelMint,
                  ),
                  const SizedBox(height: 12),
                  _buildUnggahCard(
                    title: sheetL10n.learnUnggahKramaLuguTitle,
                    desc: sheetL10n.learnUnggahKramaLuguDesc,
                    example: 'Kula nedha sekul goreng.',
                    color: AppColors.pastelLavender,
                  ),
                  const SizedBox(height: 12),
                  _buildUnggahCard(
                    title: sheetL10n.learnUnggahKramaInggilTitle,
                    desc: sheetL10n.learnUnggahKramaInggilDesc,
                    example: 'Bapak saweg tindak dhateng kantor.',
                    color: AppColors.pastelBlush,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildUnggahCard({
    required String title,
    required String desc,
    required String example,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: const TextStyle(
              color: AppColors.inkSecondary,
              fontSize: 14,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              context.l10n.learnUnggahExamplePrefix(example),
              style: const TextStyle(
                color: AppColors.ink,
                fontSize: 12,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPeribahasaSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final l10n = sheetContext.l10n;
        final proverbs = [
          {
            'jawa': 'Ajining dhiri ana ing lathi, ajining raga ana ing busana.',
            'arti': l10n.learnProverb1Meaning,
          },
          {'jawa': 'Urip iku urup.', 'arti': l10n.learnProverb2Meaning},
          {'jawa': 'Jer basuki mawa beya.', 'arti': l10n.learnProverb3Meaning},
          {
            'jawa': 'Mikul dhuwur mendhem jero.',
            'arti': l10n.learnProverb4Meaning,
          },
          {
            'jawa': 'Rukun agawe santosa, crah agawe bubrah.',
            'arti': l10n.learnProverb5Meaning,
          },
        ];

        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: ListView(
                controller: scrollCtrl,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.learnPeribahasaSheetTitle,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.learnPeribahasaSheetSubtitle,
                    style: const TextStyle(
                      color: AppColors.inkSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...proverbs.map(
                    (p) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.canvas,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p['jawa']!,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            p['arti']!,
                            style: const TextStyle(
                              color: AppColors.inkSecondary,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      extendBodyBehindAppBar: false,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amber hero header with subtle batik texture (opacity <= 0.04)
            _buildHeroHeader(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Quick actions strip (Kamus, Aksara, Penerjemah)
                  _buildQuickActions(),
                  const SizedBox(height: 28),

                  // Module section (Aksara, Kosa Kata, Penerjemah, Penggunaan Bahasa, Peribahasa)
                  _buildSectionHeader(
                    context.l10n.learnSectionModules,
                    Icons.auto_stories_rounded,
                  ),
                  const SizedBox(height: 14),
                  ..._getModules(context).map(
                    (m) => ModuleCard(data: m, onTap: () => _onModuleTap(m)),
                  ),

                  const SizedBox(height: 28),

                  // Tembung Dina Iki carousel
                  _buildSectionHeader(
                    context.l10n.learnSectionDailyWord,
                    Icons.translate_rounded,
                  ),
                  const SizedBox(height: 14),
                  _buildWordCarousel(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.amber,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: 0,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildHeroHeader() {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      color: AppColors.amber,
      child: Stack(
        children: [
          // Batik kawung texture overlay (opacity 0.035, strictly <= 0.04)
          Positioned.fill(
            child: RepaintBoundary(
              child: CustomPaint(painter: BatikKawungPainter(opacity: 0.035)),
            ),
          ),

          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: _greetingFade,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.learnHeaderTitle,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.learnHeaderSubtitle,
                            style: const TextStyle(
                              color: AppColors.ink,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Level badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(99),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      l10n.profileLevelPill(
                        ProfileScope.maybeOf(context)?.userLevel ?? 1,
                      ),
                      style: const TextStyle(
                        color: AppColors.ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final l10n = context.l10n;
    final actions = [
      _QuickAction(
        icon: Icons.menu_book_rounded,
        label: l10n.learnTagKamus,
        color: AppColors.pastelSand,
        iconColor: AppColors.amberDark,
        onTap: () => Navigator.pushNamed(
          context,
          AppRouter.vocabularyDetail,
          arguments: 0,
        ),
      ),
      _QuickAction(
        icon: Icons.edit_note_rounded,
        label: l10n.learnTagAksara,
        color: AppColors.amberSoft,
        iconColor: AppColors.accentOrange,
        onTap: () => Navigator.pushNamed(context, AppRouter.aksaraDetail),
      ),
      _QuickAction(
        icon: Icons.translate_rounded,
        label: l10n.translatorTitle,
        color: AppColors.pastelMint,
        iconColor: AppColors.pastelMintText,
        onTap: () => Navigator.pushNamed(context, AppRouter.translator),
      ),
    ];

    return Row(
      children:
          actions
              .map(
                (a) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: _QuickActionCard(action: a),
                  ),
                ),
              )
              .toList()
            ..last = Expanded(child: _QuickActionCard(action: actions.last)),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.amberDark),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.ink,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildWordCarousel() {
    return SizedBox(
      height: 172,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _dailyWords.length,
        itemBuilder: (context, i) {
          final w = _dailyWords[i];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              AppRouter.vocabularyDetail,
              arguments: i,
            ),
            child: Container(
              width: 148,
              margin: EdgeInsets.only(
                right: i < _dailyWords.length - 1 ? 12 : 0,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.ink.withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.pastelSand,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      w.level,
                      style: const TextStyle(
                        color: AppColors.amberDark,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    w.javanese,
                    style: const TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    w.aksara,
                    style: const TextStyle(
                      color: AppColors.amberDark,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    w.meaning(context),
                    style: const TextStyle(
                      color: AppColors.inkSecondary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Supporting data classes
// ─────────────────────────────────────────────────────────────────────────────

class _QuickAction {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    this.onTap,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          color: action.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(action.icon, color: action.iconColor, size: 22),
            const SizedBox(height: 6),
            Text(
              action.label,
              style: TextStyle(
                color: action.iconColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
