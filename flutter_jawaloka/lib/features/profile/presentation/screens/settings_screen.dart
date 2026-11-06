import 'package:flutter/material.dart';
import '../../../../core/mock/mock_user_stats.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/blangkon_painter.dart';
import '../widgets/javanese_avatar_widget.dart';

// ─── Settings Card Container ──────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

// ─── Settings Screen ──────────────────────────────────────────────────────────

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerCtrl;
  late AnimationController _bodyCtrl;
  late Animation<Offset> _headerSlide;
  late Animation<double> _bodyFade;

  @override
  void initState() {
    super.initState();

    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bodyCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _headerCtrl, curve: Curves.easeOut));

    _bodyFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _bodyCtrl, curve: Curves.easeIn),
    );

    _headerCtrl.forward().then((_) => _bodyCtrl.forward());
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _bodyCtrl.dispose();
    super.dispose();
  }

  // ── Logout confirmation dialog ──────────────────────────────────────────────
  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Keluar',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: const Text(
          'Yakin ingin keluar?',
          style: TextStyle(color: AppColors.inkSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Batal',
              style: TextStyle(color: AppColors.inkSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ── Language selection dialog ───────────────────────────────────────────────
  void _showLanguageDialog() {
    // BELUM TERHUBUNG KE LOKALISASI
    showDialog<void>(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Pilih Bahasa',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
        children: [
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text('Basa Jawa', style: TextStyle(fontSize: 15, color: AppColors.ink)),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text('Bahasa Indonesia', style: TextStyle(fontSize: 15, color: AppColors.ink)),
            ),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text('English', style: TextStyle(fontSize: 15, color: AppColors.ink)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Privacy policy dialog ───────────────────────────────────────────────────
  void _showPrivacyPolicyDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Kebijakan Privasi',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
        content: const Text(
          'JawaLoka menghormati privasi Anda. Seluruh progres belajar, latihan aksara, dan preferensi pengguna disimpan secara lokal di perangkat Anda.',
          style: TextStyle(color: AppColors.inkSecondary, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Tutup',
              style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header Widget (High Contrast, WCAG AA Compliant) ─────────────────────────
  Widget _buildHeader() {
    return SlideTransition(
      position: _headerSlide,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: AppColors.amber,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Semantics(
                  label: 'Kembali',
                  button: true,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.ink),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Reusable Avatar Component
                const JavaneseAvatarWidget(
                  size: 60,
                  blangkonType: BlangkonType.yogyakarta,
                ),
                const SizedBox(width: 16),
                // Name & level (High Contrast Ink on Amber)
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '${MockUserStats.userName} Pratama',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Level ${MockUserStats.userLevel}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Body Widget ─────────────────────────────────────────────────────────────
  Widget _buildBody() {
    const chevron = Icon(Icons.chevron_right, color: AppColors.inkMuted);

    return FadeTransition(
      opacity: _bodyFade,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          _SettingsCard(
            children: [
              // 1. Akun
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: const Icon(Icons.person_outline_rounded, color: AppColors.ink),
                title: const Text('Akun', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                trailing: chevron,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),

              // 2. Bahasa
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: const Icon(Icons.language_rounded, color: AppColors.ink),
                title: const Text('Bahasa', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Bahasa Indonesia',
                      style: TextStyle(color: AppColors.inkSecondary, fontSize: 14),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: AppColors.inkMuted),
                  ],
                ),
                onTap: _showLanguageDialog,
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),

              // 3. Kebijakan Privasi
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.ink),
                title: const Text('Kebijakan Privasi', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                trailing: chevron,
                onTap: _showPrivacyPolicyDialog,
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),

              // 4. Keluar
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                title: const Text(
                  'Keluar',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onTap: _showLogoutDialog,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }
}
