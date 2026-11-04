import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

// ─── Avatar CustomPainter ─────────────────────────────────────────────────────

class _AvatarPainter extends CustomPainter {
  const _AvatarPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    const r = 30.0; // 60px circle → 30 radius

    // ── Face circle (ink background) ──────────────────────────────────────────
    final facePaint = Paint()..color = AppColors.ink;
    canvas.drawCircle(Offset(cx, cy), r, facePaint);

    // ── Eyes (white dots) ─────────────────────────────────────────────────────
    final eyePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(cx - 9, cy - 4), 3.5, eyePaint);
    canvas.drawCircle(Offset(cx + 9, cy - 4), 3.5, eyePaint);

    // ── Smile curve ───────────────────────────────────────────────────────────
    final smilePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final smilePath = Path();
    smilePath.moveTo(cx - 9, cy + 7);
    smilePath.quadraticBezierTo(cx, cy + 15, cx + 9, cy + 7);
    canvas.drawPath(smilePath, smilePaint);

    // ── Blangkon hat ──────────────────────────────────────────────────────────
    // Flat trapezoid brim
    final hatPaint = Paint()..color = AppColors.amber;
    final brimPath = Path();
    brimPath.moveTo(cx - r, cy - r + 2);        // left-bottom of brim
    brimPath.lineTo(cx + r, cy - r + 2);        // right-bottom of brim
    brimPath.lineTo(cx + r * 0.65, cy - r - 10); // right-top
    brimPath.lineTo(cx - r * 0.65, cy - r - 10); // left-top
    brimPath.close();
    canvas.drawPath(brimPath, hatPaint);

    // Crown (darker amber)
    final crownPaint = Paint()..color = AppColors.amberDark;
    final crownPath = Path();
    crownPath.moveTo(cx - r * 0.65, cy - r - 10);
    crownPath.lineTo(cx + r * 0.65, cy - r - 10);
    crownPath.lineTo(cx + r * 0.4, cy - r - 20);
    crownPath.lineTo(cx - r * 0.4, cy - r - 20);
    crownPath.close();
    canvas.drawPath(crownPath, crownPaint);

    // Small protrusion knob on top
    final knobPaint = Paint()..color = AppColors.kawungStroke;
    canvas.drawCircle(Offset(cx, cy - r - 20), 4, knobPaint);

    // Hat band stripe
    final bandPaint = Paint()
      ..color = AppColors.kawungStroke
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(cx - r, cy - r + 2),
      Offset(cx + r, cy - r + 2),
      bandPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Helper widgets ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 20, 4, 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Column(children: children),
    );
  }
}

// ─── Screen ────────────────────────────────────────────────────────────────────

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  bool _soundEnabled = true;
  bool _dailyReminder = true;

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

  // ── Logout dialog ────────────────────────────────────────────────────────────
  void _showLogoutDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar?',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: const Text(
          'Kamu yakin ingin keluar dari JawaLoka?',
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
              // TODO: implement logout logic
            },
            child: const Text(
              'Keluar',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build helpers ─────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return SlideTransition(
      position: _headerSlide,
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.amberGradient,
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
                // Avatar
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CustomPaint(painter: const _AvatarPainter()),
                ),
                const SizedBox(width: 16),
                // Name & level
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dimas Pratama',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Level 12 • 1.250 XP',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.amberSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit button
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(8),
                    minimumSize: const Size(36, 36),
                  ),
                  child: const Icon(Icons.edit, size: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    const chevron = Icon(Icons.chevron_right, color: AppColors.inkMuted);

    return FadeTransition(
      opacity: _bodyFade,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        children: [
          // ── AKUN ─────────────────────────────────────────────────────────────
          const _SectionHeader('AKUN'),
          _SettingsCard(
            children: [
              ListTile(
                leading: const Text('👤', style: TextStyle(fontSize: 20)),
                title: const Text('Profil Saya',
                    style: TextStyle(color: AppColors.ink)),
                trailing: chevron,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),
              ListTile(
                leading: const Text('🎭', style: TextStyle(fontSize: 20)),
                title: const Text('Pilih Blangkon',
                    style: TextStyle(color: AppColors.ink)),
                trailing: chevron,
                onTap: () =>
                    Navigator.pushNamed(context, '/profile/blangkon'),
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),
              ListTile(
                leading: const Text('🔑', style: TextStyle(fontSize: 20)),
                title: const Text('Ubah Kata Sandi',
                    style: TextStyle(color: AppColors.ink)),
                trailing: chevron,
                onTap: () {},
              ),
            ],
          ),

          // ── PEMBELAJARAN ──────────────────────────────────────────────────────
          const _SectionHeader('PEMBELAJARAN'),
          _SettingsCard(
            children: [
              SwitchListTile(
                secondary: const Text('🔊', style: TextStyle(fontSize: 20)),
                title: const Text('Efek Suara',
                    style: TextStyle(color: AppColors.ink)),
                value: _soundEnabled,
                activeColor: AppColors.amber,
                onChanged: (v) => setState(() => _soundEnabled = v),
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),
              SwitchListTile(
                secondary: const Text('🔔', style: TextStyle(fontSize: 20)),
                title: const Text('Pengingat Harian',
                    style: TextStyle(color: AppColors.ink)),
                value: _dailyReminder,
                activeColor: AppColors.amber,
                onChanged: (v) => setState(() => _dailyReminder = v),
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),
              ListTile(
                leading: const Text('🌙', style: TextStyle(fontSize: 20)),
                title: const Text('Mode Gelap',
                    style: TextStyle(color: AppColors.ink)),
                trailing: chevron,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),
              ListTile(
                leading: const Text('🌐', style: TextStyle(fontSize: 20)),
                title: const Text('Bahasa Antarmuka',
                    style: TextStyle(color: AppColors.ink)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Indonesia',
                        style: TextStyle(
                            color: AppColors.inkSecondary, fontSize: 13)),
                    SizedBox(width: 4),
                    Icon(Icons.chevron_right, color: AppColors.inkMuted),
                  ],
                ),
                onTap: () {},
              ),
            ],
          ),

          // ── LAINNYA ───────────────────────────────────────────────────────────
          const _SectionHeader('LAINNYA'),
          _SettingsCard(
            children: [
              ListTile(
                leading: const Text('❓', style: TextStyle(fontSize: 20)),
                title: const Text('Bantuan & FAQ',
                    style: TextStyle(color: AppColors.ink)),
                trailing: chevron,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),
              ListTile(
                leading: const Text('📋', style: TextStyle(fontSize: 20)),
                title: const Text('Syarat & Ketentuan',
                    style: TextStyle(color: AppColors.ink)),
                trailing: chevron,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),
              ListTile(
                leading: const Text('⭐', style: TextStyle(fontSize: 20)),
                title: const Text('Beri Penilaian',
                    style: TextStyle(color: AppColors.ink)),
                trailing: chevron,
                onTap: () {},
              ),
              const Divider(height: 1, indent: 56, color: AppColors.border),
              ListTile(
                leading: const Text('🚪', style: TextStyle(fontSize: 20)),
                title: const Text(
                  'Keluar',
                  style: TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
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
