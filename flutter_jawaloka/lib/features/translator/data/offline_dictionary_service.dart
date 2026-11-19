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

  const OfflineDictionaryService({this.entries = kAllTranslationEntries});

  // ─── Normalisasi ─────────────────────────────────────────────────────────

  /// Normalisasi masukan teks:
  /// - trim spasi awal/akhir
  /// - huruf kecil (case-insensitive matching)
  /// - buang tanda baca pengganggu (. , ! ? ; :) di ujung maupun pemisah klausa
  /// - rapatkan spasi ganda menjadi spasi tunggal
  static String normalize(String input) {
    var s = input.trim().toLowerCase();
    s = s.replaceAll(RegExp(r'[\.,!\?;:]+'), ' ');
    s = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return s;
  }

  // ─── Partikel & Kata Hubung Baku ──────────────────────────────────────────

  /// Peta partikel dan kata tugas fungsional yang lazim dalam kalimat sehari-hari.
  /// Ini memisahkan struktur gramatikal dari kamus leksikal 239 entri inti.
  static const Map<String, Map<TranslationVariant, String>>
  _kFunctionalGrammar = {
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
    'ing': {
      TranslationVariant.id: 'di',
      TranslationVariant.en: 'at',
      TranslationVariant.jvNgoko: 'ing',
      TranslationVariant.jvKrama: 'wonten ing',
    },
    'yang': {
      TranslationVariant.id: 'yang',
      TranslationVariant.en: 'that',
      TranslationVariant.jvNgoko: 'sing',
      TranslationVariant.jvKrama: 'ingkang',
    },
    'sing': {
      TranslationVariant.id: 'yang',
      TranslationVariant.en: 'that',
      TranslationVariant.jvNgoko: 'sing',
      TranslationVariant.jvKrama: 'ingkang',
    },
    'ingkang': {
      TranslationVariant.id: 'yang',
      TranslationVariant.en: 'that',
      TranslationVariant.jvNgoko: 'sing',
      TranslationVariant.jvKrama: 'ingkang',
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
    'jangan': {
      TranslationVariant.id: 'jangan',
      TranslationVariant.en: 'do not',
      TranslationVariant.jvNgoko: 'aja',
      TranslationVariant.jvKrama: 'sampun',
    },
    'aja': {
      TranslationVariant.id: 'jangan',
      TranslationVariant.en: 'do not',
      TranslationVariant.jvNgoko: 'aja',
      TranslationVariant.jvKrama: 'sampun',
    },
    'silakan': {
      TranslationVariant.id: 'silakan',
      TranslationVariant.en: 'please',
      TranslationVariant.jvNgoko: 'mangga',
      TranslationVariant.jvKrama: 'sumangga',
    },
    'sumangga': {
      TranslationVariant.id: 'silakan',
      TranslationVariant.en: 'please',
      TranslationVariant.jvNgoko: 'mangga',
      TranslationVariant.jvKrama: 'sumangga',
    },
    'apakah': {
      TranslationVariant.id: 'apakah',
      TranslationVariant.en: 'whether',
      TranslationVariant.jvNgoko: 'apa',
      TranslationVariant.jvKrama: 'punapa',
    },
    'punapa': {
      TranslationVariant.id: 'apakah',
      TranslationVariant.en: 'whether',
      TranslationVariant.jvNgoko: 'apa',
      TranslationVariant.jvKrama: 'punapa',
    },
    'sedang': {
      TranslationVariant.id: 'sedang',
      TranslationVariant.en: 'currently',
      TranslationVariant.jvNgoko: 'lagi',
      TranslationVariant.jvKrama: 'nembe',
    },
    'lagi': {
      TranslationVariant.id: 'sedang',
      TranslationVariant.en: 'currently',
      TranslationVariant.jvNgoko: 'lagi',
      TranslationVariant.jvKrama: 'nembe',
    },
    'nembe': {
      TranslationVariant.id: 'sedang',
      TranslationVariant.en: 'currently',
      TranslationVariant.jvNgoko: 'lagi',
      TranslationVariant.jvKrama: 'nembe',
    },
    'belum': {
      TranslationVariant.id: 'belum',
      TranslationVariant.en: 'not yet',
      TranslationVariant.jvNgoko: 'durung',
      TranslationVariant.jvKrama: 'dereng',
    },
    'durung': {
      TranslationVariant.id: 'belum',
      TranslationVariant.en: 'not yet',
      TranslationVariant.jvNgoko: 'durung',
      TranslationVariant.jvKrama: 'dereng',
    },
    'dereng': {
      TranslationVariant.id: 'belum',
      TranslationVariant.en: 'not yet',
      TranslationVariant.jvNgoko: 'durung',
      TranslationVariant.jvKrama: 'dereng',
    },
    'harus': {
      TranslationVariant.id: 'harus',
      TranslationVariant.en: 'must',
      TranslationVariant.jvNgoko: 'kudu',
      TranslationVariant.jvKrama: 'kedah',
    },
    'kudu': {
      TranslationVariant.id: 'harus',
      TranslationVariant.en: 'must',
      TranslationVariant.jvNgoko: 'kudu',
      TranslationVariant.jvKrama: 'kedah',
    },
    'kedah': {
      TranslationVariant.id: 'harus',
      TranslationVariant.en: 'must',
      TranslationVariant.jvNgoko: 'kudu',
      TranslationVariant.jvKrama: 'kedah',
    },
    'di mana': {
      TranslationVariant.id: 'di mana',
      TranslationVariant.en: 'where',
      TranslationVariant.jvNgoko: 'neng ngendi',
      TranslationVariant.jvKrama: 'wonten pundi',
    },
    'ke mana': {
      TranslationVariant.id: 'ke mana',
      TranslationVariant.en: 'where to',
      TranslationVariant.jvNgoko: 'menyang ngendi',
      TranslationVariant.jvKrama: 'dhateng pundi',
    },
    'dari mana': {
      TranslationVariant.id: 'dari mana',
      TranslationVariant.en: 'where from',
      TranslationVariant.jvNgoko: 'saka ngendi',
      TranslationVariant.jvKrama: 'saking pundi',
    },
    'kepada': {
      TranslationVariant.id: 'kepada',
      TranslationVariant.en: 'to',
      TranslationVariant.jvNgoko: 'marang',
      TranslationVariant.jvKrama: 'dhateng',
    },
    'marang': {
      TranslationVariant.id: 'kepada',
      TranslationVariant.en: 'to',
      TranslationVariant.jvNgoko: 'marang',
      TranslationVariant.jvKrama: 'dhateng',
    },
    'untuk': {
      TranslationVariant.id: 'untuk',
      TranslationVariant.en: 'for',
      TranslationVariant.jvNgoko: 'kanggo',
      TranslationVariant.jvKrama: 'kangge',
    },
    'kanggo': {
      TranslationVariant.id: 'untuk',
      TranslationVariant.en: 'for',
      TranslationVariant.jvNgoko: 'kanggo',
      TranslationVariant.jvKrama: 'kangge',
    },
    'kangge': {
      TranslationVariant.id: 'untuk',
      TranslationVariant.en: 'for',
      TranslationVariant.jvNgoko: 'kanggo',
      TranslationVariant.jvKrama: 'kangge',
    },
    'ketika': {
      TranslationVariant.id: 'ketika',
      TranslationVariant.en: 'when',
      TranslationVariant.jvNgoko: 'nalika',
      TranslationVariant.jvKrama: 'nalika',
    },
    'saat': {
      TranslationVariant.id: 'saat',
      TranslationVariant.en: 'when',
      TranslationVariant.jvNgoko: 'nalika',
      TranslationVariant.jvKrama: 'nalika',
    },
    'jika': {
      TranslationVariant.id: 'jika',
      TranslationVariant.en: 'if',
      TranslationVariant.jvNgoko: 'yen',
      TranslationVariant.jvKrama: 'menawi',
    },
    'kalau': {
      TranslationVariant.id: 'kalau',
      TranslationVariant.en: 'if',
      TranslationVariant.jvNgoko: 'yen',
      TranslationVariant.jvKrama: 'menawi',
    },
    'yen': {
      TranslationVariant.id: 'jika',
      TranslationVariant.en: 'if',
      TranslationVariant.jvNgoko: 'yen',
      TranslationVariant.jvKrama: 'menawi',
    },
    'menawi': {
      TranslationVariant.id: 'jika',
      TranslationVariant.en: 'if',
      TranslationVariant.jvNgoko: 'yen',
      TranslationVariant.jvKrama: 'menawi',
    },
    'meskipun': {
      TranslationVariant.id: 'meskipun',
      TranslationVariant.en: 'although',
      TranslationVariant.jvNgoko: 'sanajan',
      TranslationVariant.jvKrama: 'sanadyan',
    },
    'walaupun': {
      TranslationVariant.id: 'walaupun',
      TranslationVariant.en: 'although',
      TranslationVariant.jvNgoko: 'sanajan',
      TranslationVariant.jvKrama: 'sanadyan',
    },
    'agar': {
      TranslationVariant.id: 'agar',
      TranslationVariant.en: 'so that',
      TranslationVariant.jvNgoko: 'supaya',
      TranslationVariant.jvKrama: 'supados',
    },
    'supaya': {
      TranslationVariant.id: 'supaya',
      TranslationVariant.en: 'so that',
      TranslationVariant.jvNgoko: 'supaya',
      TranslationVariant.jvKrama: 'supados',
    },
    'sambil': {
      TranslationVariant.id: 'sambil',
      TranslationVariant.en: 'while',
      TranslationVariant.jvNgoko: 'karo',
      TranslationVariant.jvKrama: 'sinambi',
    },
    'mari': {
      TranslationVariant.id: 'mari',
      TranslationVariant.en: 'let us',
      TranslationVariant.jvNgoko: 'ayo',
      TranslationVariant.jvKrama: 'mangga',
    },
    'masih': {
      TranslationVariant.id: 'masih',
      TranslationVariant.en: 'still',
      TranslationVariant.jvNgoko: 'isih',
      TranslationVariant.jvKrama: 'taksih',
    },
    'setiap': {
      TranslationVariant.id: 'setiap',
      TranslationVariant.en: 'every',
      TranslationVariant.jvNgoko: 'saben',
      TranslationVariant.jvKrama: 'saben',
    },
    'tiap': {
      TranslationVariant.id: 'tiap',
      TranslationVariant.en: 'every',
      TranslationVariant.jvNgoko: 'saben',
      TranslationVariant.jvKrama: 'saben',
    },
    // ─── Entri Gramatikal Fungsional Bahasa Inggris ─────────────────────────
    'and': {
      TranslationVariant.id: 'dan',
      TranslationVariant.en: 'and',
      TranslationVariant.jvNgoko: 'lan',
      TranslationVariant.jvKrama: 'kaliyan',
    },
    'or': {
      TranslationVariant.id: 'atau',
      TranslationVariant.en: 'or',
      TranslationVariant.jvNgoko: 'utawa',
      TranslationVariant.jvKrama: 'utawi',
    },
    'but': {
      TranslationVariant.id: 'tetapi',
      TranslationVariant.en: 'but',
      TranslationVariant.jvNgoko: 'nanging',
      TranslationVariant.jvKrama: 'ananging',
    },
    'because': {
      TranslationVariant.id: 'karena',
      TranslationVariant.en: 'because',
      TranslationVariant.jvNgoko: 'amarga',
      TranslationVariant.jvKrama: 'amargi',
    },
    'in': {
      TranslationVariant.id: 'di',
      TranslationVariant.en: 'in',
      TranslationVariant.jvNgoko: 'neng',
      TranslationVariant.jvKrama: 'wonten',
    },
    'at': {
      TranslationVariant.id: 'di',
      TranslationVariant.en: 'at',
      TranslationVariant.jvNgoko: 'neng',
      TranslationVariant.jvKrama: 'wonten',
    },
    'on': {
      TranslationVariant.id: 'di',
      TranslationVariant.en: 'on',
      TranslationVariant.jvNgoko: 'neng',
      TranslationVariant.jvKrama: 'wonten',
    },
    'to': {
      TranslationVariant.id: 'ke',
      TranslationVariant.en: 'to',
      TranslationVariant.jvNgoko: 'menyang',
      TranslationVariant.jvKrama: 'dhateng',
    },
    'from': {
      TranslationVariant.id: 'dari',
      TranslationVariant.en: 'from',
      TranslationVariant.jvNgoko: 'saka',
      TranslationVariant.jvKrama: 'saking',
    },
    'with': {
      TranslationVariant.id: 'dengan',
      TranslationVariant.en: 'with',
      TranslationVariant.jvNgoko: 'karo',
      TranslationVariant.jvKrama: 'kaliyan',
    },
    'and also': {
      TranslationVariant.id: 'dan juga',
      TranslationVariant.en: 'and also',
      TranslationVariant.jvNgoko: 'lan uga',
      TranslationVariant.jvKrama: 'kaliyan ugi',
    },
    'also': {
      TranslationVariant.id: 'juga',
      TranslationVariant.en: 'also',
      TranslationVariant.jvNgoko: 'uga',
      TranslationVariant.jvKrama: 'ugi',
    },
    'do not': {
      TranslationVariant.id: 'jangan',
      TranslationVariant.en: 'do not',
      TranslationVariant.jvNgoko: 'aja',
      TranslationVariant.jvKrama: 'sampun',
    },
    'dont': {
      TranslationVariant.id: 'jangan',
      TranslationVariant.en: 'do not',
      TranslationVariant.jvNgoko: 'aja',
      TranslationVariant.jvKrama: 'sampun',
    },
    "don't": {
      TranslationVariant.id: 'jangan',
      TranslationVariant.en: 'do not',
      TranslationVariant.jvNgoko: 'aja',
      TranslationVariant.jvKrama: 'sampun',
    },
    'not': {
      TranslationVariant.id: 'tidak',
      TranslationVariant.en: 'not',
      TranslationVariant.jvNgoko: 'ora',
      TranslationVariant.jvKrama: 'mboten',
    },
    'have to': {
      TranslationVariant.id: 'harus',
      TranslationVariant.en: 'have to',
      TranslationVariant.jvNgoko: 'kudu',
      TranslationVariant.jvKrama: 'kedah',
    },
    'where to': {
      TranslationVariant.id: 'ke mana',
      TranslationVariant.en: 'where to',
      TranslationVariant.jvNgoko: 'menyang ngendi',
      TranslationVariant.jvKrama: 'dhateng pundi',
    },
    'where from': {
      TranslationVariant.id: 'dari mana',
      TranslationVariant.en: 'where from',
      TranslationVariant.jvNgoko: 'saka ngendi',
      TranslationVariant.jvKrama: 'saking pundi',
    },
    'even though': {
      TranslationVariant.id: 'meskipun',
      TranslationVariant.en: 'even though',
      TranslationVariant.jvNgoko: 'sanajan',
      TranslationVariant.jvKrama: 'sanadyan',
    },
    'in order to': {
      TranslationVariant.id: 'agar',
      TranslationVariant.en: 'in order to',
      TranslationVariant.jvNgoko: 'supaya',
      TranslationVariant.jvKrama: 'supados',
    },
    'while': {
      TranslationVariant.id: 'sambil',
      TranslationVariant.en: 'while',
      TranslationVariant.jvNgoko: 'karo',
      TranslationVariant.jvKrama: 'sinambi',
    },
    'let us': {
      TranslationVariant.id: 'mari',
      TranslationVariant.en: 'let us',
      TranslationVariant.jvNgoko: 'ayo',
      TranslationVariant.jvKrama: 'mangga',
    },
    "let's": {
      TranslationVariant.id: 'mari',
      TranslationVariant.en: "let's",
      TranslationVariant.jvNgoko: 'ayo',
      TranslationVariant.jvKrama: 'mangga',
    },
    'every': {
      TranslationVariant.id: 'setiap',
      TranslationVariant.en: 'every',
      TranslationVariant.jvNgoko: 'saben',
      TranslationVariant.jvKrama: 'saben',
    },
    'very much': {
      TranslationVariant.id: 'sangat',
      TranslationVariant.en: 'very much',
      TranslationVariant.jvNgoko: 'banget',
      TranslationVariant.jvKrama: 'sanget',
    },
    'want to': {
      TranslationVariant.id: 'mau',
      TranslationVariant.en: 'want to',
      TranslationVariant.jvNgoko: 'gelem',
      TranslationVariant.jvKrama: 'purun',
    },
    'what is your name': {
      TranslationVariant.id: 'siapa namamu',
      TranslationVariant.en: 'what is your name',
      TranslationVariant.jvNgoko: 'sapa jenengmu',
      TranslationVariant.jvKrama: 'sinten asmanipun',
    },
    'terima kasih banyak': {
      TranslationVariant.id: 'terima kasih banyak',
      TranslationVariant.en: 'thank you very much',
      TranslationVariant.jvNgoko: 'matur nuwun sanget',
      TranslationVariant.jvKrama: 'matur nuwun sanget',
    },
    'matur nuwun sanget': {
      TranslationVariant.id: 'terima kasih banyak',
      TranslationVariant.en: 'thank you very much',
      TranslationVariant.jvNgoko: 'matur nuwun sanget',
      TranslationVariant.jvKrama: 'matur nuwun sanget',
    },
    'matur nuwun banget': {
      TranslationVariant.id: 'terima kasih banyak',
      TranslationVariant.en: 'thank you very much',
      TranslationVariant.jvNgoko: 'matur nuwun banget',
      TranslationVariant.jvKrama: 'matur nuwun sanget',
    },
    'thank you very much': {
      TranslationVariant.id: 'terima kasih banyak',
      TranslationVariant.en: 'thank you very much',
      TranslationVariant.jvNgoko: 'matur nuwun sanget',
      TranslationVariant.jvKrama: 'matur nuwun sanget',
    },
  };

  // ─── Lookup & Entry Index Cache ───────────────────────────────────────────

  static final Map<
    List<TranslationEntry>,
    Map<TranslationVariant, Map<String, TranslationEntry>>
  >
  _entryIndexCache = {};

  Map<TranslationVariant, Map<String, TranslationEntry>>
  _buildOrGetEntryIndex() {
    if (_entryIndexCache.containsKey(entries)) {
      return _entryIndexCache[entries]!;
    }
    final index = <TranslationVariant, Map<String, TranslationEntry>>{};
    for (final from in TranslationVariant.values) {
      index[from] = {};
      // 1. Indeks utama (prioritas tertinggi — menjaga keunikan 4-arah)
      for (final entry in entries) {
        final key = normalize(entry.getVariant(from));
        if (key.isEmpty) continue;
        index[from]![key] = entry;
      }
      // 2. Indeks sekunder Krama Lugu, Krama Inggil, & Krama Andhap untuk input jvKrama
      if (from == TranslationVariant.jvKrama) {
        for (final entry in entries) {
          if (entry.jvKramaLugu != null) {
            final luguKey = normalize(entry.jvKramaLugu!);
            if (luguKey.isNotEmpty) {
              index[from]!.putIfAbsent(luguKey, () => entry);
            }
          }
          if (entry.jvKramaInggil != null) {
            final inggilKey = normalize(entry.jvKramaInggil!);
            if (inggilKey.isNotEmpty) {
              index[from]!.putIfAbsent(inggilKey, () => entry);
            }
          }
          if (entry.jvKramaAndhap != null) {
            final andhapKey = normalize(entry.jvKramaAndhap!);
            if (andhapKey.isNotEmpty) {
              index[from]!.putIfAbsent(andhapKey, () => entry);
            }
          }
        }
      }
    }
    _entryIndexCache[entries] = index;
    return index;
  }

  /// Variasi ejaan wajar bahasa Jawa & Indonesia (hanya dipakai jika lookup utama tidak menemukan hasil).
  static const Map<TranslationVariant, Map<String, String>> _kSpellingAliases =
      {
        TranslationVariant.id: {
          'aku': 'saya',
          'bapak': 'ayah',
          'berbahaya': 'bahaya',
          'beli': 'membeli',
          'baca': 'membaca',
          'tulis': 'menulis',
          'lihat': 'melihat',
          'dengar': 'mendengar',
          'beri': 'memberi',
          'tanya': 'bertanya',
          'minta': 'meminta',
          'berkata': 'berbicara',
          'pinjam': 'meminjam',
          'undang': 'mengundang',
          'kerja': 'bekerja',
        },
        TranslationVariant.jvNgoko: {
          'apa': 'opo',
          'sapa': 'sopo',
          'pira': 'piro',
          'ana': 'ono',
          'piye': 'kepiye',
          'nang': 'neng',
          'soko': 'saka',
          'gak': 'ora',
          'ndak': 'ora',
          'ojo': 'aja',
          'sugeng enjang': 'sugeng enjing',
        },
        TranslationVariant.jvKrama: {
          'boten': 'mboten',
          'sugeng enjang': 'sugeng enjing',
          'kados pundi kabaripun': 'pripun kabaripun',
          'sampeyan': 'panjenengan',
        },
        TranslationVariant.en: {
          // Kata ganti & rujukan
          'he': 'he or she',
          'she': 'he or she',
          'him': 'he or she',
          'her': 'he or she',
          'his': 'he or she',
          'me': 'i',
          'my': 'i',
          'your': 'you',
          'yours': 'you',
          'our': 'we',
          'us': 'we',
          'their': 'they',
          'them': 'they',

          // Keluarga & sapaan
          'dad': 'father',
          'daddy': 'father',
          'mom': 'mother',
          'mommy': 'mother',
          'grandpa': 'grandfather',
          'grandma': 'grandmother',
          'kid': 'child',
          'kids': 'child',
          'children': 'child',

          // Lokasi & tempat
          'home': 'house',
          'there': 'over there',

          // Bentuk leksikal tunggal ke multi-kata kamus
          'take': 'take away',
          'heart': 'inner heart',
          'dance': 'perform dance',
          'wear': 'put on',
          'cancel': 'call off',
          'ask': 'ask for',
          'know': 'find out',
          'lose': 'be defeated',
          'play': 'hang out',
          'wake': 'wake up',
          'leave': 'go away',
          'return': 'return home',
          'go home': 'return home',
          'plow': 'plow field',
          'careful': 'be careful',
          'how many': 'how much',
          'dish': 'side dish',

          // Frasa modal & verba umum
          'like to': 'like',
          'need to': 'must',

          // Verba bentuk lampau tak beraturan (irregular past tense)
          'went': 'go',
          'ate': 'eat',
          'drank': 'drink',
          'slept': 'sleep',
          'saw': 'see',
          'took': 'take away',
          'bought': 'buy',
          'spoke': 'speak',
          'came': 'come',
          'felt': 'feel',
          'gave': 'give',
          'knew': 'know',
          'wrote': 'write',
          'ran': 'run',
          'sat': 'sit',
          'stood': 'stand',
          'read': 'read',
          'made': 'make',
          'did': 'do',
          'said': 'say',
          'heard': 'listen',
          'found': 'find out',
        },
      };

  /// Mencari satu frasa [phrase] di index untuk arah [from]→[to].
  /// Bila [register] disetel dan [to] adalah [TranslationVariant.jvKrama],
  /// memilih bentuk Krama Lugu atau Krama Inggil sesuai konteks subjek.
  String? _lookup(
    String phrase,
    TranslationVariant from,
    TranslationVariant to, {
    SpeechRegister? register,
  }) {
    final index = _buildOrGetEntryIndex();
    final entry = index[from]?[phrase];
    if (entry != null) {
      return _resolveEntryOutput(entry, to, register);
    }

    // 2. Cek kamus partikel gramatikal
    final functional = _kFunctionalGrammar[phrase];
    if (functional != null && functional.containsKey(to)) {
      return functional[to];
    }

    // 3. Cek variasi ejaan baku/wajar Jawa (fallback terkontrol)
    final alias = _kSpellingAliases[from]?[phrase];
    if (alias != null) {
      final aliasEntry = index[from]?[alias];
      if (aliasEntry != null) {
        return _resolveEntryOutput(aliasEntry, to, register);
      }
      final aliasFunc = _kFunctionalGrammar[alias];
      if (aliasFunc != null && aliasFunc.containsKey(to)) {
        return aliasFunc[to];
      }
    }

    return null;
  }

  static String _resolveEntryOutput(
    TranslationEntry entry,
    TranslationVariant to,
    SpeechRegister? register,
  ) {
    if (to == TranslationVariant.jvKrama && register != null) {
      return entry.getByRegister(register);
    }
    return entry.getVariant(to);
  }

  // ─── Deteksi Konteks Subjek, Unggah-Ungguh & 19 Kelompok Polisemi ─────────

  static const Set<String> _kSelfSubjects = {
    'saya',
    'aku',
    'kami',
    'kita',
    'kula',
    'i',
    'we',
    'me',
    'us',
  };

  static const Set<String> _kHonoredSubjects = {
    'bapak',
    'ayah',
    'ibu',
    'guru',
    'kakek',
    'nenek',
    'simbah',
    'eyang',
    'pak',
    'bu',
    'beliau',
    'anda',
    'panjenengan',
    'pakdhe',
    'budhe',
    'paman',
    'bibi',
    'father',
    'mother',
    'teacher',
    'grandfather',
    'grandmother',
    'grandpa',
    'grandma',
    'dad',
    'mom',
    'uncle',
    'aunt',
    'you',
  };

  /// Subjek orang ketiga yang status kehormatannya tidak eksplisit (fallback aman ke Krama Lugu).
  static const Set<String> _kAmbiguousThirdSubjects = {
    'dia',
    'ia',
    'mereka',
    'he',
    'she',
    'they',
  };

  /// Kata kerja relasional yang memiliki bentuk Krama Andhap saat diri sendiri
  /// bertindak terhadap orang yang dihormati (mis. memberi->nyaosi, bertanya->nyuwun pirsa).
  static const Set<String> _kRelationalAndhapVerbs = {
    'memberi',
    'beri',
    'berbicara',
    'berkata',
    'bertanya',
    'tanya',
    'meminta',
    'minta',
    'mengundang',
    'undang',
    'meminjam',
    'pinjam',
    'give',
    'ask',
    'invite',
    'borrow',
    'speak',
  };

  static const Set<String> _kRecipientPrepositions = {
    'kepada',
    'untuk',
    'dengan',
    'marang',
    'dhateng',
    'kanggo',
    'kangge',
    'kaliyan',
    'karo',
    'to',
    'for',
    'with',
  };

  static const Set<String> _kClauseBoundaries = {
    'dan',
    'tetapi',
    'tapi',
    'karena',
    'atau',
    'sedangkan',
    'ketika',
    'saat',
    'jika',
    'kalau',
    'meskipun',
    'walaupun',
    'agar',
    'supaya',
    'sambil',
    'lan',
    'nanging',
    'amarga',
    'utawa',
    'kaliyan',
    'ananging',
    'amargi',
    'utawi',
    'nalika',
    'yen',
    'menawi',
    'sanajan',
    'sanadyan',
    'supados',
    'sinambi',
    'and',
    'but',
    'because',
    'or',
    'while',
    'when',
    'if',
    'although',
    'so',
  };

  static const Set<String> _kPossessableHonorificNouns = {
    'rumah',
    'omah',
    'nama',
    'jeneng',
    'kepala',
    'sirah',
    'mata',
    'mripat',
    'mulut',
    'cangkem',
    'hidung',
    'irung',
    'gigi',
    'untu',
    'bibir',
    'lambe',
    'dada',
    'dhadha',
    'dahi',
    'bathuk',
    'leher',
    'gulu',
    'keringat',
    'kringet',
    'umur',
    'obat',
    'tangan',
    'kaki',
    'sikil',
    'rambut',
    'badan',
    'awak',
    'hati',
    'ati',
    'anak',
  };

  /// 19 kelompok kata polisemi Bahasa Indonesia yang diaudit pada Phase 4.
  static const Set<String> _kPolysemousWords = {
    'tahu',
    'bisa',
    'bulan',
    'kali',
    'bunga',
    'pukul',
    'tawar',
    'jadi',
    'jam',
    'sore',
    'malu',
    'keras',
    'berat',
    'ringan',
    'hati',
    'kepala',
    'tangan',
    'kaki',
    'jalan',
  };

  /// Frasa majemuk polisemi tetap (diperiksa sebelum token tunggal).
  static const Map<String, Map<TranslationVariant, String>>
  _kPolysemicCompounds = {
    'air tawar': {
      TranslationVariant.id: 'Air tawar',
      TranslationVariant.en: 'Fresh water',
      TranslationVariant.jvNgoko: 'Banyu tawa',
      TranslationVariant.jvKrama: 'Toya tawa',
    },
    'buah tangan': {
      TranslationVariant.id: 'Buah tangan',
      TranslationVariant.en: 'Souvenir',
      TranslationVariant.jvNgoko: 'Oleh-oleh',
      TranslationVariant.jvKrama: 'Angsal-angsal',
    },
    'kepala sekolah': {
      TranslationVariant.id: 'Kepala sekolah',
      TranslationVariant.en: 'School principal',
      TranslationVariant.jvNgoko: 'Kepala sekolah',
      TranslationVariant.jvKrama: 'Pangarsa sekolah',
    },
    'kepala desa': {
      TranslationVariant.id: 'Kepala desa',
      TranslationVariant.en: 'Village head',
      TranslationVariant.jvNgoko: 'Lurah',
      TranslationVariant.jvKrama: 'Lurah',
    },
    'bunga bank': {
      TranslationVariant.id: 'Bunga bank',
      TranslationVariant.en: 'Bank interest',
      TranslationVariant.jvNgoko: 'Anakan bank',
      TranslationVariant.jvKrama: 'Anakan bank',
    },
    'jam tangan': {
      TranslationVariant.id: 'Jam tangan',
      TranslationVariant.en: 'Wristwatch',
      TranslationVariant.jvNgoko: 'Jam tangan',
      TranslationVariant.jvKrama: 'Jam tangan',
    },
    'jalan jalan': {
      TranslationVariant.id: 'Jalan-jalan',
      TranslationVariant.en: 'Take a walk',
      TranslationVariant.jvNgoko: 'Mlaku-mlaku',
      TranslationVariant.jvKrama: 'Mlampah-mlampah',
    },
    'kaki gunung': {
      TranslationVariant.id: 'Kaki gunung',
      TranslationVariant.en: 'Foot of the mountain',
      TranslationVariant.jvNgoko: 'Sikil gunung',
      TranslationVariant.jvKrama: 'Suku redi',
    },
    'kaki meja': {
      TranslationVariant.id: 'Kaki meja',
      TranslationVariant.en: 'Table leg',
      TranslationVariant.jvNgoko: 'Sikil meja',
      TranslationVariant.jvKrama: 'Suku meja',
    },
  };

  static const Set<String> _kTahuFoodContext = {
    'makan',
    'goreng',
    'beli',
    'membeli',
    'masak',
    'memasak',
    'tempe',
    'nasi',
    'sayur',
    'sambal',
    'enak',
    'pedas',
    'lauk',
    'warung',
    'bacem',
    'rebus',
    'mangan',
    'nedha',
    'dhahar',
    'tuku',
    'tumbas',
    'mundhut',
    'lapar',
    'sega',
    'sekul',
    'piring',
  };

  static const Set<String> _kBisaVenomContext = {
    'ular',
    'ula',
    'kalajengking',
    'racun',
    'gigitan',
    'berbahaya',
    'bahaya',
    'mematikan',
    'terkena',
    'taring',
    'hewan',
    'sengatan',
    'obat',
  };

  static const Set<String> _kBulanCalendarContext = {
    'januari',
    'februari',
    'maret',
    'april',
    'mei',
    'juni',
    'juli',
    'agustus',
    'september',
    'oktober',
    'november',
    'desember',
    'depan',
    'lalu',
    'ini',
    'kemarin',
    'satu',
    'dua',
    'tiga',
    'empat',
    'lima',
    'enam',
    'tujuh',
    'delapan',
    'sembilan',
    'sepuluh',
    'berapa',
    'gaji',
    'sewa',
    'setiap',
    'tiap',
    'puasa',
    'tahun',
    'besok',
  };

  static const Set<String> _kNumberWords = {
    'satu',
    'dua',
    'tiga',
    'empat',
    'lima',
    'enam',
    'tujuh',
    'delapan',
    'sembilan',
    'sepuluh',
    'sebelas',
    'duabelas',
    'berapa',
    'pertama',
    'kedua',
    'ketiga',
    'banyak',
    'sering',
    'lagi',
  };

  static const Set<String> _kKaliRiverContext = {
    'air',
    'sungai',
    'banjir',
    'deras',
    'jembatan',
    'ikan',
    'mandi',
    'berenang',
    'bersih',
    'kotor',
    'pinggir',
    'tepi',
    'seberang',
    'di',
    'ke',
    'dari',
  };

  static const Set<String> _kBungaFinanceContext = {
    'bank',
    'pinjaman',
    'utang',
    'hutang',
    'kredit',
    'tabungan',
    'uang',
    'persen',
    'cicilan',
    'bayar',
    'membayar',
    'biaya',
    'tinggi',
    'rendah',
  };

  static const Set<String> _kPukulTimeContext = {
    'satu',
    'dua',
    'tiga',
    'empat',
    'lima',
    'enam',
    'tujuh',
    'delapan',
    'sembilan',
    'sepuluh',
    'sebelas',
    'duabelas',
    'berapa',
    'pagi',
    'siang',
    'sore',
    'malam',
    'sekarang',
    'datang',
    'pergi',
    'pulang',
    'tidur',
    'bangun',
    'makan',
    'mulai',
    'selesai',
  };

  static const Set<String> _kTawarTasteContext = {
    'rasa',
    'rasanya',
    'sup',
    'sayur',
    'makanan',
    'nasi',
    'teh',
    'kopi',
    'garam',
    'asin',
    'manis',
    'minum',
    'air',
    'danau',
    'sungai',
    'ikan',
  };

  static const Set<String> _kTawarBargainContext = {
    'harga',
    'pasar',
    'beli',
    'membeli',
    'jual',
    'menjual',
    'murah',
    'mahal',
    'pedagang',
    'toko',
    'baju',
    'barang',
    'sepatu',
  };

  static const Set<String> _kKerasSoundContext = {
    'suara',
    'bicara',
    'berbicara',
    'teriak',
    'musik',
    'bunyi',
    'hujan',
    'angin',
    'tertawa',
    'menangis',
    'dengar',
    'mendengar',
    'lagu',
  };

  static const Set<String> _kKerasEffortContext = {
    'bekerja',
    'kerja',
    'belajar',
    'usaha',
    'berusaha',
    'nasihat',
    'aturan',
    'hukum',
    'latihan',
  };

  static const Set<String> _kSeverityContext = {
    'sakit',
    'penyakit',
    'ujian',
    'tugas',
    'masalah',
    'pekerjaan',
    'hidup',
    'cobaan',
    'hukuman',
    'pelajaran',
    'luka',
    'demam',
    'batuk',
  };

  static const Set<String> _kHatiOrganContext = {
    'ayam',
    'sapi',
    'kambing',
    'goreng',
    'masak',
    'memasak',
    'makan',
    'organ',
    'daging',
    'lauk',
    'warung',
  };

  static const Set<String> _kKepalaLeaderContext = {
    'sekolah',
    'desa',
    'keluarga',
    'kantor',
    'dinas',
    'bagian',
    'stasiun',
    'suku',
    'negeri',
    'daerah',
    'tim',
    'kelompok',
  };

  static const Set<String> _kJalanRoadContext = {
    'raya',
    'besar',
    'kecil',
    'panjang',
    'rusak',
    'sepi',
    'ramai',
    'lurus',
    'belok',
    'pasar',
    'rumah',
    'kota',
    'desa',
    'tahu',
    'mobil',
    'motor',
    'sepeda',
    'di',
    'ke',
    'dari',
  };

  /// Menyelesaikan 19 kelompok kata polisemi Bahasa Indonesia berdasarkan konteks
  /// token kalimat dan posisi token [tokenIndex].
  String? _resolvePolysemy(
    String token,
    int tokenIndex,
    List<String> allTokens,
    TranslationVariant from,
    TranslationVariant to,
    SpeechRegister? clauseRegister,
  ) {
    if (from != TranslationVariant.id) return null;
    final prevTok = tokenIndex > 0 ? allTokens[tokenIndex - 1] : null;
    final nextTok = tokenIndex + 1 < allTokens.length
        ? allTokens[tokenIndex + 1]
        : null;
    final isNumericNext =
        nextTok != null && RegExp(r'^\d+([:.]\d+)?$').hasMatch(nextTok);
    final isNumericPrev = prevTok != null && RegExp(r'^\d+$').hasMatch(prevTok);

    switch (token) {
      case 'tahu':
        if (allTokens.any(_kTahuFoodContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Tahu',
            TranslationVariant.jvKrama => 'Tahu',
            TranslationVariant.en => 'Tofu',
            TranslationVariant.id => 'Tahu',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Ngerti',
          TranslationVariant.jvKrama =>
            clauseRegister == SpeechRegister.kramaInggil
                ? 'Priksa'
                : 'Mangertos',
          TranslationVariant.en => 'Know',
          TranslationVariant.id => 'Tahu',
        };

      case 'bisa':
        if (allTokens.any(_kBisaVenomContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Wisa',
            TranslationVariant.jvKrama => 'Wisa',
            TranslationVariant.en => 'Venom',
            TranslationVariant.id => 'Bisa',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Iso',
          TranslationVariant.jvKrama => 'Saged',
          TranslationVariant.en => 'Can',
          TranslationVariant.id => 'Bisa',
        };

      case 'bulan':
        if (allTokens.any(_kBulanCalendarContext.contains) || isNumericPrev) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Sasi',
            TranslationVariant.jvKrama => 'Wulan',
            TranslationVariant.en => 'Month',
            TranslationVariant.id => 'Bulan',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Rembulan',
          TranslationVariant.jvKrama => 'Wulan',
          TranslationVariant.en => 'Moon',
          TranslationVariant.id => 'Bulan',
        };

      case 'kali':
        if ((prevTok != null && _kNumberWords.contains(prevTok)) ||
            isNumericPrev ||
            (nextTok != null && _kNumberWords.contains(nextTok))) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Ping',
            TranslationVariant.jvKrama => 'Kaping',
            TranslationVariant.en => 'Times',
            TranslationVariant.id => 'Kali',
          };
        }
        if (allTokens.any(_kKaliRiverContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Kali',
            TranslationVariant.jvKrama => 'Lepen',
            TranslationVariant.en => 'River',
            TranslationVariant.id => 'Kali',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Ping',
          TranslationVariant.jvKrama => 'Kaping',
          TranslationVariant.en => 'Times',
          TranslationVariant.id => 'Kali',
        };

      case 'bunga':
        if (allTokens.any(_kBungaFinanceContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Anakan',
            TranslationVariant.jvKrama => 'Anakan',
            TranslationVariant.en => 'Interest',
            TranslationVariant.id => 'Bunga',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Kembang',
          TranslationVariant.jvKrama => 'Sekar',
          TranslationVariant.en => 'Flower',
          TranslationVariant.id => 'Bunga',
        };

      case 'pukul':
        if (isNumericNext ||
            (nextTok != null && _kPukulTimeContext.contains(nextTok)) ||
            allTokens.any(
              (t) =>
                  t == 'pagi' ||
                  t == 'siang' ||
                  t == 'sore' ||
                  t == 'malam' ||
                  t == 'berapa',
            )) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Jam',
            TranslationVariant.jvKrama => 'Tabuh',
            TranslationVariant.en => "O'clock",
            TranslationVariant.id => 'Pukul',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Gebug',
          TranslationVariant.jvKrama => 'Gebug',
          TranslationVariant.en => 'Hit',
          TranslationVariant.id => 'Pukul',
        };

      case 'tawar':
        if (allTokens.any(_kTawarBargainContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Nyang',
            TranslationVariant.jvKrama => 'Ngawis',
            TranslationVariant.en => 'Bargain',
            TranslationVariant.id => 'Tawar',
          };
        }
        if (allTokens.any(_kTawarTasteContext.contains)) {
          if (allTokens.contains('air') ||
              allTokens.contains('ikan') ||
              allTokens.contains('sungai') ||
              allTokens.contains('danau')) {
            return switch (to) {
              TranslationVariant.jvNgoko => 'Tawa',
              TranslationVariant.jvKrama => 'Tawa',
              TranslationVariant.en => 'Fresh',
              TranslationVariant.id => 'Tawar',
            };
          }
          return switch (to) {
            TranslationVariant.jvNgoko => 'Cemplang',
            TranslationVariant.jvKrama => 'Cemplang',
            TranslationVariant.en => 'Bland',
            TranslationVariant.id => 'Tawar',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Tari',
          TranslationVariant.jvKrama => 'Taros',
          TranslationVariant.en => 'Offer',
          TranslationVariant.id => 'Tawar',
        };

      case 'jadi':
        // Awal kalimat atau sesudah kata hubung: konektor 'jadi' (= oleh karena itu)
        if (tokenIndex == 0 ||
            (prevTok != null && _kClauseBoundaries.contains(prevTok))) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Dadi',
            TranslationVariant.jvKrama => 'Dadosipun',
            TranslationVariant.en => 'So',
            TranslationVariant.id => 'Jadi',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Dadi',
          TranslationVariant.jvKrama => 'Dados',
          TranslationVariant.en => 'Become',
          TranslationVariant.id => 'Jadi',
        };

      case 'jam':
        if (isNumericNext ||
            (nextTok != null && _kPukulTimeContext.contains(nextTok))) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Jam',
            TranslationVariant.jvKrama => 'Tabuh',
            TranslationVariant.en => "O'clock",
            TranslationVariant.id => 'Jam',
          };
        }
        if (isNumericPrev ||
            (prevTok != null && _kNumberWords.contains(prevTok))) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Jam',
            TranslationVariant.jvKrama => 'Jam',
            TranslationVariant.en => 'Hour',
            TranslationVariant.id => 'Jam',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Jam',
          TranslationVariant.jvKrama => 'Jam',
          TranslationVariant.en => 'Clock',
          TranslationVariant.id => 'Jam',
        };

      case 'sore':
        return switch (to) {
          TranslationVariant.jvNgoko => 'Sore',
          TranslationVariant.jvKrama => 'Sonten',
          TranslationVariant.en => 'Afternoon',
          TranslationVariant.id => 'Sore',
        };

      case 'malu':
        if (allTokens.contains('buat') || allTokens.contains('rasa')) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Wirang',
            TranslationVariant.jvKrama => 'Wirang',
            TranslationVariant.en => 'Ashamed',
            TranslationVariant.id => 'Malu',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Isin',
          TranslationVariant.jvKrama =>
            clauseRegister == SpeechRegister.kramaInggil ? 'Lingsem' : 'Isin',
          TranslationVariant.en => 'Shy',
          TranslationVariant.id => 'Malu',
        };

      case 'keras':
        if (allTokens.any(_kKerasSoundContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Banter',
            TranslationVariant.jvKrama => 'Sora',
            TranslationVariant.en => 'Loud',
            TranslationVariant.id => 'Keras',
          };
        }
        if (allTokens.any(_kKerasEffortContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Temenan',
            TranslationVariant.jvKrama => 'Estu',
            TranslationVariant.en => 'Hard',
            TranslationVariant.id => 'Keras',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Atos',
          TranslationVariant.jvKrama => 'Atos',
          TranslationVariant.en => 'Hard',
          TranslationVariant.id => 'Keras',
        };

      case 'berat':
        if (allTokens.any(_kSeverityContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Abot',
            TranslationVariant.jvKrama => 'Awrat',
            TranslationVariant.en => 'Severe',
            TranslationVariant.id => 'Berat',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Abot',
          TranslationVariant.jvKrama => 'Awrat',
          TranslationVariant.en => 'Heavy',
          TranslationVariant.id => 'Berat',
        };

      case 'ringan':
        if (allTokens.any(_kSeverityContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Entheng',
            TranslationVariant.jvKrama => 'Entheng',
            TranslationVariant.en => 'Mild',
            TranslationVariant.id => 'Ringan',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Entheng',
          TranslationVariant.jvKrama => 'Entheng',
          TranslationVariant.en => 'Light',
          TranslationVariant.id => 'Ringan',
        };

      case 'hati':
        if (allTokens.any(_kHatiOrganContext.contains)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Ati',
            TranslationVariant.jvKrama => 'Ati',
            TranslationVariant.en => 'Liver',
            TranslationVariant.id => 'Hati',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Ati',
          TranslationVariant.jvKrama =>
            clauseRegister == SpeechRegister.kramaInggil
                ? 'Penggalih'
                : 'Manah',
          TranslationVariant.en => 'Heart',
          TranslationVariant.id => 'Hati',
        };

      case 'kepala':
        if (nextTok != null && _kKepalaLeaderContext.contains(nextTok)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Kepala',
            TranslationVariant.jvKrama => 'Pangarsa',
            TranslationVariant.en => 'Head',
            TranslationVariant.id => 'Kepala',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Sirah',
          TranslationVariant.jvKrama =>
            clauseRegister == SpeechRegister.kramaInggil ? 'Mustaka' : 'Sirah',
          TranslationVariant.en => 'Head',
          TranslationVariant.id => 'Kepala',
        };

      case 'tangan':
        return switch (to) {
          TranslationVariant.jvNgoko => 'Tangan',
          TranslationVariant.jvKrama =>
            clauseRegister == SpeechRegister.kramaInggil ? 'Asta' : 'Tangan',
          TranslationVariant.en => 'Hand',
          TranslationVariant.id => 'Tangan',
        };

      case 'kaki':
        if (nextTok != null &&
            const {
              'gunung',
              'bukit',
              'meja',
              'kursi',
              'langit',
              'lima',
            }.contains(nextTok)) {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Sikil',
            TranslationVariant.jvKrama => 'Suku',
            TranslationVariant.en => 'Foot',
            TranslationVariant.id => 'Kaki',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Sikil',
          TranslationVariant.jvKrama =>
            clauseRegister == SpeechRegister.kramaInggil ? 'Ampeyan' : 'Suku',
          TranslationVariant.en => 'Foot',
          TranslationVariant.id => 'Kaki',
        };

      case 'jalan':
        // Jika didahului preposisi tempat atau ada petunjuk jalan raya -> kata benda 'Dalan/Margi'
        if ((prevTok == 'di' || prevTok == 'ke' || prevTok == 'dari') ||
            allTokens.any(_kJalanRoadContext.contains) &&
                prevTok != 'sedang' &&
                nextTok != 'kaki') {
          return switch (to) {
            TranslationVariant.jvNgoko => 'Dalan',
            TranslationVariant.jvKrama => 'Margi',
            TranslationVariant.en => 'Road',
            TranslationVariant.id => 'Jalan',
          };
        }
        return switch (to) {
          TranslationVariant.jvNgoko => 'Mlaku',
          TranslationVariant.jvKrama =>
            clauseRegister == SpeechRegister.kramaInggil ? 'Tindak' : 'Mlampah',
          TranslationVariant.en => 'Walk',
          TranslationVariant.id => 'Jalan',
        };

      default:
        return null;
    }
  }

  /// Catatan ambiguitas jujur untuk 19 kelompok kata polisemi tunggal tanpa konteks kalimat.
  static const Map<String, String> _kStandalonePolysemyNotes = {
    'tahu':
        'Kata "tahu" bermakna ganda: makanan (tahu/tofu) atau memahami (ngerti/mangertos/priksa). Tambahkan konteks kalimat atau gunakan AI untuk hasil lebih tepat.',
    'bisa':
        'Kata "bisa" bermakna ganda: mampu/dapat (iso/saged) atau racun ular (wisa). Tambahkan konteks kalimat atau gunakan AI untuk hasil lebih tepat.',
    'bulan':
        'Kata "bulan" bermakna ganda: benda langit (rembulan/wulan) atau bulan kalender (sasi/wulan). Tambahkan konteks kalimat untuk kepastian makna.',
    'kali':
        'Kata "kali" bermakna ganda: sungai (kali/lepen) atau pengali/frekuensi (ping/kaping). Tambahkan konteks kalimat untuk kepastian makna.',
    'bunga':
        'Kata "bunga" bermakna ganda: tanaman (kembang/sekar) atau bunga bank (anakan). Tambahkan konteks kalimat untuk kepastian makna.',
    'pukul':
        'Kata "pukul" bermakna ganda: waktu/jam (jam/tabuh) atau memukul (gebug). Tambahkan konteks kalimat untuk kepastian makna.',
    'tawar':
        'Kata "tawar" bermakna ganda: hambar/air tawar (cemplang/tawa), menawar harga (nyang/ngawis), atau menawarkan (tari/taros). Tambahkan konteks kalimat.',
    'jadi':
        'Kata "jadi" bermakna ganda: menjadi (dadi/dados) atau kata sambung "oleh karena itu" (dadi/dadosipun). Tambahkan konteks kalimat.',
    'jam':
        'Kata "jam" bermakna ganda: penunjuk waktu/pukul (jam/tabuh), durasi (jam), atau benda jam (jam). Tambahkan konteks kalimat.',
    'sore':
        'Kata "sore" merujuk waktu petang (sore/sonten); untuk sapaan gunakan "Selamat sore" (Sugeng sonten).',
    'malu':
        'Kata "malu" berbeda tingkat tutur: untuk diri sendiri gunakan Krama Lugu "Isin" (bukan Krama Inggil "Lingsem"); untuk aib gunakan "Wirang".',
    'keras':
        'Kata "keras" bermakna ganda: padat/kaku (atos), nyaring (banter/sora), atau bersungguh-sungguh (temenan/estu). Tambahkan konteks kalimat.',
    'berat':
        'Kata "berat" bermakna ganda: bobot fisik (abot/awrat — heavy) atau tingkat keparahan/kesulitan (abot/awrat — severe/hard).',
    'ringan':
        'Kata "ringan" bermakna ganda: bobot fisik (entheng — light) atau tingkat keparahan/kemudahan (entheng — mild/easy).',
    'hati':
        'Kata "hati" bermakna ganda: perasaan/batin (ati/manah/penggalih) atau organ hati (ati — liver). Tambahkan konteks kalimat.',
    'kepala':
        'Kata "kepala" bermakna ganda: anggota tubuh (sirah/mustaka) atau pemimpin (kepala/pangarsa). Hindari "Mustaka" untuk diri sendiri maupun jabatan.',
    'tangan':
        'Kata "tangan" berbeda tingkat tutur: untuk diri sendiri gunakan "Tangan", untuk orang dihormati gunakan "Asta"; pada ungkapan seperti "buah tangan" maknanya oleh-oleh.',
    'kaki':
        'Kata "kaki" bermakna ganda: anggota tubuh (sikil/suku/ampeyan) atau bagian bawah benda/alam (kaki meja/kaki gunung -> sikil/suku, bukan ampeyan).',
    'jalan':
        'Kata "jalan" bermakna ganda: jalan raya (dalan/margi) atau berjalan (mlaku/mlampah/tindak). Tambahkan konteks kalimat untuk kepastian makna.',
  };

  static String? _standaloneAmbiguityNote(
    String normalizedInput,
    TranslationVariant from,
    TranslationVariant to, {
    TranslationEntry? entry,
    SpeechRegister? register,
  }) {
    if (from == TranslationVariant.id) {
      final polyNote = _kStandalonePolysemyNotes[normalizedInput];
      if (polyNote != null) return polyNote;
    }
    if (to == TranslationVariant.jvKrama &&
        register == null &&
        entry != null &&
        entry.hasHonorificDistinction) {
      final parts = <String>[
        'Krama Lugu (diri sendiri): ${entry.kramaLugu}',
        if (entry.kramaInggil.toLowerCase() != entry.kramaLugu.toLowerCase())
          'Krama Inggil (orang dihormati): ${entry.kramaInggil}',
        if (entry.jvKramaAndhap != null)
          'Krama Andhap (diri sendiri kepada orang dihormati): ${entry.jvKramaAndhap}',
      ];
      return 'Kata ini memiliki perbedaan unggah-ungguh. ${parts.join('; ')}. Tambahkan subjek kalimat agar tingkat tutur dipilih otomatis.';
    }
    return null;
  }

  // ─── Penanganan Morfologi & Imbuhan Terkendali ─────────────────────────────

  /// Mencoba menerjemahkan kata berimbuhan [token] berdasarkan aturan morfologi
  /// Jawa, Indonesia, dan Inggris yang valid dan terverifikasi leksikonnya.
  String? _tryMorphology(
    String token,
    TranslationVariant from,
    TranslationVariant to, {
    SpeechRegister? register,
  }) {
    if (token.length <= 3) return null;

    // A. Klitika posesif bahasa Jawa:
    //    -ku (omahku -> omah + ku), -mu (omahmu -> omah + mu),
    //    -e (omahe -> omah + e), -ipun (griyaipun -> griya + ipun)
    if (from == TranslationVariant.jvNgoko ||
        from == TranslationVariant.jvKrama) {
      // 1. -ku
      if (token.endsWith('ku') && token.length > 4) {
        final base = token.substring(0, token.length - 2);
        final baseTrans = _lookup(base, from, to, register: register);
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
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-mu';
          if (to == TranslationVariant.en) return 'your $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-mu';
          if (to == TranslationVariant.jvKrama) return '$baseTrans panjenengan';
        }
      }
      // 3a. -nipun (Krama pasca-vokal: griyanipun, toyanipun)
      if (token.endsWith('nipun') && token.length > 7) {
        final base = token.substring(0, token.length - 5);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-nya';
          if (to == TranslationVariant.en) return 'the $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-e';
          if (to == TranslationVariant.jvKrama) return '$baseTrans-ipun';
        }
      }
      // 3b. -ipun (Krama pasca-konsonan: kabaripun, griyaipun)
      if (token.endsWith('ipun') && token.length > 6) {
        final base = token.substring(0, token.length - 4);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-nya';
          if (to == TranslationVariant.en) return 'the $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-e';
          if (to == TranslationVariant.jvKrama) return '$baseTrans-ipun';
        }
      }
      // 4a. -ne (Ngoko pasca-vokal: bukune, segane, kancane)
      if (token.endsWith('ne') && token.length > 4) {
        final base = token.substring(0, token.length - 2);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-nya';
          if (to == TranslationVariant.en) return 'the $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-e';
          if (to == TranslationVariant.jvKrama) return '$baseTrans-ipun';
        }
      }
      // 4b. -e (Ngoko pasca-konsonan: omahe, awake)
      if (token.endsWith('e') && token.length > 3) {
        final base = token.substring(0, token.length - 1);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) return '$baseTrans-nya';
          if (to == TranslationVariant.en) return 'the $baseTrans';
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-e';
          if (to == TranslationVariant.jvKrama) return '$baseTrans-ipun';
        }
      }
      // 5a. Awalan pasif Krama: dipun- (dipuntumbas, dipunwaos)
      if (token.startsWith('dipun') && token.length > 7) {
        final base = token.substring(5);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) {
            return _toIndonesianPassive(baseTrans);
          }
          if (to == TranslationVariant.jvNgoko) return 'di$baseTrans';
          if (to == TranslationVariant.jvKrama) return 'dipun$baseTrans';
          if (to == TranslationVariant.en) return 'be $baseTrans';
        }
      }
      // 5b. Awalan pasif Jawa: di- (dituku, diserat)
      if (token.startsWith('di') && token.length > 4) {
        final base = token.substring(2);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) {
            return _toIndonesianPassive(baseTrans);
          }
          if (to == TranslationVariant.jvNgoko) return 'di$baseTrans';
          if (to == TranslationVariant.jvKrama) return 'dipun$baseTrans';
          if (to == TranslationVariant.en) return 'be $baseTrans';
        }
      }
      // 6. Awalan pelaku Ngoko: tak- / dak- (taktuku) & kok- (koktuku)
      if ((token.startsWith('tak') || token.startsWith('dak')) &&
          token.length > 5) {
        final base = token.substring(3);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) {
            return 'ku${_stripIndoActivePrefix(baseTrans)}';
          }
          if (to == TranslationVariant.jvKrama) return 'kula $baseTrans';
          if (to == TranslationVariant.en) return 'I $baseTrans';
        }
      }
      if (token.startsWith('kok') && token.length > 5) {
        final base = token.substring(3);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.id) {
            return 'kau${_stripIndoActivePrefix(baseTrans)}';
          }
          if (to == TranslationVariant.jvKrama) return 'panjenengan $baseTrans';
          if (to == TranslationVariant.en) return 'you $baseTrans';
        }
      }
    }

    // B. Imbuhan bahasa Indonesia:
    //    -ku, -mu, -nya, di-
    if (from == TranslationVariant.id) {
      // 1. -ku
      if (token.endsWith('ku') && token.length > 4) {
        final base = token.substring(0, token.length - 2);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-ku';
          if (to == TranslationVariant.jvKrama) return '$baseTrans kula';
          if (to == TranslationVariant.en) return 'my $baseTrans';
        }
      }
      // 2. -mu
      if (token.endsWith('mu') && token.length > 4) {
        final base = token.substring(0, token.length - 2);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) {
          if (to == TranslationVariant.jvNgoko) return '$baseTrans-mu';
          if (to == TranslationVariant.jvKrama) return '$baseTrans panjenengan';
          if (to == TranslationVariant.en) return 'your $baseTrans';
        }
      }
      // 3. -nya
      if (token.endsWith('nya') && token.length > 5) {
        final base = token.substring(0, token.length - 3);
        final baseTrans = _lookup(base, from, to, register: register);
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
        String? baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans == null) {
          final activeCandidate = switch (base[0]) {
            'b' || 'p' => 'mem$base',
            'c' || 'd' || 'j' || 't' => 'men$base',
            's' => 'meny${base.substring(1)}',
            _ => 'meng$base',
          };
          baseTrans = _lookup(activeCandidate, from, to, register: register);
        }
        if (baseTrans != null) {
          if (to == TranslationVariant.jvNgoko) return 'di$baseTrans';
          if (to == TranslationVariant.jvKrama) return 'dipun$baseTrans';
          if (to == TranslationVariant.en) return 'be $baseTrans';
        }
      }
    }

    // C. Morfologi Bahasa Inggris:
    //    1. Suffix -ing (present participle / progresif)
    //    2. Suffix -es (verba orang ketiga / plural nomina)
    //    3. Suffix -s (verba orang ketiga / plural nomina)
    //    4. Suffix -ed (lampau / partisipel)
    if (from == TranslationVariant.en) {
      // 1. Suffix -ing (reading, eating, going, walking, coming, writing)
      if (token.endsWith('ing') && token.length >= 5) {
        // a. Pangkas langsung 'ing'
        final base1 = token.substring(0, token.length - 3);
        String? baseTrans = _lookup(base1, from, to, register: register);
        // b. Tambahkan silent 'e' (writing -> write, coming -> come)
        if (baseTrans == null && base1.length >= 2) {
          baseTrans = _lookup('${base1}e', from, to, register: register);
        }
        // c. Konsonan ganda (running -> run, sitting -> sit)
        if (baseTrans == null &&
            base1.length >= 3 &&
            base1[base1.length - 1] == base1[base1.length - 2]) {
          baseTrans = _lookup(
            base1.substring(0, base1.length - 1),
            from,
            to,
            register: register,
          );
        }
        if (baseTrans != null) return baseTrans;
      }

      // 2. Suffix -es (goes, watches, boxes, houses)
      if (token.endsWith('es') && token.length >= 4) {
        final base1 = token.substring(0, token.length - 2);
        String? baseTrans = _lookup(base1, from, to, register: register);
        if (baseTrans == null) {
          final base2 = token.substring(0, token.length - 1);
          baseTrans = _lookup(base2, from, to, register: register);
        }
        if (baseTrans != null) return baseTrans;
      }

      // 3. Suffix -s (sleeps, eats, drinks, books, friends, clothes)
      if (token.endsWith('s') && token.length > 3 && !token.endsWith('ss')) {
        final base = token.substring(0, token.length - 1);
        final baseTrans = _lookup(base, from, to, register: register);
        if (baseTrans != null) return baseTrans;
      }

      // 4. Suffix -ed (walked, asked, helped, lived)
      if (token.endsWith('ed') && token.length > 4) {
        final base1 = token.substring(0, token.length - 2);
        String? baseTrans = _lookup(base1, from, to, register: register);
        baseTrans ??= _lookup('${base1}e', from, to, register: register);
        if (baseTrans == null &&
            base1.length >= 3 &&
            base1[base1.length - 1] == base1[base1.length - 2]) {
          baseTrans = _lookup(
            base1.substring(0, base1.length - 1),
            from,
            to,
            register: register,
          );
        }
        if (baseTrans != null) return baseTrans;
      }
    }

    return null;
  }

  /// Mengubah hasil kata kerja Indonesia aktif (mis. 'Membeli') menjadi bentuk
  /// dasar pasif (mis. 'dibeli') saat menerjemahkan awalan pasif Jawa di-/dipun-.
  static String _toIndonesianPassive(String indoVerb) {
    return 'di${_stripIndoActivePrefix(indoVerb)}';
  }

  static String _stripIndoActivePrefix(String indoVerb) {
    final lower = indoVerb.toLowerCase();
    for (final prefix in const ['meng', 'mem', 'men', 'me']) {
      if (lower.startsWith(prefix) && lower.length > prefix.length + 2) {
        return lower.substring(prefix.length);
      }
    }
    return lower;
  }

  // ─── Token-level longest-match-first + Konteks Subjek & Polisemi ─────────

  /// Memeriksa apakah dalam klausa aktif (sampai batas klausa berikutnya)
  /// terdapat objek/penerima yang dihormati.
  static bool _hasHonoredTargetInClause(List<String> tokens, int startIndex) {
    for (int k = startIndex; k < tokens.length; k++) {
      final tok = tokens[k];
      if (_kClauseBoundaries.contains(tok)) break;
      if (_kHonoredSubjects.contains(tok)) return true;
    }
    return false;
  }

  /// Mencari entri asli [TranslationEntry] untuk memeriksa `hasHonorificDistinction`.
  TranslationEntry? _lookupEntry(String phrase, TranslationVariant from) {
    final index = _buildOrGetEntryIndex();
    final direct = index[from]?[phrase];
    if (direct != null) return direct;
    final alias = _kSpellingAliases[from]?[phrase];
    if (alias != null) return index[from]?[alias];
    return null;
  }

  /// Memecah [normalizedInput] menjadi token kata, lalu menggabungkan hasil
  /// terjemahan per token dengan strategi longest-match-first, disambiguasi
  /// 19 kelompok polisemi kontekstual, pemilihan unggah-ungguh Krama Lugu /
  /// Krama Inggil / Krama Andhap berdasarkan pelaku & penerima tindakan,
  /// serta penanganan partikel dan morfologi terkontrol.
  ///
  /// Batas eksplisit mesin offline: berbasis kamus (855 entri) dan aturan
  /// lokal; tidak melakukan penguraian sintaksis penuh (reordering kalimat
  /// panjang) maupun penalaran pragmatik di luar aturan yang terdaftar.
  TranslationResult _translateByTokens(
    String normalizedInput,
    TranslationVariant from,
    TranslationVariant to, {
    SpeechRegister? forcedRegister,
  }) {
    final tokens = normalizedInput.split(' ');
    final buffer = StringBuffer();
    bool anyFound = false;
    bool hasUnknown = false;
    bool usedAmbiguousThirdFallback = false;
    // 0 = none, 1 = self, 2 = honored, 3 = ambiguousThird
    int clauseActor = 0;
    bool clauseHasRelationalAndhap = false;
    SpeechRegister? clauseRegister = forcedRegister;
    SpeechRegister? lastAppliedRegister = forcedRegister;
    int i = 0;

    while (i < tokens.length) {
      bool matched = false;
      final currentToken = tokens[i];
      final prevTok = i > 0 ? tokens[i - 1] : null;

      // Reset konteks pelaku saat memasuki klausa baru
      if (_kClauseBoundaries.contains(currentToken)) {
        clauseActor = 0;
        clauseHasRelationalAndhap = false;
        clauseRegister = forcedRegister;
      } else if (forcedRegister == null) {
        if (_kSelfSubjects.contains(currentToken)) {
          // Hanya ubah pelaku bila belum ada pelaku atau bukan posisi objek penerima
          if (clauseActor == 0 ||
              (prevTok != null &&
                  !_kRecipientPrepositions.contains(prevTok) &&
                  !_kRelationalAndhapVerbs.contains(prevTok))) {
            if (clauseActor == 0) {
              clauseActor = 1;
              clauseRegister = SpeechRegister.kramaLugu;
              lastAppliedRegister = clauseRegister;
            }
          }
        } else if (_kHonoredSubjects.contains(currentToken)) {
          // Jika muncul setelah preposisi penerima ('kepada Bapak') atau setelah
          // kata kerja relasional Krama Andhap dalam klausa ini ('meminjam buku Bapak'),
          // jangan timpa pelaku diri sendiri.
          final isRecipientObject =
              clauseActor == 1 &&
              (clauseHasRelationalAndhap ||
                  (prevTok != null &&
                      (_kRecipientPrepositions.contains(prevTok) ||
                          _kRelationalAndhapVerbs.contains(prevTok))));
          if (!isRecipientObject) {
            clauseActor = 2;
            clauseRegister = SpeechRegister.kramaInggil;
            lastAppliedRegister = clauseRegister;
          } else if (clauseHasRelationalAndhap &&
              i + 1 < tokens.length &&
              const {
                'makan',
                'minum',
                'tidur',
                'duduk',
                'datang',
                'pergi',
                'pulang',
                'berdiri',
                'mandi',
                'berbicara',
                'bekerja',
              }.contains(tokens[i + 1])) {
            // Tindakan tersemat yang dilakukan penerima dihormati
            // (mis. "Saya mengundang Kakek makan" -> Kula Ngaturi Eyang kakung Dhahar)
            clauseRegister = SpeechRegister.kramaInggil;
          }
        } else if (_kAmbiguousThirdSubjects.contains(currentToken) &&
            clauseActor == 0) {
          clauseActor = 3;
          clauseRegister = SpeechRegister.kramaLugu;
          lastAppliedRegister = clauseRegister;
        }
      }

      // Tentukan register efektif untuk token/frasa ini:
      // 1) Arah tindakan Krama Andhap: pelaku diri sendiri -> penerima dihormati
      // 2) Lookahead posesif nomina bertingkat ("Rumah Bapak" -> Dalem Bapak,
      //    "Rumah saya" -> Griya Kula, lokatif umum "di rumah" -> Griya)
      SpeechRegister? effectiveRegister = clauseRegister;
      if (to == TranslationVariant.jvKrama &&
          forcedRegister == null &&
          clauseActor == 1 &&
          _kRelationalAndhapVerbs.contains(currentToken) &&
          _hasHonoredTargetInClause(tokens, i + 1)) {
        effectiveRegister = SpeechRegister.kramaAndhap;
        lastAppliedRegister = SpeechRegister.kramaAndhap;
        clauseHasRelationalAndhap = true;
      }

      if (to == TranslationVariant.jvKrama &&
          _kPossessableHonorificNouns.contains(currentToken)) {
        final nextTok = i + 1 < tokens.length ? tokens[i + 1] : null;
        if (nextTok != null && _kHonoredSubjects.contains(nextTok)) {
          effectiveRegister = SpeechRegister.kramaInggil;
          lastAppliedRegister = effectiveRegister;
        } else if (nextTok != null && _kSelfSubjects.contains(nextTok)) {
          effectiveRegister = SpeechRegister.kramaLugu;
          lastAppliedRegister = effectiveRegister;
        } else if (currentToken == 'rumah' &&
            forcedRegister == null &&
            (prevTok == 'di' || prevTok == 'ke' || prevTok == 'dari')) {
          effectiveRegister = SpeechRegister.kramaLugu;
        }
      }

      // Tandai bila subjek orang ketiga ambigu bertemu kata bertingkat (fallback aman Krama Lugu)
      if (to == TranslationVariant.jvKrama &&
          forcedRegister == null &&
          clauseActor == 3) {
        final tokEntry = _lookupEntry(currentToken, from);
        if (tokEntry != null && tokEntry.hasHonorificDistinction) {
          usedAmbiguousThirdFallback = true;
        }
      }

      // 0a. Cek frasa majemuk polisemi tetap (2-kata) sebelum pemrosesan token tunggal
      if (from == TranslationVariant.id && i + 1 < tokens.length) {
        final twoWord = '${tokens[i]} ${tokens[i + 1]}';
        final compound = _kPolysemicCompounds[twoWord];
        if (compound != null && compound.containsKey(to)) {
          if (forcedRegister == null &&
              clauseActor == 0 &&
              (twoWord == 'kepala sekolah' || twoWord == 'kepala desa')) {
            clauseActor = 2;
            clauseRegister = SpeechRegister.kramaInggil;
            lastAppliedRegister = clauseRegister;
          }
          if (buffer.isNotEmpty) buffer.write(' ');
          buffer.write(compound[to]);
          anyFound = true;
          i += 2;
          matched = true;
        }
      }

      // 0b. Disambiguasi 19 kelompok polisemi kontekstual pada kalimat multi-kata
      if (!matched &&
          tokens.length > 1 &&
          from == TranslationVariant.id &&
          _kPolysemousWords.contains(currentToken)) {
        // Pastikan bukan bagian dari frasa tetap di kamus (mis. 'saya tidak tahu', 'sakit hati')
        bool matchedLongerPhrase = false;
        for (int len = tokens.length - i; len >= 2; len--) {
          final phrase = tokens.sublist(i, i + len).join(' ');
          final phraseTarget = _lookup(
            phrase,
            from,
            to,
            register: effectiveRegister,
          );
          if (phraseTarget != null) {
            if (buffer.isNotEmpty) buffer.write(' ');
            buffer.write(phraseTarget);
            anyFound = true;
            i += len;
            matched = true;
            matchedLongerPhrase = true;
            break;
          }
        }
        if (!matchedLongerPhrase) {
          final polyTarget = _resolvePolysemy(
            currentToken,
            i,
            tokens,
            from,
            to,
            effectiveRegister,
          );
          if (polyTarget != null) {
            if (buffer.isNotEmpty) buffer.write(' ');
            buffer.write(polyTarget);
            anyFound = true;
            i++;
            matched = true;
          }
        }
      }

      // 0c. Penanganan artikel & kopula bahasa Inggris
      if (!matched && from == TranslationVariant.en) {
        // Artikel bahasa Inggris ('the', 'a', 'an') dilewati dalam kalimat multi-kata
        if (tokens.length > 1 &&
            (currentToken == 'the' || currentToken == 'a' || currentToken == 'an')) {
          i++;
          continue;
        }

        // Kopula predikatif & aspek bahasa Inggris ('is', 'am', 'are', 'was', 'were')
        if (tokens.length > 1 &&
            const {'is', 'am', 'are', 'was', 'were'}.contains(currentToken)) {
          final nextTok = i + 1 < tokens.length ? tokens[i + 1] : null;
          // Aspek progresif: 'is reading', 'are eating'
          if (nextTok != null && nextTok.endsWith('ing')) {
            if (buffer.isNotEmpty) buffer.write(' ');
            if (to == TranslationVariant.id) {
              buffer.write('sedang');
            } else if (to == TranslationVariant.jvNgoko) {
              buffer.write('lagi');
            } else if (to == TranslationVariant.jvKrama) {
              buffer.write('nembe');
            }
            anyFound = true;
          }
          // Zero-copula dalam bahasa Indonesia & Jawa untuk posisi predikatif/inversi
          i++;
          continue;
        }
      }

      // 0d. Penanganan frasa posesif bahasa Inggris (mis. 'my book' -> 'bukuku', 'your name' -> 'jenengmu')
      if (!matched &&
          from == TranslationVariant.en &&
          (currentToken == 'my' || currentToken == 'your') &&
          i + 1 < tokens.length) {
        final nextTok = tokens[i + 1];
        if (!_kFunctionalGrammar.containsKey(nextTok) &&
            !_kClauseBoundaries.contains(nextTok)) {
          var nounTrans = _lookup(nextTok, from, to, register: effectiveRegister);
          nounTrans ??= _tryMorphology(nextTok, from, to, register: effectiveRegister);
          if (nounTrans != null) {
            if (buffer.isNotEmpty) buffer.write(' ');
            if (currentToken == 'my') {
              if (to == TranslationVariant.id) {
                buffer.write('$nounTrans-ku');
              } else if (to == TranslationVariant.jvNgoko) {
                buffer.write('$nounTrans-ku');
              } else if (to == TranslationVariant.jvKrama) {
                buffer.write('$nounTrans kula');
              } else {
                buffer.write('my $nounTrans');
              }
            } else {
              if (to == TranslationVariant.id) {
                buffer.write('$nounTrans-mu');
              } else if (to == TranslationVariant.jvNgoko) {
                buffer.write('$nounTrans-mu');
              } else if (to == TranslationVariant.jvKrama) {
                buffer.write('$nounTrans panjenengan');
              } else {
                buffer.write('your $nounTrans');
              }
            }
            anyFound = true;
            i += 2;
            matched = true;
          }
        }
      }

      // Khusus verba 'reading' setelah kopula progresif: gunakan verba 'read' (Maca/Maos), bukan nomina 'Wacan'
      final effectiveSingleToken = (from == TranslationVariant.en &&
              currentToken == 'reading' &&
              prevTok != null &&
              const {'is', 'am', 'are', 'was', 'were'}.contains(prevTok))
          ? 'read'
          : currentToken;

      // 1. Coba frasa dari panjang maksimum mundur ke satu token
      if (!matched) {
        for (int len = tokens.length - i; len >= 1; len--) {
          final phrase = len == 1
              ? effectiveSingleToken
              : tokens.sublist(i, i + len).join(' ');
          final target = _lookup(phrase, from, to, register: effectiveRegister);
          if (target != null) {
            if (buffer.isNotEmpty) buffer.write(' ');
            buffer.write(target);
            anyFound = true;
            i += len;
            matched = true;
            break;
          }
        }
      }

      // 2. Jika token tunggal belum cocok leksikal, uji aturan morfologi
      if (!matched) {
        final morphTarget = _tryMorphology(
          effectiveSingleToken,
          from,
          to,
          register: effectiveRegister,
        );
        if (morphTarget != null) {
          if (buffer.isNotEmpty) buffer.write(' ');
          buffer.write(morphTarget);
          anyFound = true;
          i++;
          matched = true;
        }
      }

      // 3. Fallback: angka tetap dipertahankan alami; kata tak dikenal ditandai [?]
      if (!matched) {
        if (buffer.isNotEmpty) buffer.write(' ');
        if (RegExp(r'^\d+([:.]\d+)?$').hasMatch(tokens[i])) {
          buffer.write(tokens[i]);
          anyFound = true;
        } else {
          buffer.write('${tokens[i]}[?]');
          hasUnknown = true;
        }
        i++;
      }
    }

    if (!anyFound) {
      return const NotFound();
    }

    final notes = <String>[];
    if (hasUnknown) {
      notes.add(
        'Sebagian kata belum tersedia di kamus offline (ditandai [?]). Gunakan Terjemahkan dengan AI untuk hasil kontekstual penuh.',
      );
    }
    if (usedAmbiguousThirdFallback) {
      notes.add(
        'Subjek orang ketiga ("dia/mereka") belum menjelaskan tingkat penghormatan, sehingga Krama Lugu dipakai sebagai pilihan aman. Gunakan Krama Inggil bila merujuk orang yang lebih tua/dihormati.',
      );
    }

    return Found(
      buffer.toString(),
      note: notes.isEmpty ? null : notes.join(' '),
      appliedRegister: to == TranslationVariant.jvKrama
          ? lastAppliedRegister
          : null,
    );
  }

  // ─── TranslationService API ───────────────────────────────────────────────

  /// Varian terjemahan dengan pemilihan tingkat tutur [SpeechRegister] eksplisit
  /// (mis. [SpeechRegister.kramaLugu] untuk diri sendiri, [SpeechRegister.kramaInggil]
  /// untuk orang yang dihormati, atau [SpeechRegister.kramaAndhap] saat diri sendiri
  /// bertindak kepada orang yang dihormati).
  Future<TranslationResult> translateWithRegister({
    required String text,
    required TranslationVariant from,
    required TranslationVariant to,
    SpeechRegister? register,
  }) async {
    final normalizedInput = normalize(text);
    if (normalizedInput.isEmpty) {
      return const NotFound();
    }
    if (from == to && register == null) {
      return Found(text);
    }

    // Cek frasa majemuk polisemi tetap (exact match)
    if (from == TranslationVariant.id) {
      final compound = _kPolysemicCompounds[normalizedInput];
      if (compound != null && compound.containsKey(to)) {
        return Found(
          compound[to]!,
          appliedRegister: to == TranslationVariant.jvKrama ? register : null,
        );
      }
    }

    final exactEntry = _lookupEntry(normalizedInput, from);
    final exactTarget = _lookup(normalizedInput, from, to, register: register);
    if (exactTarget != null) {
      return Found(
        exactTarget,
        note: _standaloneAmbiguityNote(
          normalizedInput,
          from,
          to,
          entry: exactEntry,
          register: register,
        ),
        appliedRegister: to == TranslationVariant.jvKrama ? register : null,
      );
    }

    // Fallback aman untuk kata polisemi tunggal yang tidak memiliki entri statis tunggal
    // (mis. 'kali', 'pukul', 'keras', 'ringan') disertai catatan ambiguitas jujur.
    if (from == TranslationVariant.id &&
        _kPolysemousWords.contains(normalizedInput)) {
      final polySingle = _resolvePolysemy(
        normalizedInput,
        0,
        [normalizedInput],
        from,
        to,
        register,
      );
      if (polySingle != null) {
        return Found(
          polySingle,
          note: _standaloneAmbiguityNote(
            normalizedInput,
            from,
            to,
            register: register,
          ),
          appliedRegister: to == TranslationVariant.jvKrama ? register : null,
        );
      }
    }

    return _translateByTokens(
      normalizedInput,
      from,
      to,
      forcedRegister: register,
    );
  }

  @override
  Future<TranslationResult> translate({
    required String text,
    required TranslationVariant from,
    required TranslationVariant to,
  }) async {
    return translateWithRegister(text: text, from: from, to: to);
  }

  @override
  List<String> examples(TranslationVariant from, {int max = 4}) {
    if (max <= 0) return const [];
    return entries.take(max).map((e) => e.getVariant(from)).toList();
  }
}
