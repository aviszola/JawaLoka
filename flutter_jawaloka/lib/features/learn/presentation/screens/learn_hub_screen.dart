import '../../../../core/mock/mock_user_stats.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../splash/presentation/widgets/batik_kawung_painter.dart';
import '../widgets/module_card.dart';
import 'vocabulary_detail_screen.dart';
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

  final List<_DailyWord> _dailyWords = const [
    _DailyWord(
      javanese: 'Omah',
      aksara: 'ꦲꦺꦴꦩꦃ',
      indonesian: 'Rumah',
      level: 'Ngoko',
    ),
    _DailyWord(
      javanese: 'Banyu',
      aksara: 'ꦧꦤꦾꦸ',
      indonesian: 'Air',
      level: 'Ngoko',
    ),
    _DailyWord(
      javanese: 'Segara',
      aksara: 'ꦱꦼꦒꦫ',
      indonesian: 'Laut',
      level: 'Krama',
    ),
    _DailyWord(
      javanese: 'Lemah',
      aksara: 'ꦭꦼꦩꦃ',
      indonesian: 'Tanah',
      level: 'Ngoko',
    ),
    _DailyWord(
      javanese: 'Langit',
      aksara: 'ꦭꦁꦒꦶꦠ꧀',
      indonesian: 'Langit',
      level: 'Ngoko',
    ),
  ];

  static const List<ModuleCardData> _modules = [
    ModuleCardData(
      id: 'aksara',
      title: 'Aksara Jawa Dhasar',
      subtitle: 'Hanacaraka — 20 aksara dasar, sandhangan & pasangan',
      iconGlyph: 'ꦲ',
      bgColor: AppColors.amberSoft,
      progress: 0.65,
      progressLabel: '20 aksara terselesaikan',
      tag: 'Aksara',
    ),
    ModuleCardData(
      id: 'kosakata',
      title: 'Kosa Kata (Kamus)',
      subtitle: 'Kamus 3 tingkat tutur: Ngoko, Krama Madya, Krama Inggil',
      iconData: Icons.menu_book_rounded,
      bgColor: AppColors.pastelSand,
      iconTextColor: AppColors.amberDark,
      progress: 0.50,
      progressLabel: '120 tembung terselesaikan',
      tag: 'Kamus',
    ),
    ModuleCardData(
      id: 'penerjemah',
      title: 'Penerjemah Bahasa',
      subtitle: 'Terjemahan dwiarah Indonesia, Ngoko, dan Krama',
      iconData: Icons.translate_rounded,
      bgColor: AppColors.pastelMint,
      iconTextColor: AppColors.pastelMintText,
      progress: 1.0,
      progressLabel: 'Siap Digunakan',
      tag: 'Utilitas',
      isTool: true,
    ),
    ModuleCardData(
      id: 'unggah_ungguh',
      title: 'Penggunaan Bahasa',
      subtitle: 'Unggah-ungguh & tata krama ragam wicara',
      iconData: Icons.record_voice_over_rounded,
      bgColor: AppColors.pastelLavender,
      iconTextColor: AppColors.pastelLavenderText,
      progress: 0.35,
      progressLabel: '4 tingkatan tutur',
      tag: 'Wicara',
    ),
    ModuleCardData(
      id: 'peribahasa',
      title: 'Peribahasa & Saloka',
      subtitle: 'Paribasan, bebasan, lan saloka warisan Jawa',
      iconData: Icons.auto_stories_rounded,
      bgColor: AppColors.pastelBlush,
      iconTextColor: AppColors.pastelBlushText,
      progress: 0.20,
      progressLabel: '15 peribahasa',
      tag: 'Sastra',
    ),
  ];

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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VocabularyDetailScreen()),
      );
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
      builder: (context) {
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
                  const Text(
                    'Penggunaan Bahasa',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tingkatan ragam bahasa Jawa miturut trapsila lan unggah-ungguh.',
                    style: TextStyle(
                      color: AppColors.inkSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildUnggahCard(
                    title: '1. Basa Ngoko Lugu',
                    desc:
                        'Dipigunakake kanggo kanca sebaya, sedulur nom, utawa wong sing wis raket banget.',
                    example: 'Kowe arep mangan apa?',
                    color: AppColors.pastelSand,
                  ),
                  const SizedBox(height: 12),
                  _buildUnggahCard(
                    title: '2. Basa Ngoko Alus',
                    desc:
                        'Basa ngoko sing kacampuran tembung krama inggil kanggo ngurmati wong sing diajak guneman.',
                    example: 'Panjenengan apa wis dhahar?',
                    color: AppColors.pastelMint,
                  ),
                  const SizedBox(height: 12),
                  _buildUnggahCard(
                    title: '3. Basa Krama Lugu / Madya',
                    desc:
                        'Basa krama sopan umum marang wong sing durung pati kenal utawa kanca kerja.',
                    example: 'Kula nedha sekul goreng.',
                    color: AppColors.pastelLavender,
                  ),
                  const SizedBox(height: 12),
                  _buildUnggahCard(
                    title: '4. Basa Krama Inggil / Alus',
                    desc:
                        'Tingkatan paling luhur, dipigunakake marang wong tuwa, guru, utawa pinisepuh.',
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
              'Tuladha: "$example"',
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
      builder: (context) {
        final proverbs = [
          {
            'jawa': 'Ajining dhiri ana ing lathi, ajining raga ana ing busana.',
            'arti':
                'Kehormatan seseorang terletak pada tutur katanya, dan kehormatan tubuh terletak pada pakaiannya.',
          },
          {
            'jawa': 'Urip iku urup.',
            'arti':
                'Hidup itu hendaknya memberi manfaat dan menerangi orang lain di sekitarnya.',
          },
          {
            'jawa': 'Jer basuki mawa beya.',
            'arti':
                'Setiap cita-cita dan kesuksesan memerlukan usaha, pengorbanan, dan biaya.',
          },
          {
            'jawa': 'Mikul dhuwur mendhem jero.',
            'arti':
                'Menjunjung tinggi kehormatan orang tua dan keluarga serta menutup aib atau keburukan.',
          },
          {
            'jawa': 'Rukun agawe santosa, crah agawe bubrah.',
            'arti':
                'Kerukunan menciptakan ketenteraman dan kekuatan, perpecahan membawa kehancuran.',
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
                  const Text(
                    'Peribahasa & Saloka Jawa',
                    style: TextStyle(
                      color: AppColors.ink,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pepatah lan bebasan luhur warisan leluhur kabudayan Jawa.',
                    style: TextStyle(
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
                    'Materi Belajar',
                    Icons.auto_stories_rounded,
                  ),
                  const SizedBox(height: 14),
                  ..._modules.map(
                    (m) => ModuleCard(data: m, onTap: () => _onModuleTap(m)),
                  ),

                  const SizedBox(height: 28),

                  // Tembung Dina Iki carousel
                  _buildSectionHeader(
                    'Tembung Dina Iki',
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
      toolbarHeight: 0,
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildHeroHeader() {
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
                        children: const [
                          Text(
                            'Pusat Sinau JawaLoka',
                            style: TextStyle(
                              color: AppColors.ink,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Materi & Modul Sinau',
                            style: TextStyle(
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
                    child: const Text(
                      'Level ${MockUserStats.userLevel}',
                      style: TextStyle(
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
    final actions = [
      _QuickAction(
        icon: Icons.menu_book_rounded,
        label: 'Kamus',
        color: AppColors.pastelSand,
        iconColor: AppColors.amberDark,
        onTap: () => Navigator.pushNamed(context, AppRouter.vocabularyDetail),
      ),
      _QuickAction(
        icon: Icons.edit_note_rounded,
        label: 'Aksara',
        color: AppColors.amberSoft,
        iconColor: AppColors.accentOrange,
        onTap: () => Navigator.pushNamed(context, AppRouter.aksaraDetail),
      ),
      _QuickAction(
        icon: Icons.translate_rounded,
        label: 'Penerjemah',
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
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _dailyWords.length,
        itemBuilder: (context, i) {
          final w = _dailyWords[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => VocabularyDetailScreen(word: w.javanese),
              ),
            ),
            child: Container(
              width: 140,
              margin: EdgeInsets.only(
                right: i < _dailyWords.length - 1 ? 12 : 0,
              ),
              padding: const EdgeInsets.all(14),
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
                    w.indonesian,
                    style: const TextStyle(
                      color: AppColors.inkSecondary,
                      fontSize: 12,
                    ),
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

class _DailyWord {
  final String javanese;
  final String aksara;
  final String indonesian;
  final String level;
  const _DailyWord({
    required this.javanese,
    required this.aksara,
    required this.indonesian,
    required this.level,
  });
}

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
