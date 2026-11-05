import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/mock/mock_user_stats.dart';
import '../widgets/blangkon_painter.dart';

// ─── Syarat Buka Blangkon ─────────────────────────────────────────────────────

// PERLU VALIDASI BUDAYA
enum BlangkonUnlockType {
  initial,        // Terpasang awal
  level,          // Mencapai Level tertentu
  masteryAksara,  // Selesai materi aksara
}

class BlangkonUnlockCondition {
  final BlangkonUnlockType type;
  final int? requiredLevel;
  final String label;

  const BlangkonUnlockCondition.initial()
      : type = BlangkonUnlockType.initial,
        requiredLevel = null,
        label = 'Terpasang awal';

  const BlangkonUnlockCondition.level(int level)
      : type = BlangkonUnlockType.level,
        requiredLevel = level,
        label = 'Level $level';

  const BlangkonUnlockCondition.masteryAksara()
      : type = BlangkonUnlockType.masteryAksara,
        requiredLevel = null,
        label = 'Selesai aksara';
}

// PERLU KEPUTUSAN
// PERLU VALIDASI BUDAYA
const Map<BlangkonType, BlangkonUnlockCondition> blangkonUnlockConditions = {
  BlangkonType.yogyakarta: BlangkonUnlockCondition.initial(),
  BlangkonType.surakarta: BlangkonUnlockCondition.level(5),
  BlangkonType.banyumas: BlangkonUnlockCondition.level(6),
  BlangkonType.kedu: BlangkonUnlockCondition.level(8),
  BlangkonType.cirebon: BlangkonUnlockCondition.level(10),
  BlangkonType.pusaka: BlangkonUnlockCondition.masteryAksara(),
};

class _BlangkonOption {
  final BlangkonType type;
  final String name;
  final BlangkonUnlockCondition condition;
  final String description;

  const _BlangkonOption({
    required this.type,
    required this.name,
    required this.condition,
    required this.description,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class ChooseBlangkonScreen extends StatefulWidget {
  const ChooseBlangkonScreen({super.key});

  @override
  State<ChooseBlangkonScreen> createState() => _ChooseBlangkonScreenState();
}

class _ChooseBlangkonScreenState extends State<ChooseBlangkonScreen>
    with SingleTickerProviderStateMixin {
  static const int _currentUserLevel = MockUserStats.userLevel;
  static const bool _hasMasteredAksara = MockUserStats.hasMasteredAksara;

  // PERLU VALIDASI BUDAYA
  static final List<_BlangkonOption> _options = [
    _BlangkonOption(
      type: BlangkonType.yogyakarta,
      name: 'Blangkon Yogyakarta',
      condition: blangkonUnlockConditions[BlangkonType.yogyakarta]!,
      description: 'Klasik, mondolan bulat menonjol',
    ),
    _BlangkonOption(
      type: BlangkonType.surakarta,
      name: 'Blangkon Surakarta',
      condition: blangkonUnlockConditions[BlangkonType.surakarta]!,
      description: 'Anggun, mondolan trepes pipih',
    ),
    _BlangkonOption(
      type: BlangkonType.banyumas,
      name: 'Blangkon Banyumas',
      condition: blangkonUnlockConditions[BlangkonType.banyumas]!,
      description: 'Tegas, corak khas Banyumasan',
    ),
    _BlangkonOption(
      type: BlangkonType.kedu,
      name: 'Blangkon Kedu',
      condition: blangkonUnlockConditions[BlangkonType.kedu]!,
      description: 'Gaya Bagelen Kedu bersahaja',
    ),
    _BlangkonOption(
      type: BlangkonType.cirebon,
      name: 'Blangkon Cirebon',
      condition: blangkonUnlockConditions[BlangkonType.cirebon]!,
      description: 'Pesisiran dinamis berwibawa',
    ),
    _BlangkonOption(
      type: BlangkonType.pusaka,
      name: 'Blangkon Pusaka',
      condition: blangkonUnlockConditions[BlangkonType.pusaka]!,
      description: 'Mahakarya tradisi berornamen emas',
    ),
  ];

  BlangkonType _selected = BlangkonType.yogyakarta;

  late AnimationController _avatarCtrl;
  late Animation<double> _avatarScale;

  @override
  void initState() {
    super.initState();
    _avatarCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _avatarScale = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _avatarCtrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _avatarCtrl.dispose();
    super.dispose();
  }

  bool _isOptionLocked(_BlangkonOption opt) {
    switch (opt.condition.type) {
      case BlangkonUnlockType.initial:
        return false;
      case BlangkonUnlockType.level:
        return _currentUserLevel < (opt.condition.requiredLevel ?? 1);
      case BlangkonUnlockType.masteryAksara:
        return !_hasMasteredAksara;
    }
  }

  void _selectBlangkon(BlangkonType type, bool isLocked) {
    if (isLocked) {
      _showLockedSnackBar(type);
      return;
    }
    HapticFeedback.selectionClick();
    setState(() => _selected = type);
    _avatarCtrl.forward().then((_) => _avatarCtrl.reverse());
  }

  void _showLockedSnackBar(BlangkonType type) {
    final opt = _options.firstWhere((o) => o.type == type);
    final String syaratText;
    switch (opt.condition.type) {
      case BlangkonUnlockType.initial:
        syaratText = 'Terbuka sejak awal';
        break;
      case BlangkonUnlockType.level:
        syaratText = 'Butuh Level ${opt.condition.requiredLevel}';
        break;
      case BlangkonUnlockType.masteryAksara:
        syaratText = 'Selesaikan seluruh materi aksara';
        break;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$syaratText untuk membuka ${opt.name}'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _saveSelection() {
    HapticFeedback.mediumImpact();
    Navigator.pop(context, _selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F1EB),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              _buildAvatarPreview(),
              const SizedBox(height: 24),
              _buildBlangkonGrid(),
              const SizedBox(height: 28),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.amber,
      elevation: 0,
      leading: Semantics(
        label: 'Kembali',
        button: true,
        child: BackButton(color: AppColors.ink),
      ),
      title: const Text(
        'Pilih Blangkon',
        style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700, fontSize: 18),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 14),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.ink.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Row(
            children: [
              Icon(Icons.shield_outlined, size: 14, color: AppColors.ink),
              SizedBox(width: 4),
              Text(
                'Level $_currentUserLevel',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: CustomPaint(painter: _KawungAppBarPainter()),
    );
  }

  Widget _buildAvatarPreview() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE8E1D6)),
        boxShadow: [
          BoxShadow(
            color: AppColors.ink.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _avatarScale,
            child: SizedBox(
              width: 120,
              height: 150,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    bottom: 0,
                    child: CustomPaint(
                      size: const Size(120, 120),
                      painter: _JavaneseCharacterPainter(),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: CustomPaint(
                      size: const Size(90, 70),
                      painter: BlangkonPainter(type: _selected),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            _options.firstWhere((o) => o.type == _selected).name,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _options.firstWhere((o) => o.type == _selected).description,
            style: const TextStyle(fontSize: 14, color: Color(0xFF6B6257)),
          ),
        ],
      ),
    );
  }

  Widget _buildBlangkonGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 90 / 115,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _options.length,
      itemBuilder: (context, i) {
        final opt = _options[i];
        final isLocked = _isOptionLocked(opt);
        final isSelected = _selected == opt.type;

        return _BlangkonGridItem(
          option: opt,
          isLocked: isLocked,
          isSelected: isSelected,
          onTap: () => _selectBlangkon(opt.type, isLocked),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _saveSelection,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.amber,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        ),
        child: const Text(
          'Simpan Pilihan',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, letterSpacing: 0.3),
        ),
      ),
    );
  }
}

// ─── Grid item ────────────────────────────────────────────────────────────────

class _BlangkonGridItem extends StatelessWidget {
  final _BlangkonOption option;
  final bool isLocked;
  final bool isSelected;
  final VoidCallback onTap;

  const _BlangkonGridItem({
    required this.option,
    required this.isLocked,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.amberSoft : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.amber : const Color(0xFFE8E1D6),
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: AppColors.amber.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 3))]
              : [],
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: CustomPaint(
                        size: const Size(70, 55),
                        painter: BlangkonPainter(type: option.type, isLocked: isLocked),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    option.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isLocked ? const Color(0xFFB0A898) : AppColors.ink,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isLocked) ...[
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F1EB),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        option.condition.label,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B6257),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: AppColors.amber,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, size: 12, color: AppColors.ink),
                ),
              ),
            if (isLocked)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B6257).withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_rounded, size: 10, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Javanese character painter (simple avatar body) ─────────────────────────

class _JavaneseCharacterPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final skinPaint = Paint()..color = const Color(0xFFD4956A);
    canvas.drawCircle(Offset(w * 0.5, h * 0.22), h * 0.19, skinPaint);

    final bodyPaint = Paint()..color = const Color(0xFF2E5A46);
    final bodyPath = Path()
      ..moveTo(w * 0.25, h * 0.42)
      ..quadraticBezierTo(w * 0.2, h * 0.78, w * 0.18, h * 1.0)
      ..lineTo(w * 0.82, h * 1.0)
      ..quadraticBezierTo(w * 0.80, h * 0.78, w * 0.75, h * 0.42)
      ..quadraticBezierTo(w * 0.5, h * 0.38, w * 0.25, h * 0.42)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    canvas.drawRect(Rect.fromLTWH(w * 0.42, h * 0.38, w * 0.16, h * 0.08), skinPaint);

    final trimPaint = Paint()
      ..color = AppColors.amber
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.44), width: w * 0.46, height: h * 0.14),
      3.3, 2.6, false, trimPaint,
    );

    final eyePaint = Paint()..color = AppColors.ink;
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.42, h * 0.21), width: 5, height: 4), eyePaint);
    canvas.drawOval(Rect.fromCenter(center: Offset(w * 0.58, h * 0.21), width: 5, height: 4), eyePaint);

    final smilePaint = Paint()
      ..color = AppColors.ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.26), width: 14, height: 7),
      0, 3.14, false, smilePaint,
    );
  }

  @override
  bool shouldRepaint(_JavaneseCharacterPainter _) => false;
}

// ─── AppBar kawung painter ────────────────────────────────────────────────────

class _KawungAppBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kawungStroke.withValues(alpha: 0.035)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const r = 12.0;
    for (double x = 0; x < size.width + r * 2; x += r * 2) {
      for (double y = 0; y < size.height + r * 2; y += r * 2) {
        final c = Offset(x, y);
        canvas.drawCircle(c.translate(-r, 0), r, paint);
        canvas.drawCircle(c.translate(r, 0), r, paint);
        canvas.drawCircle(c.translate(0, -r), r, paint);
        canvas.drawCircle(c.translate(0, r), r, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_KawungAppBarPainter _) => false;
}
