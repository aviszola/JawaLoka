import '../../../data/translation_entries.dart';
import '../domain/translation_models.dart';

/// Implementasi luring berbasis kamus terstruktur untuk TranslationService.
///
/// Strategi pencocokan:
/// 1. Exact match — seluruh teks cocok dengan satu entri kamus atau partikel.
/// 2. Phrase-first token matching — teks dibagi token per token dengan
///    longest-match-first: kandidat frasa terpanjang diperiksa dahulu sebelum
///    mundur ke kata tunggal.
/// 3. Morphological & Affix Handling — mendeteksi awalan/akhiran produktif
///    bahasa Jawa (seperti klitika posesif -ku/-mu/-e/-ipun, awalan tak-/kok-/di-)
///    dan bahasa Indonesia (di-, me-, -ku, -mu, -nya).
/// 4. Grammatical Particles & Conjunctions — mengenali partikel umum
///    (dan, atau, tetapi, di, ke, dari, dll.) tanpa mengotori dataset inti.
/// 5. Kata yang tidak ditemukan dipertahankan apa adanya dengan penanda [?]
///    sehingga pengguna tetap dapat membaca hasil tanpa kehilangan konteks.
///
/// Desain const-safe: class ini mempertahankan `const` constructor agar tetap
/// kompatibel dengan kode pemanggil yang menggunakan `const OfflineDictionaryService()`.
class OfflineDictionaryService implements TranslationService {
  final List<TranslationEntry> entries;

  const OfflineDictionaryService({this.entries = kTranslationEntries});

  // ─── Normalisasi ─────────────────────────────────────────────────────────

  /// Normalisasi masukan teks:
  /// - trim spasi awal/akhir
  /// - huruf kecil (case-insensitive matching)
  /// - rapatkan spasi ganda menjadi spasi tunggal
  /// - buang tanda baca di ujung (. , ! ? ; :)
  static String normalize(String input) {
    var s = input.trim().toLowerCase();
    s = s.replaceAll(RegExp(r'\s+'), ' ');
    s = s.replaceAll(RegExp(r'[\.,!\?;:]+$'), '').trim();
    return s;
  }

  // ─── Partikel & Kata Hubung Baku ──────────────────────────────────────────

  /// Peta partikel dan kata tugas fungsional yang lazim dalam kalimat sehari-hari.
  /// Ini memisahkan struktur gramatikal dari kamus leksikal 239 entri inti.
  static const Map<String, Map<TranslationVariant, String>> _kFunctionalGrammar = {
    'dan': {
      TranslationVariant.id: 'dan',
      TranslationVariant.en: 'and',
      TranslationVariant.jvNgoko: 'lan',
      TranslationVariant.jvKrama: 'kaliyan',
    },
    'lan': {
      TranslationVariant.id: 'dan',
      TranslationVariant.en: 'and',
      TranslationVariant.jvNgoko: 'lan',
      TranslationVariant.jvKrama: 'kaliyan',
    },
    'kaliyan': {
      TranslationVariant.id: 'dan',
      TranslationVariant.en: 'and',
      TranslationVariant.jvNgoko: 'lan',
      TranslationVariant.jvKrama: 'kaliyan',
    },
    'atau': {
      TranslationVariant.id: 'atau',
      TranslationVariant.en: 'or',
      TranslationVariant.jvNgoko: 'utawa',
      TranslationVariant.jvKrama: 'utawi',
    },
    'utawa': {
      TranslationVariant.id: 'atau',
      TranslationVariant.en: 'or',
      TranslationVariant.jvNgoko: 'utawa',
      TranslationVariant.jvKrama: 'utawi',
    },
    'utawi': {
      TranslationVariant.id: 'atau',
      TranslationVariant.en: 'or',
      TranslationVariant.jvNgoko: 'utawa',
      TranslationVariant.jvKrama: 'utawi',
    },
    'tetapi': {
      TranslationVariant.id: 'tetapi',
      TranslationVariant.en: 'but',
      TranslationVariant.jvNgoko: 'nanging',
      TranslationVariant.jvKrama: 'ananging',
    },
    'tapi': {
      TranslationVariant.id: 'tetapi',
      TranslationVariant.en: 'but',
      TranslationVariant.jvNgoko: 'nanging',
      TranslationVariant.jvKrama: 'ananging',
    },
    'nanging': {
      TranslationVariant.id: 'tetapi',
      TranslationVariant.en: 'but',
      TranslationVariant.jvNgoko: 'nanging',
      TranslationVariant.jvKrama: 'ananging',
    },
    'ananging': {
      TranslationVariant.id: 'tetapi',
      TranslationVariant.en: 'but',
      TranslationVariant.jvNgoko: 'nanging',
      TranslationVariant.jvKrama: 'ananging',
    },
    'karena': {
      TranslationVariant.id: 'karena',
      TranslationVariant.en: 'because',
      TranslationVariant.jvNgoko: 'amarga',
      TranslationVariant.jvKrama: 'amargi',
    },
    'amarga': {
      TranslationVariant.id: 'karena',
      TranslationVariant.en: 'because',
      TranslationVariant.jvNgoko: 'amarga',
      TranslationVariant.jvKrama: 'amargi',
    },
    'amargi': {
      TranslationVariant.id: 'karena',
      TranslationVariant.en: 'because',
      TranslationVariant.jvNgoko: 'amarga',
      TranslationVariant.jvKrama: 'amargi',
    },
    'di': {
      TranslationVariant.id: 'di',
      TranslationVariant.en: 'at',
      TranslationVariant.jvNgoko: 'neng',
      TranslationVariant.jvKrama: 'wonten',
    },
    'neng': {
      TranslationVariant.id: 'di',
      TranslationVariant.en: 'at',
      TranslationVariant.jvNgoko: 'neng',
      TranslationVariant.jvKrama: 'wonten',
    },
    'wonten': {
      TranslationVariant.id: 'di',
      TranslationVariant.en: 'at',
      TranslationVariant.jvNgoko: 'neng',
      TranslationVariant.jvKrama: 'wonten',
    },
    'ke': {
      TranslationVariant.id: 'ke',
      TranslationVariant.en: 'to',
      TranslationVariant.jvNgoko: 'menyang',
      TranslationVariant.jvKrama: 'dhateng',
    },
    'menyang': {
      TranslationVariant.id: 'ke',
      TranslationVariant.en: 'to',
      TranslationVariant.jvNgoko: 'menyang',
      TranslationVariant.jvKrama: 'dhateng',
    },
    'dhateng': {
      TranslationVariant.id: 'ke',
      TranslationVariant.en: 'to',
      TranslationVariant.jvNgoko: 'menyang',
      TranslationVariant.jvKrama: 'dhateng',
    },
    'dari': {
      TranslationVariant.id: 'dari',
      TranslationVariant.en: 'from',
      TranslationVariant.jvNgoko: 'saka',
      TranslationVariant.jvKrama: 'saking',
    },
    'saka': {
      TranslationVariant.id: 'dari',
      TranslationVariant.en: 'from',
      TranslationVariant.jvNgoko: 'saka',
      TranslationVariant.jvKrama: 'saking',
    },
    'saking': {
      TranslationVariant.id: 'dari',
      TranslationVariant.en: 'from',
      TranslationVariant.jvNgoko: 'saka',
      TranslationVariant.jvKrama: 'saking',
    },
    'dengan': {
      TranslationVariant.id: 'dengan',
      TranslationVariant.en: 'with',
      TranslationVariant.jvNgoko: 'karo',
      TranslationVariant.jvKrama: 'kaliyan',
    },
    'karo': {
      TranslationVariant.id: 'dengan',
      TranslationVariant.en: 'with',
      TranslationVariant.jvNgoko: 'karo',
      TranslationVariant.jvKrama: 'kaliyan',
    },
    'dan juga': {
      TranslationVariant.id: 'dan juga',
      TranslationVariant.en: 'and also',
      TranslationVariant.jvNgoko: 'lan uga',
      TranslationVariant.jvKrama: 'kaliyan ugi',
    },
    'juga': {
      TranslationVariant.id: 'juga',
      TranslationVariant.en: 'also',
      TranslationVariant.jvNgoko: 'uga',
      TranslationVariant.jvKrama: 'ugi',
    },
    'uga': {
      TranslationVariant.id: 'juga',
      TranslationVariant.en: 'also',
      TranslationVariant.jvNgoko: 'uga',
      TranslationVariant.jvKrama: 'ugi',
    },
    'ugi': {
      TranslationVariant.id: 'juga',
      TranslationVariant.en: 'also',
      TranslationVariant.jvNgoko: 'uga',
      TranslationVariant.jvKrama: 'ugi',
    },
  };

  // ─── Lookup & Index Cache ─────────────────────────────────────────────────

  static final Map<
    List<TranslationEntry>,
    Map<TranslationVariant, Map<String, Map<TranslationVariant, String>>>
  > _instanceCache = {};

  Map<TranslationVariant, Map<String, Map<TranslationVariant, String>>>
      _buildOrGetIndex() {
    if (_instanceCache.containsKey(entries)) {
      return _instanceCache[entries]!;
    }
    final index =
        <TranslationVariant, Map<String, Map<TranslationVariant, String>>>{};
    for (final from in TranslationVariant.values) {
      index[from] = {};
      for (final entry in entries) {
        final key = normalize(entry.getVariant(from));
        if (key.isEmpty) continue;
        index[from]![key] ??= {};
        for (final to in TranslationVariant.values) {
          index[from]![key]![to] = entry.getVariant(to);
        }
      }
    }
    _instanceCache[entries] = index;
    return index;
  }

  /// Mencari satu frasa [phrase] di index untuk arah [from]→[to].
  /// Mengembalikan teks target atau null jika tidak ditemukan.
  String? _lookup(
    String phrase,
    TranslationVariant from,
    TranslationVariant to,
  ) {
    // 1. Cek index kamus utama
    final index = _buildOrGetIndex();
    final mainResult = index[from]?[phrase]?[to];
    if (mainResult != null) return mainResult;

    // 2. Cek kamus partikel gramatikal
    final functional = _kFunctionalGrammar[phrase];
    if (functional != null && functional.containsKey(to)) {
      return functional[to];
    }

    return null;
  }

  // ─── Penanganan Morfologi & Imbuhan Terkendali ─────────────────────────────

  /// Mencoba menerjemahkan kata berimbuhan [token] berdasarkan aturan morfologi
  /// Jawa dan Indonesia yang valid dan terverifikasi leksikonnya.
  String? _tryMorphology(String token, TranslationVariant from, TranslationVariant to) {
    if (token.length <= 3) return null;

    // A. Klitika posesif bahasa Jawa:
    //    -ku (omahku -> omah + ku), -mu (omahmu -> omah + mu),
    //    -e (omahe -> omah + e), -ipun (griyaipun -> griya + ipun)
    if (from == TranslationVariant.jvNgoko || from == TranslationVariant.jvKrama) {
      // 1. -ku
      if (token.endsWith('ku') && token.length > 4) {
        final base = token.substring(0, token.length - 2);
        final baseTrans = _lookup(base, from, to);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-ku';
          if (to == TranslationVariant.en) return 'my $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-ku';
          if (to == TranslationVariant.jvKrama) return '$baseTrans kula';
        }
      }
      // 2. -mu
      if (token.endsWith('mu') && token.length > 4) {
        final base = token.substring(0, token.length - 2);
        final baseTrans = _lookup(base, from, to);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-mu';
          if (to == TranslationVariant.en) return 'your $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-mu';
          if (to == TranslationVariant.jvKrama) return '$baseTrans panjenengan';
        }
      }
      // 3. -ipun (Krama)
      if (token.endsWith('ipun') && token.length > 6) {
        final base = token.substring(0, token.length - 4);
        final baseTrans = _lookup(base, from, to);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-nya';
          if (to == TranslationVariant.en) return 'the $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-e';
          if (to == TranslationVariant.jvKrama) return '$baseTrans-ipun';
        }
      }
      // 4. -e (Ngoko)
      if (token.endsWith('e') && token.length > 3) {
        final base = token.substring(0, token.length - 1);
        final baseTrans = _lookup(base, from, to);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-nya';
          if (to == TranslationVariant.en) return 'the $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-e';
          if (to == TranslationVariant.jvKrama) return '$baseTrans-ipun';
        }
      }
      // 5. Awalan pasif Jawa: di- (dituku, dipangan, diserat)
      if (token.startsWith('di') && token.length > 4) {
        final base = token.substring(2);
        final baseTrans = _lookup(base, from, to);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return 'di$baseTrans';
          if (to == TranslationVariant.jvNgoko) return 'di$baseTrans';
          if (to == TranslationVariant.jvKrama) return 'dipun$baseTrans';
        }
      }
    }

    // B. Imbuhan bahasa Indonesia:
    //    -ku, -mu, -nya, di-
    if (from == TranslationVariant.id) {
      // 1. -ku
      if (token.endsWith('ku') && token.length > 4) {
        final base = token.substring(0, token.length - 2);
        final baseTrans = _lookup(base, from, to);
        if (baseTrans != null) {
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-ku';
          if (to == TranslationVariant.jvKrama) return '$baseTrans kula';
          if (to == TranslationVariant.en) return 'my $baseTrans';
        }
      }
      // 2. -mu
      if (token.endsWith('mu') && token.length > 4) {
        final base = token.substring(0, token.length - 2);
        final baseTrans = _lookup(base, from, to);
        if (baseTrans != null) {
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-mu';
          if (to == TranslationVariant.jvKrama) return '$baseTrans panjenengan';
          if (to == TranslationVariant.en) return 'your $baseTrans';
        }
      }
      // 3. -nya
      if (token.endsWith('nya') && token.length > 5) {
        final base = token.substring(0, token.length - 3);
        final baseTrans = _lookup(base, from, to);
        if (baseTrans != null) {
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-e';
          if (to == TranslationVariant.jvKrama) return '$baseTrans-ipun';
          if (to == TranslationVariant.en) return 'the $baseTrans';
        }
      }
      // 4. Awalan pasif di-
      if (token.startsWith('di') && token.length > 4) {
        final base = token.substring(2);
        // Coba cari dasar langsung (misal: 'makan') atau bentuk me- (misal: 'beli' -> 'membeli')
        String? baseTrans = _lookup(base, from, to);
        if (baseTrans == null) {
          // Hubungkan morfem 'beli' -> 'membeli', 'jual' -> 'menjual', 'tulis' -> 'menulis', 'baca' -> 'membaca'
          final activeCandidate = switch (base[0]) {
            'b' || 'p' => 'mem$base',
            't' || 'd' => 'men$base',
            'c' || 'j' || 's' => 'meny$base',
            _ => 'meng$base',
          };
          baseTrans = _lookup(activeCandidate, from, to);
        }
        if (baseTrans != null) {
          if (to == TranslationVariant.jvNgoko) return 'di$baseTrans';
          if (to == TranslationVariant.jvKrama) return 'dipun$baseTrans';
          if (to == TranslationVariant.en) return 'be $baseTrans';
        }
      }
    }

    return null;
  }

  // ─── Token-level longest-match-first ─────────────────────────────────────

  /// Memecah [normalizedInput] menjadi token kata, lalu menggabungkan hasil
  /// terjemahan per token dengan strategi longest-match-first dan penanganan
  /// partikel serta morfologi terkontrol.
  TranslationResult _translateByTokens(
    String normalizedInput,
    TranslationVariant from,
    TranslationVariant to,
  ) {
    final tokens = normalizedInput.split(' ');
    final buffer = StringBuffer();
    bool anyFound = false;
    int i = 0;

    while (i < tokens.length) {
      bool matched = false;

      // 1. Coba frasa dari panjang maksimum mundur ke satu token
      for (int len = tokens.length - i; len >= 1; len--) {
        final phrase = tokens.sublist(i, i + len).join(' ');
        final target = _lookup(phrase, from, to);
        if (target != null) {
          if (buffer.isNotEmpty) buffer.write(' ');
          buffer.write(target);
          anyFound = true;
          i += len;
          matched = true;
          break;
        }
      }

      // 2. Jika token tunggal belum cocok leksikal, uji aturan morfologi
      if (!matched) {
        final currentToken = tokens[i];
        final morphTarget = _tryMorphology(currentToken, from, to);
        if (morphTarget != null) {
          if (buffer.isNotEmpty) buffer.write(' ');
          buffer.write(morphTarget);
          anyFound = true;
          i++;
          matched = true;
        }
      }

      // 3. Fallback: kata tidak dikenal dipertahankan dengan penanda [?]
      if (!matched) {
        if (buffer.isNotEmpty) buffer.write(' ');
        buffer.write('${tokens[i]}[?]');
        i++;
      }
    }

    if (!anyFound) {
      return const NotFound();
    }
    return Found(buffer.toString());
  }

  // ─── TranslationService API ───────────────────────────────────────────────

  @override
  Future<TranslationResult> translate({
    required String text,
    required TranslationVariant from,
    required TranslationVariant to,
  }) async {
    final normalizedInput = normalize(text);
    if (normalizedInput.isEmpty) {
      return const NotFound();
    }

    // Jika varian bahasa asal dan tujuan sama persis, kembalikan apa adanya
    if (from == to) {
      return Found(text);
    }

    // 1. Exact match seluruh teks (paling presisi)
    final exactTarget = _lookup(normalizedInput, from, to);
    if (exactTarget != null) {
      return Found(exactTarget);
    }

    // 2. Phrase-first token matching (longest-match-first per token)
    return _translateByTokens(normalizedInput, from, to);
  }

  @override
  List<String> examples(TranslationVariant from, {int max = 4}) {
    if (max <= 0) return const [];
    return entries.take(max).map((e) => e.getVariant(from)).toList();
  }
}
