import 'package:flutter/widgets.dart';
import '../../../../core/l10n/l10n_extension.dart';

/// Interactive state of a learning path node.
enum NodeStatus { completed, current, locked }

/// Supported types of nodes in the JawaLoka learning path.
enum QuizNodeType {
  /// Regular practice/lesson node.
  regular,

  /// Unit evaluation or checkpoint milestone (Node 10, 20, 30, 40).
  milestone,

  /// Grand finale comprehensive evaluation (Node 50).
  finalExam,
}

/// Horizontal visual alignment on the winding learning path.
enum QuizNodePosition {
  /// Shifted to the left side of the path (x ≈ -0.55).
  left,

  /// Centered on the path (x = 0.0).
  center,

  /// Shifted to the right side of the path (x ≈ +0.55).
  right,
}

extension QuizNodePositionExtension on QuizNodePosition {
  /// Relative alignment X value in range [-1.0, 1.0].
  double get alignmentX {
    switch (this) {
      case QuizNodePosition.left:
        return -0.55;
      case QuizNodePosition.center:
        return 0.0;
      case QuizNodePosition.right:
        return 0.55;
    }
  }

  /// Normalized horizontal fraction in range [0.0, 1.0].
  double get fractionX => (alignmentX + 1.0) / 2.0;
}

/// Domain model representing a single step on the 50-node quiz path.
class QuizPathNode {
  /// Canonical activity identifier, e.g. 'path_node_u1_n01_salam'.
  final String id;

  /// 1-based unit index (1 through 5).
  final int unitId;

  /// Global 1-based order in the entire journey (1 through 50).
  final int nodeNumber;

  /// 1-based index within its unit (1 through 10).
  final int indexInUnit;

  /// Unique semantic topic key for localization and curriculum mapping.
  final String topicKey;

  /// Javanese script glyph displayed inside the node avatar.
  final String glyph;

  /// Classification of the node (regular, milestone, finalExam).
  final QuizNodeType type;

  /// Horizontal position on the winding path.
  final QuizNodePosition position;

  /// Interactive state of the node (completed, current, locked).
  final NodeStatus status;

  const QuizPathNode({
    required this.id,
    required this.unitId,
    required this.nodeNumber,
    required this.indexInUnit,
    required this.topicKey,
    required this.glyph,
    this.type = QuizNodeType.regular,
    this.position = QuizNodePosition.center,
    this.status = NodeStatus.locked,
  });

  /// Fallback title for headless contexts without BuildContext.
  String get title => _fallbackTitle(topicKey);

  /// Fallback description for headless contexts without BuildContext.
  String get description => _fallbackDescription(topicKey);

  /// Whether this node represents a milestone or evaluation checkpoint.
  bool get isMilestone =>
      type == QuizNodeType.milestone || type == QuizNodeType.finalExam;

  /// Whether this node is the grand finale evaluation node.
  bool get isFinalExam => type == QuizNodeType.finalExam;

  /// Returns the localized title of this node using active locale.
  String getLocalizedTitle(BuildContext context) {
    final l10n = context.l10n;
    switch (topicKey) {
      // Unit 1: Sapaan dan Unggah-Ungguh Awal
      case 'salam':
        return l10n.quizTopicSalam;
      case 'pamit':
        return l10n.quizTopicPamit;
      case 'tanya_kabar':
        return l10n.quizTopicTanyaKabar;
      case 'perkenalan':
        return l10n.quizTopicPerkenalan;
      case 'sapa_wong':
        return l10n.quizTopicSapaWong;
      case 'matur_nuwun':
        return l10n.quizTopicMaturNuwun;
      case 'nyuwun_pangapunten':
        return l10n.quizTopicNyuwunPangapunten;
      case 'ungkapan_sopan':
      case 'lencana':
        return l10n.quizTopicUngkapanSopan;
      case 'percakapan_padinan':
        return l10n.quizTopicPercakapanPadinan;
      case 'evaluasi_unit1':
        return l10n.quizTopicEvaluasiUnit1;

      // Unit 2: Aksara Jawa Dasar (Legena)
      case 'pengenalan_hanacaraka':
        return l10n.quizTopicPengenalanHanacaraka;
      case 'aksara_hanacaraka':
        return l10n.quizTopicAksaraHanacaraka;
      case 'aksara_datasawala':
        return l10n.quizTopicAksaraDatasawala;
      case 'aksara_padhajayanya':
        return l10n.quizTopicAksaraPadhajayanya;
      case 'aksara_magabathanga':
        return l10n.quizTopicAksaraMagabathanga;
      case 'maca_aksara_dhasar':
        return l10n.quizTopicMacaAksaraDhasar;
      case 'nyusun_aksara_legena':
        return l10n.quizTopicNyusunAksaraLegena;
      case 'niteni_wujud_aksara':
        return l10n.quizTopicNiteniWujudAksara;
      case 'gladhen_maca_legena':
        return l10n.quizTopicGladhenMacaLegena;
      case 'evaluasi_unit2':
        return l10n.quizTopicEvaluasiUnit2;

      // Unit 3: Sandhangan dan Pasangan Aksara Jawa
      case 'sandhangan_swara':
        return l10n.quizTopicSandhanganSwara;
      case 'sandhangan_panyigeg':
        return l10n.quizTopicSandhanganPanyigeg;
      case 'sandhangan_wyanjana':
        return l10n.quizTopicSandhanganWyanjana;
      case 'pengenalan_pasangan':
        return l10n.quizTopicPengenalanPasangan;
      case 'penggunaan_pasangan':
      case 'pasangan_sejajar_gantung':
        return l10n.quizTopicPenggunaanPasangan;
      case 'maca_kata_sandhangan':
        return l10n.quizTopicMacaKataSandhangan;
      case 'nulis_kata_sederhana':
        return l10n.quizTopicNulisKataSederhana;
      case 'niteni_luput_nulis':
        return l10n.quizTopicNiteniLuputNulis;
      case 'gladhen_kombinasi':
        return l10n.quizTopicGladhenKombinasi;
      case 'evaluasi_unit3':
        return l10n.quizTopicEvaluasiUnit3;

      // Unit 4: Kosakata dan Tata Krama
      case 'kosakata_padinan':
      case 'keluarga_lan_kerabat':
        return l10n.quizTopicKosakataPadinan;
      case 'nama_benda':
      case 'omah_lan_sakiwatengene':
        return l10n.quizTopicNamaBenda;
      case 'nama_kegiatan':
      case 'kagiyatan_padinan':
        return l10n.quizTopicNamaKegiatan;
      case 'ngoko':
      case 'ngoko_lugu':
        return l10n.quizTopicNgoko;
      case 'krama':
      case 'ngoko_alus':
        return l10n.quizTopicKrama;
      case 'krama_inggil':
      case 'krama_lugu':
        return l10n.quizTopicKramaInggil;
      case 'perbedaan_tingkatan_bahasa':
        return l10n.quizTopicPerbedaanTingkatanBahasa;
      case 'percakapan_teman':
      case 'bandhingan_tingkat_basa':
        return l10n.quizTopicPercakapanTeman;
      case 'percakapan_dihormati':
      case 'wicara_unggah_ungguh':
        return l10n.quizTopicPercakapanDihormati;
      case 'evaluasi_unit4':
        return l10n.quizTopicEvaluasiUnit4;

      // Unit 5: Budaya dan Unggah-Ungguh
      case 'tata_krama_jawa':
      case 'ajining_dhiri':
        return l10n.quizTopicTataKramaJawa;
      case 'unggah_ungguh_basa':
        return l10n.quizTopicUnggahUngguhBasa;
      case 'peribahasa_jawa':
      case 'paribasan_jawa':
        return l10n.quizTopicPeribahasaJawa;
      case 'filosofi_kehidupan':
      case 'filosofi_urip':
        return l10n.quizTopicFilosofiKehidupan;
      case 'tradisi_jawa':
      case 'tradisi_pranatan':
        return l10n.quizTopicTradisiJawa;
      case 'budaya_kesenian':
      case 'pewayangan_pandhawa':
        return l10n.quizTopicBudayaKesenian;
      case 'situasi_padinan':
      case 'tembang_dolanan':
        return l10n.quizTopicSituasiPadinan;
      case 'tantangan_budaya':
      case 'etika_budaya':
        return l10n.quizTopicTantanganBudaya;
      case 'tantangan_akhir':
      case 'kawruh_luhur':
        return l10n.quizTopicTantanganAkhir;
      case 'evaluasi_akhir':
        return l10n.quizTopicEvaluasiAkhir;

      // Legacy fallback keys
      case 'keluarga':
        return l10n.quizTopicKeluarga;
      case 'rumah':
        return l10n.quizTopicRumah;
      case 'kerabat':
        return l10n.quizTopicKerabat;

      default:
        return title;
    }
  }

  /// Returns the localized description of this node using active locale.
  String getLocalizedDescription(BuildContext context) {
    final l10n = context.l10n;
    switch (topicKey) {
      // Unit 1: Sapaan dan Unggah-Ungguh Awal
      case 'salam':
        return l10n.quizTopicSalamDesc;
      case 'pamit':
        return l10n.quizTopicPamitDesc;
      case 'tanya_kabar':
        return l10n.quizTopicTanyaKabarDesc;
      case 'perkenalan':
        return l10n.quizTopicPerkenalanDesc;
      case 'sapa_wong':
        return l10n.quizTopicSapaWongDesc;
      case 'matur_nuwun':
        return l10n.quizTopicMaturNuwunDesc;
      case 'nyuwun_pangapunten':
        return l10n.quizTopicNyuwunPangapuntenDesc;
      case 'ungkapan_sopan':
      case 'lencana':
        return l10n.quizTopicUngkapanSopanDesc;
      case 'percakapan_padinan':
        return l10n.quizTopicPercakapanPadinanDesc;
      case 'evaluasi_unit1':
        return l10n.quizTopicEvaluasiUnit1Desc;

      // Unit 2: Aksara Jawa Dasar (Legena)
      case 'pengenalan_hanacaraka':
        return l10n.quizTopicPengenalanHanacarakaDesc;
      case 'aksara_hanacaraka':
        return l10n.quizTopicAksaraHanacarakaDesc;
      case 'aksara_datasawala':
        return l10n.quizTopicAksaraDatasawalaDesc;
      case 'aksara_padhajayanya':
        return l10n.quizTopicAksaraPadhajayanyaDesc;
      case 'aksara_magabathanga':
        return l10n.quizTopicAksaraMagabathangaDesc;
      case 'maca_aksara_dhasar':
        return l10n.quizTopicMacaAksaraDhasarDesc;
      case 'nyusun_aksara_legena':
        return l10n.quizTopicNyusunAksaraLegenaDesc;
      case 'niteni_wujud_aksara':
        return l10n.quizTopicNiteniWujudAksaraDesc;
      case 'gladhen_maca_legena':
        return l10n.quizTopicGladhenMacaLegenaDesc;
      case 'evaluasi_unit2':
        return l10n.quizTopicEvaluasiUnit2Desc;

      // Unit 3: Sandhangan dan Pasangan Aksara Jawa
      case 'sandhangan_swara':
        return l10n.quizTopicSandhanganSwaraDesc;
      case 'sandhangan_panyigeg':
        return l10n.quizTopicSandhanganPanyigegDesc;
      case 'sandhangan_wyanjana':
        return l10n.quizTopicSandhanganWyanjanaDesc;
      case 'pengenalan_pasangan':
        return l10n.quizTopicPengenalanPasanganDesc;
      case 'penggunaan_pasangan':
      case 'pasangan_sejajar_gantung':
        return l10n.quizTopicPenggunaanPasanganDesc;
      case 'maca_kata_sandhangan':
        return l10n.quizTopicMacaKataSandhanganDesc;
      case 'nulis_kata_sederhana':
        return l10n.quizTopicNulisKataSederhanaDesc;
      case 'niteni_luput_nulis':
        return l10n.quizTopicNiteniLuputNulisDesc;
      case 'gladhen_kombinasi':
        return l10n.quizTopicGladhenKombinasiDesc;
      case 'evaluasi_unit3':
        return l10n.quizTopicEvaluasiUnit3Desc;

      // Unit 4: Kosakata dan Tata Krama
      case 'kosakata_padinan':
      case 'keluarga_lan_kerabat':
        return l10n.quizTopicKosakataPadinanDesc;
      case 'nama_benda':
      case 'omah_lan_sakiwatengene':
        return l10n.quizTopicNamaBendaDesc;
      case 'nama_kegiatan':
      case 'kagiyatan_padinan':
        return l10n.quizTopicNamaKegiatanDesc;
      case 'ngoko':
      case 'ngoko_lugu':
        return l10n.quizTopicNgokoDesc;
      case 'krama':
      case 'ngoko_alus':
        return l10n.quizTopicKramaDesc;
      case 'krama_inggil':
      case 'krama_lugu':
        return l10n.quizTopicKramaInggilDesc;
      case 'perbedaan_tingkatan_bahasa':
        return l10n.quizTopicPerbedaanTingkatanBahasaDesc;
      case 'percakapan_teman':
      case 'bandhingan_tingkat_basa':
        return l10n.quizTopicPercakapanTemanDesc;
      case 'percakapan_dihormati':
      case 'wicara_unggah_ungguh':
        return l10n.quizTopicPercakapanDihormatiDesc;
      case 'evaluasi_unit4':
        return l10n.quizTopicEvaluasiUnit4Desc;

      // Unit 5: Budaya dan Unggah-Ungguh
      case 'tata_krama_jawa':
      case 'ajining_dhiri':
        return l10n.quizTopicTataKramaJawaDesc;
      case 'unggah_ungguh_basa':
        return l10n.quizTopicUnggahUngguhBasaDesc;
      case 'peribahasa_jawa':
      case 'paribasan_jawa':
        return l10n.quizTopicPeribahasaJawaDesc;
      case 'filosofi_kehidupan':
      case 'filosofi_urip':
        return l10n.quizTopicFilosofiKehidupanDesc;
      case 'tradisi_jawa':
      case 'tradisi_pranatan':
        return l10n.quizTopicTradisiJawaDesc;
      case 'budaya_kesenian':
      case 'pewayangan_pandhawa':
        return l10n.quizTopicBudayaKesenianDesc;
      case 'situasi_padinan':
      case 'tembang_dolanan':
        return l10n.quizTopicSituasiPadinanDesc;
      case 'tantangan_budaya':
      case 'etika_budaya':
        return l10n.quizTopicTantanganBudayaDesc;
      case 'tantangan_akhir':
      case 'kawruh_luhur':
        return l10n.quizTopicTantanganAkhirDesc;
      case 'evaluasi_akhir':
        return l10n.quizTopicEvaluasiAkhirDesc;

      // Legacy fallback keys
      case 'keluarga':
        return l10n.quizTopicKeluargaDesc;
      case 'rumah':
        return l10n.quizTopicRumahDesc;
      case 'kerabat':
        return l10n.quizTopicKerabatDesc;

      default:
        return description;
    }
  }

  /// Returns the localized unit title displayed on bottom sheet.
  String getUnitTitle(BuildContext context) {
    return context.l10n.quizUnitTitle(unitId, context.l10n.difficultyMudah);
  }

  /// Creates a copy of this node with updated attributes.
  QuizPathNode copyWith({
    NodeStatus? status,
    QuizNodePosition? position,
    QuizNodeType? type,
  }) {
    return QuizPathNode(
      id: id,
      unitId: unitId,
      nodeNumber: nodeNumber,
      indexInUnit: indexInUnit,
      topicKey: topicKey,
      glyph: glyph,
      type: type ?? this.type,
      position: position ?? this.position,
      status: status ?? this.status,
    );
  }

  static String _fallbackTitle(String key) {
    switch (key) {
      // Unit 1
      case 'salam':
        return 'Salam';
      case 'pamit':
        return 'Pamit';
      case 'tanya_kabar':
        return 'Tanya Kabar';
      case 'perkenalan':
        return 'Memperkenalkan Diri';
      case 'sapa_wong':
        return 'Menyapa Orang Lain';
      case 'matur_nuwun':
        return 'Ungkapan Terima Kasih';
      case 'nyuwun_pangapunten':
        return 'Meminta Maaf';
      case 'ungkapan_sopan':
      case 'lencana':
        return 'Ungkapan Sopan';
      case 'percakapan_padinan':
        return 'Percakapan Sehari-hari';
      case 'evaluasi_unit1':
        return 'Evaluasi Unit 1';

      // Unit 2
      case 'pengenalan_hanacaraka':
        return 'Pengenalan Hanacaraka';
      case 'aksara_hanacaraka':
        return 'Aksara Ha Na Ca Ra Ka';
      case 'aksara_datasawala':
        return 'Aksara Da Ta Sa Wa La';
      case 'aksara_padhajayanya':
        return 'Aksara Pa Dha Ja Ya Nya';
      case 'aksara_magabathanga':
        return 'Aksara Ma Ga Ba Tha Nga';
      case 'maca_aksara_dhasar':
        return 'Membaca Aksara Dasar';
      case 'nyusun_aksara_legena':
        return 'Menyusun Aksara';
      case 'niteni_wujud_aksara':
        return 'Mengenali Bentuk Aksara';
      case 'gladhen_maca_legena':
        return 'Latihan Membaca';
      case 'evaluasi_unit2':
        return 'Evaluasi Unit 2';

      // Unit 3
      case 'sandhangan_swara':
        return 'Sandangan Swara';
      case 'sandhangan_panyigeg':
        return 'Sandangan Panyigeg Wanda';
      case 'sandhangan_wyanjana':
        return 'Sandangan Wyanjana';
      case 'pengenalan_pasangan':
        return 'Pengenalan Pasangan';
      case 'penggunaan_pasangan':
      case 'pasangan_sejajar_gantung':
        return 'Penggunaan Pasangan';
      case 'maca_kata_sandhangan':
        return 'Membaca Kata Bersandangan';
      case 'nulis_kata_sederhana':
        return 'Menulis Kata Sederhana';
      case 'niteni_luput_nulis':
        return 'Mengenali Kesalahan Penulisan';
      case 'gladhen_kombinasi':
        return 'Latihan Kombinasi';
      case 'evaluasi_unit3':
        return 'Evaluasi Unit 3';

      // Unit 4
      case 'kosakata_padinan':
      case 'keluarga_lan_kerabat':
        return 'Kosakata Sehari-hari';
      case 'nama_benda':
      case 'omah_lan_sakiwatengene':
        return 'Nama Benda';
      case 'nama_kegiatan':
      case 'kagiyatan_padinan':
        return 'Nama Kegiatan';
      case 'ngoko':
      case 'ngoko_lugu':
        return 'Ngoko';
      case 'krama':
      case 'ngoko_alus':
        return 'Krama';
      case 'krama_inggil':
      case 'krama_lugu':
        return 'Krama Inggil';
      case 'perbedaan_tingkatan_bahasa':
        return 'Perbedaan Tingkatan Bahasa';
      case 'percakapan_teman':
      case 'bandhingan_tingkat_basa':
        return 'Percakapan dengan Teman';
      case 'percakapan_dihormati':
      case 'wicara_unggah_ungguh':
        return 'Percakapan dengan Orang yang Dihormati';
      case 'evaluasi_unit4':
        return 'Evaluasi Unit 4';

      // Unit 5
      case 'tata_krama_jawa':
      case 'ajining_dhiri':
        return 'Tata Krama Jawa';
      case 'unggah_ungguh_basa':
        return 'Unggah-Ungguh Basa';
      case 'peribahasa_jawa':
      case 'paribasan_jawa':
        return 'Peribahasa Jawa';
      case 'filosofi_kehidupan':
      case 'filosofi_urip':
        return 'Filosofi Kehidupan Jawa';
      case 'tradisi_jawa':
      case 'tradisi_pranatan':
        return 'Tradisi Jawa';
      case 'budaya_kesenian':
      case 'pewayangan_pandhawa':
        return 'Budaya dan Kesenian';
      case 'situasi_padinan':
      case 'tembang_dolanan':
        return 'Situasi Kehidupan Sehari-hari';
      case 'tantangan_budaya':
      case 'etika_budaya':
        return 'Tantangan Pemahaman Budaya';
      case 'tantangan_akhir':
      case 'kawruh_luhur':
        return 'Tantangan Akhir';
      case 'evaluasi_akhir':
        return 'Evaluasi Akhir JawaLoka';
      default:
        return key.replaceAll('_', ' ');
    }
  }

  static String _fallbackDescription(String key) {
    return 'Pelajari materi  pada pembelajaran JawaLoka.';
  }
}

/// Domain model representing a learning unit comprising 10 nodes.
class QuizUnitData {
  /// 1-based unit ID (1 through 5).
  final int unitId;

  /// The 10 nodes belonging to this unit.
  final List<QuizPathNode> nodes;

  /// Whether the entire unit is locked.
  final bool isLocked;

  const QuizUnitData({
    required this.unitId,
    required this.nodes,
    this.isLocked = false,
  });

  /// Fallback title for non-widget contexts.
  String get title => _fallbackUnitTitle(unitId);

  /// Fallback subtitle for non-widget contexts.
  String get subtitle => _fallbackUnitSubtitle(unitId);

  /// Total number of nodes in this unit (10).
  int get totalNodes => nodes.length;

  /// Total completed nodes in this unit.
  int get completedCount =>
      nodes.where((n) => n.status == NodeStatus.completed).length;

  /// Ratio of completed nodes [0.0, 1.0].
  double get progressRatio =>
      totalNodes > 0 ? (completedCount / totalNodes).clamp(0.0, 1.0) : 0.0;

  /// Returns localized unit title.
  String getLocalizedTitle(BuildContext context) {
    final l10n = context.l10n;
    switch (unitId) {
      case 1:
        return l10n.quizUnit1Title;
      case 2:
        return l10n.quizUnit2Title;
      case 3:
        return l10n.quizUnit3Title;
      case 4:
        return l10n.quizUnit4Title;
      case 5:
        return l10n.quizUnit5Title;
      default:
        return 'Unit ';
    }
  }

  /// Returns localized unit subtitle.
  String getLocalizedSubtitle(BuildContext context) {
    final l10n = context.l10n;
    switch (unitId) {
      case 1:
        return l10n.quizUnit1Subtitle;
      case 2:
        return l10n.quizUnit2Subtitle;
      case 3:
        return l10n.quizUnit3Subtitle;
      case 4:
        return l10n.quizUnit4Subtitle;
      case 5:
        return l10n.quizUnit5Subtitle;
      default:
        return '';
    }
  }

  static String _fallbackUnitTitle(int id) {
    switch (id) {
      case 1:
        return 'Unit 1: Sapaan dan Unggah-Ungguh Awal';
      case 2:
        return 'Unit 2: Aksara Jawa Dasar (Legena)';
      case 3:
        return 'Unit 3: Sandhangan dan Pasangan Aksara Jawa';
      case 4:
        return 'Unit 4: Kosakata dan Tingkatan Bahasa';
      case 5:
        return 'Unit 5: Budaya, Paribasan, dan Kawruh Luhur';
      default:
        return 'Unit ';
    }
  }

  static String _fallbackUnitSubtitle(int id) {
    switch (id) {
      case 1:
        return 'Dasar percakapan dan tata krama sopan santun';
      case 2:
        return 'Pengenalan 20 aksara legena Hanacaraka';
      case 3:
        return 'Vokalisasi, konsonan penutup, dan pasangan aksara';
      case 4:
        return 'Tingkatan ngoko, krama lugu, dan krama inggil';
      case 5:
        return 'Paribasan, filosofi, adat tradisi, dan kawruh luhur Jawa';
      default:
        return '';
    }
  }
}
