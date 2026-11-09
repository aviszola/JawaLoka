import '../features/translator/domain/translation_models.dart';

// DATA CONTOH, DRAF belum divalidasi penutur Jawa

/// Model entri kamus terjemahan dwiarah multi-varian JawaLoka.
class TranslationEntry {
  final String id;
  final String en;
  final String jvNgoko;
  final String jvKrama;

  const TranslationEntry({
    required this.id,
    required this.en,
    required this.jvNgoko,
    required this.jvKrama,
  });

  /// Mengambil teks sesuai varian bahasa yang diminta.
  String getVariant(TranslationVariant variant) {
    switch (variant) {
      case TranslationVariant.id:
        return id;
      case TranslationVariant.en:
        return en;
      case TranslationVariant.jvNgoko:
        return jvNgoko;
      case TranslationVariant.jvKrama:
        return jvKrama;
    }
  }
}

/// Daftar entri kamus terjemahan contoh dan draf resmi aplikasi JawaLoka.
/// Total: 19 entri tanpa duplikasi identifier/makna.
const List<TranslationEntry> kTranslationEntries = [
  TranslationEntry(
    id: 'Selamat pagi',
    en: 'Good morning',
    jvNgoko: 'Sugeng enjing',
    jvKrama: 'Sugeng enjing',
  ),
  TranslationEntry(
    id: 'Selamat siang',
    en: 'Good afternoon',
    jvNgoko: 'Sugeng siang',
    jvKrama: 'Sugeng siang',
  ),
  TranslationEntry(
    id: 'Selamat sore',
    en: 'Good evening',
    jvNgoko: 'Sugeng sonten',
    jvKrama: 'Sugeng sonten',
  ),
  TranslationEntry(
    id: 'Terima kasih',
    en: 'Thank you',
    jvNgoko: 'Matur nuwun',
    jvKrama: 'Matur nuwun',
  ),
  TranslationEntry(
    id: 'Apa kabar',
    en: 'How are you',
    jvNgoko: 'Piye kabare',
    jvKrama: 'Pripun kabaripun',
  ),
  TranslationEntry(
    id: 'Saya tidak mengerti',
    en: "I don't understand",
    jvNgoko: 'Aku ora ngerti',
    jvKrama: 'Kula mboten mangertos',
  ),
  TranslationEntry(
    id: 'Ya',
    en: 'Yes',
    jvNgoko: 'Iya',
    jvKrama: 'Inggih',
  ),
  TranslationEntry(
    id: 'Tidak',
    en: 'No',
    jvNgoko: 'Ora',
    jvKrama: 'Mboten',
  ),
  TranslationEntry(
    id: 'Saya',
    en: 'I',
    jvNgoko: 'Aku',
    jvKrama: 'Kula',
  ),
  TranslationEntry(
    id: 'Kamu',
    en: 'You',
    jvNgoko: 'Kowe',
    jvKrama: 'Panjenengan',
  ),
  TranslationEntry(
    id: 'Makan',
    en: 'Eat',
    jvNgoko: 'Mangan',
    jvKrama: 'Nedha',
  ),
  TranslationEntry(
    id: 'Minum',
    en: 'Drink',
    jvNgoko: 'Ngombe',
    jvKrama: 'Ngunjuk',
  ),
  TranslationEntry(
    id: 'Tidur',
    en: 'Sleep',
    jvNgoko: 'Turu',
    jvKrama: 'Sare',
  ),
  TranslationEntry(
    id: 'Rumah',
    en: 'House',
    jvNgoko: 'Omah',
    jvKrama: 'Griya',
  ),
  TranslationEntry(
    id: 'Air',
    en: 'Water',
    jvNgoko: 'Banyu',
    jvKrama: 'Toya',
  ),
  TranslationEntry(
    id: 'Halo',
    en: 'Hello',
    jvNgoko: 'Halo',
    jvKrama: 'Halo',
  ),
  // Entri tambahan dari VocabWord.sampleWords (id 'Laut', 'Tanah', 'Langit')
  // Omah (Rumah) dan Banyu (Air) dilewati karena sudah ada pada entri di atas.
  TranslationEntry(
    id: 'Laut',
    en: 'Sea',
    jvNgoko: 'Segara',
    jvKrama: 'Segara', // DATA CONTOH, DRAF: krama sama dengan ngoko
  ),
  TranslationEntry(
    id: 'Tanah',
    en: 'Ground',
    jvNgoko: 'Lemah',
    jvKrama: 'Lemah', // DATA CONTOH, DRAF: krama sama dengan ngoko
  ),
  TranslationEntry(
    id: 'Langit',
    en: 'Sky',
    jvNgoko: 'Langit',
    jvKrama: 'Langit', // DATA CONTOH, DRAF: krama sama dengan ngoko
  ),
];

