import 'quiz_path_models.dart';

/// Classification tier of a legacy activity alias according to curriculum equivalency.
enum LegacyAliasTier {
  /// 1:1 exact competency match. Grants canonical completion credit automatically.
  safe,

  /// Broader or related topic, but not 1:1 identical competency.
  /// Preserves historical progression without automatic canonical mastery.
  conditional,

  /// Distinct grammatical/thematic competency.
  /// Preserves historical progression without automatic canonical mastery.
  unsafe,
}

/// Central repository defining the 50-node curriculum and 5 learning units of JawaLoka.
class QuizPathData {
  QuizPathData._();

  /// Canonical definition of the 50-node journey across 5 thematic units.
  static final List<QuizUnitData> units = [
    // =========================================================================
    // UNIT 1 (Node 1–10)
    // =========================================================================
    QuizUnitData(
      unitId: 1,
      isLocked: false,
      nodes: [
        const QuizPathNode(
          id: 'path_node_u1_n01_salam',
          unitId: 1,
          nodeNumber: 1,
          indexInUnit: 1,
          topicKey: 'salam',
          glyph: 'ꦱ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.completed,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n02_pamit',
          unitId: 1,
          nodeNumber: 2,
          indexInUnit: 2,
          topicKey: 'pamit',
          glyph: 'ꦥ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.completed,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n03_tanya_kabar',
          unitId: 1,
          nodeNumber: 3,
          indexInUnit: 3,
          topicKey: 'tanya_kabar',
          glyph: 'ꦏ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.completed,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n04_perkenalan',
          unitId: 1,
          nodeNumber: 4,
          indexInUnit: 4,
          topicKey: 'perkenalan',
          glyph: 'ꦤ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.current,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n05_sapa_wong',
          unitId: 1,
          nodeNumber: 5,
          indexInUnit: 5,
          topicKey: 'sapa_wong',
          glyph: 'ꦮ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n06_matur_nuwun',
          unitId: 1,
          nodeNumber: 6,
          indexInUnit: 6,
          topicKey: 'matur_nuwun',
          glyph: 'ꦩ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n07_nyuwun_pangapunten',
          unitId: 1,
          nodeNumber: 7,
          indexInUnit: 7,
          topicKey: 'nyuwun_pangapunten',
          glyph: 'ꦚ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n08_ungkapan_sopan',
          unitId: 1,
          nodeNumber: 8,
          indexInUnit: 8,
          topicKey: 'ungkapan_sopan',
          glyph: 'ꦭ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n09_percakapan_padinan',
          unitId: 1,
          nodeNumber: 9,
          indexInUnit: 9,
          topicKey: 'percakapan_padinan',
          glyph: 'ꦢ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u1_n10_evaluasi_unit1',
          unitId: 1,
          nodeNumber: 10,
          indexInUnit: 10,
          topicKey: 'evaluasi_unit1',
          glyph: 'ꦲ',
          type: QuizNodeType.milestone,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
      ],
    ),
    // =========================================================================
    // UNIT 2 (Node 11–20)
    // =========================================================================
    QuizUnitData(
      unitId: 2,
      isLocked: true,
      nodes: [
        const QuizPathNode(
          id: 'path_node_u2_n11_pengenalan_hanacaraka',
          unitId: 2,
          nodeNumber: 11,
          indexInUnit: 1,
          topicKey: 'pengenalan_hanacaraka',
          glyph: 'ꦲ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n12_aksara_hanacaraka',
          unitId: 2,
          nodeNumber: 12,
          indexInUnit: 2,
          topicKey: 'aksara_hanacaraka',
          glyph: 'ꦕ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n13_aksara_datasawala',
          unitId: 2,
          nodeNumber: 13,
          indexInUnit: 3,
          topicKey: 'aksara_datasawala',
          glyph: 'ꦢ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n14_aksara_padhajayanya',
          unitId: 2,
          nodeNumber: 14,
          indexInUnit: 4,
          topicKey: 'aksara_padhajayanya',
          glyph: 'ꦝ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n15_aksara_magabathanga',
          unitId: 2,
          nodeNumber: 15,
          indexInUnit: 5,
          topicKey: 'aksara_magabathanga',
          glyph: 'ꦒ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n16_maca_aksara_dhasar',
          unitId: 2,
          nodeNumber: 16,
          indexInUnit: 6,
          topicKey: 'maca_aksara_dhasar',
          glyph: 'ꦏ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n17_nyusun_aksara_legena',
          unitId: 2,
          nodeNumber: 17,
          indexInUnit: 7,
          topicKey: 'nyusun_aksara_legena',
          glyph: 'ꦱ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n18_niteni_wujud_aksara',
          unitId: 2,
          nodeNumber: 18,
          indexInUnit: 8,
          topicKey: 'niteni_wujud_aksara',
          glyph: 'ꦮ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n19_gladhen_maca_legena',
          unitId: 2,
          nodeNumber: 19,
          indexInUnit: 9,
          topicKey: 'gladhen_maca_legena',
          glyph: 'ꦭ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u2_n20_evaluasi_unit2',
          unitId: 2,
          nodeNumber: 20,
          indexInUnit: 10,
          topicKey: 'evaluasi_unit2',
          glyph: 'ꦚ',
          type: QuizNodeType.milestone,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
      ],
    ),
    // =========================================================================
    // UNIT 3 (Node 21–30)
    // =========================================================================
    QuizUnitData(
      unitId: 3,
      isLocked: true,
      nodes: [
        const QuizPathNode(
          id: 'path_node_u3_n21_sandhangan_swara',
          unitId: 3,
          nodeNumber: 21,
          indexInUnit: 1,
          topicKey: 'sandhangan_swara',
          glyph: 'ꦶ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n22_sandhangan_panyigeg',
          unitId: 3,
          nodeNumber: 22,
          indexInUnit: 2,
          topicKey: 'sandhangan_panyigeg',
          glyph: 'ꦃ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n23_sandhangan_wyanjana',
          unitId: 3,
          nodeNumber: 23,
          indexInUnit: 3,
          topicKey: 'sandhangan_wyanjana',
          glyph: 'ꦿ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n24_pengenalan_pasangan',
          unitId: 3,
          nodeNumber: 24,
          indexInUnit: 4,
          topicKey: 'pengenalan_pasangan',
          glyph: '꧀ꦤ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n25_penggunaan_pasangan',
          unitId: 3,
          nodeNumber: 25,
          indexInUnit: 5,
          topicKey: 'penggunaan_pasangan',
          glyph: '꧀ꦏ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n26_maca_kata_sandhangan',
          unitId: 3,
          nodeNumber: 26,
          indexInUnit: 6,
          topicKey: 'maca_kata_sandhangan',
          glyph: 'ꦸ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n27_nulis_kata_sederhana',
          unitId: 3,
          nodeNumber: 27,
          indexInUnit: 7,
          topicKey: 'nulis_kata_sederhana',
          glyph: 'ꦺ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n28_niteni_luput_nulis',
          unitId: 3,
          nodeNumber: 28,
          indexInUnit: 8,
          topicKey: 'niteni_luput_nulis',
          glyph: '꧀',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n29_gladhen_kombinasi',
          unitId: 3,
          nodeNumber: 29,
          indexInUnit: 9,
          topicKey: 'gladhen_kombinasi',
          glyph: 'ꦁ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u3_n30_evaluasi_unit3',
          unitId: 3,
          nodeNumber: 30,
          indexInUnit: 10,
          topicKey: 'evaluasi_unit3',
          glyph: 'ꦂ',
          type: QuizNodeType.milestone,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
      ],
    ),
    // =========================================================================
    // UNIT 4 (Node 31–40)
    // =========================================================================
    QuizUnitData(
      unitId: 4,
      isLocked: true,
      nodes: [
        const QuizPathNode(
          id: 'path_node_u4_n31_kosakata_padinan',
          unitId: 4,
          nodeNumber: 31,
          indexInUnit: 1,
          topicKey: 'kosakata_padinan',
          glyph: 'ꦏ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n32_nama_benda',
          unitId: 4,
          nodeNumber: 32,
          indexInUnit: 2,
          topicKey: 'nama_benda',
          glyph: 'ꦫ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n33_nama_kegiatan',
          unitId: 4,
          nodeNumber: 33,
          indexInUnit: 3,
          topicKey: 'nama_kegiatan',
          glyph: 'ꦭ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n34_ngoko',
          unitId: 4,
          nodeNumber: 34,
          indexInUnit: 4,
          topicKey: 'ngoko',
          glyph: 'ꦔ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n35_krama',
          unitId: 4,
          nodeNumber: 35,
          indexInUnit: 5,
          topicKey: 'krama',
          glyph: 'ꦒ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n36_krama_inggil',
          unitId: 4,
          nodeNumber: 36,
          indexInUnit: 6,
          topicKey: 'krama_inggil',
          glyph: 'ꦪ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n37_perbedaan_tingkatan_bahasa',
          unitId: 4,
          nodeNumber: 37,
          indexInUnit: 7,
          topicKey: 'perbedaan_tingkatan_bahasa',
          glyph: 'ꦧ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n38_percakapan_teman',
          unitId: 4,
          nodeNumber: 38,
          indexInUnit: 8,
          topicKey: 'percakapan_teman',
          glyph: 'ꦩ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n39_percakapan_dihormati',
          unitId: 4,
          nodeNumber: 39,
          indexInUnit: 9,
          topicKey: 'percakapan_dihormati',
          glyph: 'ꦠ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u4_n40_evaluasi_unit4',
          unitId: 4,
          nodeNumber: 40,
          indexInUnit: 10,
          topicKey: 'evaluasi_unit4',
          glyph: 'ꦢ',
          type: QuizNodeType.milestone,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
      ],
    ),
    // =========================================================================
    // UNIT 5 (Node 41–50)
    // =========================================================================
    QuizUnitData(
      unitId: 5,
      isLocked: true,
      nodes: [
        const QuizPathNode(
          id: 'path_node_u5_n41_tata_krama_jawa',
          unitId: 5,
          nodeNumber: 41,
          indexInUnit: 1,
          topicKey: 'tata_krama_jawa',
          glyph: 'ꦭ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n42_unggah_ungguh_basa',
          unitId: 5,
          nodeNumber: 42,
          indexInUnit: 2,
          topicKey: 'unggah_ungguh_basa',
          glyph: 'ꦲ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n43_peribahasa_jawa',
          unitId: 5,
          nodeNumber: 43,
          indexInUnit: 3,
          topicKey: 'peribahasa_jawa',
          glyph: 'ꦗ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n44_filosofi_kehidupan',
          unitId: 5,
          nodeNumber: 44,
          indexInUnit: 4,
          topicKey: 'filosofi_kehidupan',
          glyph: 'ꦈ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n45_tradisi_jawa',
          unitId: 5,
          nodeNumber: 45,
          indexInUnit: 5,
          topicKey: 'tradisi_jawa',
          glyph: 'ꦠ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n46_budaya_kesenian',
          unitId: 5,
          nodeNumber: 46,
          indexInUnit: 6,
          topicKey: 'budaya_kesenian',
          glyph: 'ꦥ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n47_situasi_padinan',
          unitId: 5,
          nodeNumber: 47,
          indexInUnit: 7,
          topicKey: 'situasi_padinan',
          glyph: 'ꦢ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.right,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n48_tantangan_budaya',
          unitId: 5,
          nodeNumber: 48,
          indexInUnit: 8,
          topicKey: 'tantangan_budaya',
          glyph: 'ꦧ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n49_tantangan_akhir',
          unitId: 5,
          nodeNumber: 49,
          indexInUnit: 9,
          topicKey: 'tantangan_akhir',
          glyph: 'ꦱ',
          type: QuizNodeType.regular,
          position: QuizNodePosition.left,
          status: NodeStatus.locked,
        ),
        const QuizPathNode(
          id: 'path_node_u5_n50_evaluasi_akhir',
          unitId: 5,
          nodeNumber: 50,
          indexInUnit: 10,
          topicKey: 'evaluasi_akhir',
          glyph: 'ꦏ',
          type: QuizNodeType.finalExam,
          position: QuizNodePosition.center,
          status: NodeStatus.locked,
        ),
      ],
    ),
  ];

  /// Flat cache of all 50 nodes ordered sequentially from Node 1 to 50.
  static final List<QuizPathNode> allNodes = units
      .expand((unit) => unit.nodes)
      .toList(growable: false);

  /// Fast lookup of a node by its canonical activity ID.
  static final Map<String, QuizPathNode> _nodeById = {
    for (final node in allNodes) node.id: node,
  };

  /// Fast lookup of a node by its 1-based global number (1 through 50).
  static final Map<int, QuizPathNode> _nodeByNumber = {
    for (final node in allNodes) node.nodeNumber: node,
  };

  /// Returns the node corresponding to [nodeNumber] (1 through 50), or `null`.
  static QuizPathNode? getNodeByNumber(int nodeNumber) =>
      _nodeByNumber[nodeNumber];

  /// Peta alias aktivitas lawas untuk backward compatibility data penyimpanan progres.
  /// Peta alias ID aktivitas lawas (Generasi 1 dan 2) ke ID aktivitas kanonikal saat ini.
  /// Memastikan progres pengguna lama tetap terbaca secara semantik dan idempoten.
  static const Map<String, String> legacyActivityAliases = {
    // -------------------------------------------------------------------------
    // Unit 1: Sapaan dan Unggah-Ungguh Awal
    // -------------------------------------------------------------------------
    'path_node_u1_n03_lencana': 'path_node_u1_n08_ungkapan_sopan',
    'path_node_u1_n04_tanya_kabar': 'path_node_u1_n03_tanya_kabar',
    'path_node_u1_n05_perkenalan': 'path_node_u1_n04_perkenalan',
    'path_node_u1_n06_sapa_wong': 'path_node_u1_n05_sapa_wong',
    'path_node_u1_n06_terima_kasih': 'path_node_u1_n06_matur_nuwun',
    'path_node_u1_n07_minta_maaf': 'path_node_u1_n07_nyuwun_pangapunten',
    'path_node_u1_n07_matur_nuwun': 'path_node_u1_n06_matur_nuwun',
    'path_node_u1_n08_nyuwun_pangapunten': 'path_node_u1_n07_nyuwun_pangapunten',
    'path_node_u1_n09_pacelathon_padinan': 'path_node_u1_n09_percakapan_padinan',

    // -------------------------------------------------------------------------
    // Unit 2: Aksara Jawa Dasar (Legena)
    // -------------------------------------------------------------------------
    'path_node_u2_n14_pengenalan_carakan': 'path_node_u2_n11_pengenalan_hanacaraka',
    'path_node_u2_n15_aksara_hanacaraka': 'path_node_u2_n12_aksara_hanacaraka',
    'path_node_u2_n16_aksara_datasawala': 'path_node_u2_n13_aksara_datasawala',
    'path_node_u2_n17_aksara_padhajayanya': 'path_node_u2_n14_aksara_padhajayanya',
    'path_node_u2_n18_aksara_magabathanga': 'path_node_u2_n15_aksara_magabathanga',
    'path_node_u2_n19_membaca_kata_dasar': 'path_node_u2_n16_maca_aksara_dhasar',

    // -------------------------------------------------------------------------
    // Unit 3: Sandhangan dan Pasangan Aksara Jawa
    // -------------------------------------------------------------------------
    'path_node_u3_n21_sandhangan_swara_i_u': 'path_node_u3_n21_sandhangan_swara',
    'path_node_u3_n22_sandhangan_swara_e_o': 'path_node_u3_n21_sandhangan_swara',
    'path_node_u3_n23_sandhangan_panyigeg_h_r': 'path_node_u3_n22_sandhangan_panyigeg',
    'path_node_u3_n24_sandhangan_panyigeg_ng_pangkon': 'path_node_u3_n22_sandhangan_panyigeg',
    'path_node_u3_n25_sandhangan_wyanjana': 'path_node_u3_n23_sandhangan_wyanjana',
    'path_node_u3_n26_membaca_kata_bersandhangan': 'path_node_u3_n26_maca_kata_sandhangan',
    'path_node_u3_n27_pengenalan_pasangan': 'path_node_u3_n24_pengenalan_pasangan',
    'path_node_u3_n28_pasangan_sejajar_gantung': 'path_node_u3_n25_penggunaan_pasangan',
    'path_node_u3_n29_latihan_kombinasi_aksara': 'path_node_u3_n29_gladhen_kombinasi',

    // -------------------------------------------------------------------------
    // Unit 4: Kosakata dan Tingkatan Bahasa (Ngoko dan Krama)
    // -------------------------------------------------------------------------
    'path_node_u4_n31_kosakata_omah': 'path_node_u4_n32_nama_benda',
    'path_node_u4_n31_keluarga_lan_kerabat': 'path_node_u4_n31_kosakata_padinan',
    'path_node_u4_n32_kosakata_kegiatan': 'path_node_u4_n33_nama_kegiatan',
    'path_node_u4_n32_omah_lan_sakiwatengene': 'path_node_u4_n32_nama_benda',
    'path_node_u4_n33_kagiyatan_padinan': 'path_node_u4_n33_nama_kegiatan',
    'path_node_u4_n33_ngoko_lugu': 'path_node_u4_n34_ngoko',
    'path_node_u4_n34_ngoko_lugu': 'path_node_u4_n34_ngoko',
    'path_node_u4_n34_ngoko_alus': 'path_node_u4_n34_ngoko',
    'path_node_u4_n35_ngoko_alus': 'path_node_u4_n35_krama',
    'path_node_u4_n35_krama_lugu': 'path_node_u4_n35_krama',
    'path_node_u4_n36_krama_lugu': 'path_node_u4_n36_krama_inggil',
    'path_node_u4_n37_krama_inggil': 'path_node_u4_n37_perbedaan_tingkatan_bahasa',
    'path_node_u4_n37_perbandingan_tingkatan': 'path_node_u4_n37_perbedaan_tingkatan_bahasa',
    'path_node_u4_n38_bandhingan_tingkat_basa': 'path_node_u4_n38_percakapan_teman',
    'path_node_u4_n38_wicara_marang_kanca': 'path_node_u4_n38_percakapan_teman',
    'path_node_u4_n39_wicara_unggah_ungguh': 'path_node_u4_n39_percakapan_dihormati',
    'path_node_u4_n39_wicara_marang_sesepuh': 'path_node_u4_n39_percakapan_dihormati',

    // -------------------------------------------------------------------------
    // Unit 5: Budaya, Paribasan, dan Kawruh Luhur Jawa
    // -------------------------------------------------------------------------
    'path_node_u5_n41_ajining_dhiri': 'path_node_u5_n41_tata_krama_jawa',
    'path_node_u5_n41_paribasan_lathi': 'path_node_u5_n41_tata_krama_jawa',
    'path_node_u5_n42_filosofi_jawa': 'path_node_u5_n44_filosofi_kehidupan',
    'path_node_u5_n42_paribasan_urip_urup': 'path_node_u5_n44_filosofi_kehidupan',
    'path_node_u5_n43_paribasan_jawa': 'path_node_u5_n43_peribahasa_jawa',
    'path_node_u5_n43_paribasan_jer_basuki': 'path_node_u5_n43_peribahasa_jawa',
    'path_node_u5_n43_tradisi_jawa': 'path_node_u5_n45_tradisi_jawa',
    'path_node_u5_n44_filosofi_urip': 'path_node_u5_n44_filosofi_kehidupan',
    'path_node_u5_n44_paribasan_rukun_santosa': 'path_node_u5_n43_peribahasa_jawa',
    'path_node_u5_n44_seni_budaya': 'path_node_u5_n46_budaya_kesenian',
    'path_node_u5_n45_kearifan_lokal': 'path_node_u5_n44_filosofi_kehidupan',
    'path_node_u5_n45_tokoh_pandhawa': 'path_node_u5_n46_budaya_kesenian',
    'path_node_u5_n45_tradisi_pranatan': 'path_node_u5_n45_tradisi_jawa',
    'path_node_u5_n46_pewayangan_pandhawa': 'path_node_u5_n46_budaya_kesenian',
    'path_node_u5_n46_tembang_dolanan': 'path_node_u5_n47_situasi_padinan',
    'path_node_u5_n46_unggah_ungguh': 'path_node_u5_n42_unggah_ungguh_basa',
    'path_node_u5_n47_adat_tradisi_jawa': 'path_node_u5_n45_tradisi_jawa',
    'path_node_u5_n47_tembang_dolanan': 'path_node_u5_n47_situasi_padinan',
    'path_node_u5_n47_tantangan_budaya': 'path_node_u5_n48_tantangan_budaya',
    'path_node_u5_n48_busana_tradisional': 'path_node_u5_n45_tradisi_jawa',
    'path_node_u5_n48_etika_budaya': 'path_node_u5_n48_tantangan_budaya',
    'path_node_u5_n48_tantangan_akhir': 'path_node_u5_n49_tantangan_akhir',
    'path_node_u5_n49_evaluasi_unit5': 'path_node_u5_n49_tantangan_akhir',
    'path_node_u5_n49_kawruh_luhur': 'path_node_u5_n49_tantangan_akhir',
    'path_node_u5_n49_tantangan_budaya': 'path_node_u5_n48_tantangan_budaya',
  };

  /// Explicit pedagogical tier classification for every unique legacy alias.
  ///
  /// Enforces:
  /// - [LegacyAliasTier.safe]: 1:1 competency equivalence; awards automatic completion credit.
  /// - [LegacyAliasTier.conditional]: Broader or partial overlap; requires canonical proof for mastery.
  /// - [LegacyAliasTier.unsafe]: Semantic or grammatical divergence; requires canonical proof for mastery.
  static const Map<String, LegacyAliasTier> legacyAliasTiers = {
    // -------------------------------------------------------------------------
    // Unit 1: Sapaan dan Unggah-Ungguh Awal (9 aliases - all SAFE)
    // -------------------------------------------------------------------------
    'path_node_u1_n03_lencana': LegacyAliasTier.safe,
    'path_node_u1_n04_tanya_kabar': LegacyAliasTier.safe,
    'path_node_u1_n05_perkenalan': LegacyAliasTier.safe,
    'path_node_u1_n06_sapa_wong': LegacyAliasTier.safe,
    'path_node_u1_n06_terima_kasih': LegacyAliasTier.safe,
    'path_node_u1_n07_minta_maaf': LegacyAliasTier.safe,
    'path_node_u1_n07_matur_nuwun': LegacyAliasTier.safe,
    'path_node_u1_n08_nyuwun_pangapunten': LegacyAliasTier.safe,
    'path_node_u1_n09_pacelathon_padinan': LegacyAliasTier.safe,

    // -------------------------------------------------------------------------
    // Unit 2: Aksara Jawa Dasar (Legena) (6 aliases - all SAFE)
    // -------------------------------------------------------------------------
    'path_node_u2_n14_pengenalan_carakan': LegacyAliasTier.safe,
    'path_node_u2_n15_aksara_hanacaraka': LegacyAliasTier.safe,
    'path_node_u2_n16_aksara_datasawala': LegacyAliasTier.safe,
    'path_node_u2_n17_aksara_padhajayanya': LegacyAliasTier.safe,
    'path_node_u2_n18_aksara_magabathanga': LegacyAliasTier.safe,
    'path_node_u2_n19_membaca_kata_dasar': LegacyAliasTier.safe,

    // -------------------------------------------------------------------------
    // Unit 3: Sandhangan dan Pasangan Aksara Jawa (9 aliases - all SAFE)
    // -------------------------------------------------------------------------
    'path_node_u3_n21_sandhangan_swara_i_u': LegacyAliasTier.safe,
    'path_node_u3_n22_sandhangan_swara_e_o': LegacyAliasTier.safe,
    'path_node_u3_n23_sandhangan_panyigeg_h_r': LegacyAliasTier.safe,
    'path_node_u3_n24_sandhangan_panyigeg_ng_pangkon': LegacyAliasTier.safe,
    'path_node_u3_n25_sandhangan_wyanjana': LegacyAliasTier.safe,
    'path_node_u3_n26_membaca_kata_bersandhangan': LegacyAliasTier.safe,
    'path_node_u3_n27_pengenalan_pasangan': LegacyAliasTier.safe,
    'path_node_u3_n28_pasangan_sejajar_gantung': LegacyAliasTier.safe,
    'path_node_u3_n29_latihan_kombinasi_aksara': LegacyAliasTier.safe,

    // -------------------------------------------------------------------------
    // Unit 4: Kosakata dan Tingkatan Bahasa (17 aliases)
    // -------------------------------------------------------------------------
    'path_node_u4_n31_kosakata_omah': LegacyAliasTier.safe,
    'path_node_u4_n31_keluarga_lan_kerabat': LegacyAliasTier.safe,
    'path_node_u4_n32_kosakata_kegiatan': LegacyAliasTier.safe,
    'path_node_u4_n32_omah_lan_sakiwatengene': LegacyAliasTier.safe,
    'path_node_u4_n33_kagiyatan_padinan': LegacyAliasTier.safe,
    'path_node_u4_n33_ngoko_lugu': LegacyAliasTier.safe,
    'path_node_u4_n34_ngoko_lugu': LegacyAliasTier.safe,
    'path_node_u4_n34_ngoko_alus': LegacyAliasTier.safe,
    'path_node_u4_n35_ngoko_alus': LegacyAliasTier.unsafe,
    'path_node_u4_n35_krama_lugu': LegacyAliasTier.safe,
    'path_node_u4_n36_krama_lugu': LegacyAliasTier.unsafe,
    'path_node_u4_n37_krama_inggil': LegacyAliasTier.safe,
    'path_node_u4_n37_perbandingan_tingkatan': LegacyAliasTier.safe,
    'path_node_u4_n38_bandhingan_tingkat_basa': LegacyAliasTier.unsafe,
    'path_node_u4_n38_wicara_marang_kanca': LegacyAliasTier.safe,
    'path_node_u4_n39_wicara_unggah_ungguh': LegacyAliasTier.safe,
    'path_node_u4_n39_wicara_marang_sesepuh': LegacyAliasTier.safe,

    // -------------------------------------------------------------------------
    // Unit 5: Budaya, Paribasan, dan Kawruh Luhur Jawa (25 aliases)
    // -------------------------------------------------------------------------
    'path_node_u5_n41_ajining_dhiri': LegacyAliasTier.safe,
    'path_node_u5_n41_paribasan_lathi': LegacyAliasTier.safe,
    'path_node_u5_n42_filosofi_jawa': LegacyAliasTier.safe,
    'path_node_u5_n42_paribasan_urip_urup': LegacyAliasTier.safe,
    'path_node_u5_n43_paribasan_jawa': LegacyAliasTier.safe,
    'path_node_u5_n43_paribasan_jer_basuki': LegacyAliasTier.safe,
    'path_node_u5_n43_tradisi_jawa': LegacyAliasTier.safe,
    'path_node_u5_n44_filosofi_urip': LegacyAliasTier.safe,
    'path_node_u5_n44_paribasan_rukun_santosa': LegacyAliasTier.safe,
    'path_node_u5_n44_seni_budaya': LegacyAliasTier.safe,
    'path_node_u5_n45_kearifan_lokal': LegacyAliasTier.conditional,
    'path_node_u5_n45_tokoh_pandhawa': LegacyAliasTier.conditional,
    'path_node_u5_n45_tradisi_pranatan': LegacyAliasTier.safe,
    'path_node_u5_n46_pewayangan_pandhawa': LegacyAliasTier.conditional,
    'path_node_u5_n46_tembang_dolanan': LegacyAliasTier.unsafe,
    'path_node_u5_n46_unggah_ungguh': LegacyAliasTier.safe,
    'path_node_u5_n47_adat_tradisi_jawa': LegacyAliasTier.safe,
    'path_node_u5_n47_tembang_dolanan': LegacyAliasTier.unsafe,
    'path_node_u5_n47_tantangan_budaya': LegacyAliasTier.safe,
    'path_node_u5_n48_busana_tradisional': LegacyAliasTier.conditional,
    'path_node_u5_n48_etika_budaya': LegacyAliasTier.safe,
    'path_node_u5_n48_tantangan_akhir': LegacyAliasTier.safe,
    'path_node_u5_n49_evaluasi_unit5': LegacyAliasTier.conditional,
    'path_node_u5_n49_kawruh_luhur': LegacyAliasTier.safe,
    'path_node_u5_n49_tantangan_budaya': LegacyAliasTier.safe,
  };

  /// Returns the pedagogical tier classification of [legacyActivityId], or null if unmapped.
  static LegacyAliasTier? getAliasTier(String legacyActivityId) {
    return legacyAliasTiers[legacyActivityId];
  }

  /// Whether [activityId] has achieved canonical mastery:
  /// - Directly present in [clearedActivities], OR
  /// - A SAFE legacy alias mapped to [activityId] is present in [clearedActivities].
  ///
  /// CONDITIONAL and UNSAFE aliases do NOT confer canonical mastery.
  static bool hasCanonicalMastery(String activityId, Set<String> clearedActivities) {
    final canonicalId = resolveCanonicalActivityId(activityId);
    if (clearedActivities.contains(canonicalId)) return true;
    for (final entry in legacyActivityAliases.entries) {
      if (entry.value == canonicalId && clearedActivities.contains(entry.key)) {
        final tier = legacyAliasTiers[entry.key] ?? LegacyAliasTier.safe;
        if (tier == LegacyAliasTier.safe) {
          return true;
        }
      }
    }
    return false;
  }

  /// Whether [activityId] has any historical completion (safe, conditional, or unsafe)
  /// in [clearedActivities], used to prevent duplicate first-clear XP and support progression.
  static bool hasHistoricalCompletion(String activityId, Set<String> clearedActivities) {
    final canonicalId = resolveCanonicalActivityId(activityId);
    if (clearedActivities.contains(canonicalId)) return true;
    if (clearedActivities.contains(activityId)) return true;
    for (final entry in legacyActivityAliases.entries) {
      if (entry.value == canonicalId && clearedActivities.contains(entry.key)) {
        return true;
      }
    }
    return false;
  }

  /// Resolves any activity ID (whether canonical or historical legacy alias)
  /// to its authoritative canonical activity ID.
  static String resolveCanonicalActivityId(String activityId) {
    return legacyActivityAliases[activityId] ?? activityId;
  }

  /// Returns the node matching canonical activity [id] or legacy alias, or `null`.
  static QuizPathNode? getNodeById(String id) {
    final canonicalId = resolveCanonicalActivityId(id);
    return _nodeById[canonicalId];
  }

  /// Resolves the 5 units and 50 nodes dynamically based on active user progression.
  ///
  /// Enforces:
  /// 1. Node 1 is open by default for new users.
  /// 2. Completing Node N unlocks Node N+1.
  /// 3. Only one uncompleted regular node is [NodeStatus.current] at a time.
  /// 4. Unit evaluation gates (Node 10, 20, 30, 40, 50) require score >= 70% to pass.
  /// 5. Subsequent units remain locked until the previous unit's evaluation is passed.
  /// 6. SAFE aliases confer canonical mastery; CONDITIONAL/UNSAFE require canonical completion.
  /// 7. Historical completion prevents progression deadlocks without granting premature mastery.
  static List<QuizUnitData> resolveCurriculum({
    required Set<String> clearedActivities,
    bool Function(String id)? isEvaluationPassed,
  }) {
    final baseNodes = allNodes;
    final resolvedNodes = <QuizPathNode>[];
    bool hasFoundCurrent = false;

    for (int i = 0; i < baseNodes.length; i++) {
      final baseNode = baseNodes[i];
      final isEval = baseNode.type == QuizNodeType.milestone ||
          baseNode.type == QuizNodeType.finalExam ||
          baseNode.topicKey.startsWith('evaluasi_');

      final bool isCleared;
      if (isEval) {
        if (isEvaluationPassed != null) {
          isCleared = isEvaluationPassed(baseNode.id);
        } else {
          isCleared =
              clearedActivities.contains('eval_passed:${baseNode.id}') ||
              clearedActivities.contains(baseNode.id);
        }
      } else {
        isCleared = hasCanonicalMastery(baseNode.id, clearedActivities);
      }

      NodeStatus status;
      if (isCleared) {
        status = NodeStatus.completed;
      } else {
        bool prereqMet = false;
        if (i == 0) {
          prereqMet = true;
        } else {
          final prevNodeResolved = resolvedNodes[i - 1];
          final prevBaseNode = baseNodes[i - 1];
          final prevCompleted = prevNodeResolved.status == NodeStatus.completed;
          final prevHistorical = hasHistoricalCompletion(prevBaseNode.id, clearedActivities);
          if (prevCompleted || prevHistorical) {
            prereqMet = true;
          }
        }

        if (prereqMet && !hasFoundCurrent) {
          status = NodeStatus.current;
          hasFoundCurrent = true;
        } else {
          status = NodeStatus.locked;
        }
      }

      resolvedNodes.add(baseNode.copyWith(status: status));
    }

    final resolvedUnits = <QuizUnitData>[];
    for (int u = 0; u < units.length; u++) {
      final baseUnit = units[u];
      final unitNodes = resolvedNodes.sublist(u * 10, (u + 1) * 10);

      final bool isUnitLocked;
      if (u == 0) {
        isUnitLocked = false;
      } else {
        final prevUnitEvalNode = resolvedNodes[u * 10 - 1];
        final bool prevEvalPassed = isEvaluationPassed != null
            ? isEvaluationPassed(prevUnitEvalNode.id)
            : (clearedActivities.contains('eval_passed:${prevUnitEvalNode.id}') ||
                clearedActivities.contains(prevUnitEvalNode.id));
        isUnitLocked = prevUnitEvalNode.status != NodeStatus.completed && !prevEvalPassed;
      }

      resolvedUnits.add(
        QuizUnitData(
          unitId: baseUnit.unitId,
          nodes: unitNodes,
          isLocked: isUnitLocked,
        ),
      );
    }

    return resolvedUnits;
  }
}
