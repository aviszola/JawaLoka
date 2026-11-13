import '../features/translator/domain/translation_models.dart';
import 'translation_entries_extended.dart';

// ─── CATATAN DATA ─────────────────────────────────────────────────────────────
// Entri awal disusun dengan bantuan AI dan belum diverifikasi penutur Jawa;
// entri tambahan berasal dari Starter Kit (lihat file extended).
// kJvPendingKeys tidak dipakai di sini (bukan teks UI), tanda baku validasi ada
// di test/integrity/data_integrity_test.dart.
// ─────────────────────────────────────────────────────────────────────────────

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

/// Daftar entri kamus terjemahan resmi aplikasi JawaLoka.
///
/// Urutan 4 entri pertama dipakai oleh contoh frasa di UI dan assertions test —
/// jangan mengubah urutan entri [0]–[3].
///
/// Kategori yang dicakup (dalam urutan):
///   1. Sapaan & ungkapan umum
///   2. Kata ganti orang
///   3. Jawaban & respons dasar
///   4. Kata kerja harian
///   5. Kata benda — rumah & lingkungan
///   6. Kata benda — alam
///   7. Kata benda — makanan & minuman
///   8. Kata benda — transportasi
///   9. Kata benda — tubuh
///  10. Kata sifat
///  11. Angka dan bilangan
///  12. Waktu dan hari
///  13. Keluarga
///  14. Pendidikan
///  15. Kesehatan
///  16. Percakapan & ungkapan praktis
const List<TranslationEntry> kTranslationEntries = [
  // ── 1. Sapaan & ungkapan umum ───────────────────────────────────────────────
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
  // index [4] dan seterusnya bebas diurutkan ulang
  // Kata-kata Jawa umum yang sering digunakan
  // DRAF (belum divalidasi penutur Jawa): Pasangan kata dasar bahasa Indonesia ke Jawa
  TranslationEntry(
    id: 'Akan',
    en: 'Will',
    jvNgoko: 'Arep',
    jvKrama: 'Badhe',
  ),
  TranslationEntry(
    id: 'Jauh',
    en: 'Far',
    jvNgoko: 'Adoh',
    jvKrama: 'Tebih',
  ),
  TranslationEntry(
    id: 'Dekat',
    en: 'Near',
    jvNgoko: 'Cedhak',
    jvKrama: 'Celak',
  ),
  TranslationEntry(
    id: 'Punya',
    en: 'Have',
    jvNgoko: 'Duwe',
    jvKrama: 'Gadhah',
  ),
  TranslationEntry(
    id: 'Mana',
    en: 'Which',
    jvNgoko: 'Endi',
    jvKrama: 'Pundi',
  ),
  TranslationEntry(
    id: 'Harga',
    en: 'Price',
    jvNgoko: 'Rega',
    jvKrama: 'Rega', // DRAF: varian krama belum diverifikasi (kemungkinan 'Regi')
  ),
  TranslationEntry(
    id: 'Sangat',
    en: 'Very',
    jvNgoko: 'Banget',
    jvKrama: 'Sanget',
  ),
  TranslationEntry(
    id: 'Selamat malam',
    en: 'Good night',
    jvNgoko: 'Sugeng dalu',
    jvKrama: 'Sugeng dalu',
  ),
  TranslationEntry(
    id: 'Halo',
    en: 'Hello',
    jvNgoko: 'Halo',
    jvKrama: 'Halo',
  ),
  TranslationEntry(
    id: 'Selamat datang',
    en: 'Welcome',
    jvNgoko: 'Sugeng rawuh',
    jvKrama: 'Sugeng rawuh',
  ),
  TranslationEntry(
    id: 'Sampai jumpa',
    en: 'Goodbye',
    jvNgoko: 'Sugeng tindak',
    jvKrama: 'Sugeng tindak',
  ),
  TranslationEntry(
    id: 'Permisi',
    en: 'Excuse me',
    jvNgoko: 'Nuwun sewu',
    jvKrama: 'Nuwun sewu',
  ),
  TranslationEntry(
    id: 'Maaf',
    en: 'Sorry',
    jvNgoko: 'Njaluk ngapura',
    jvKrama: 'Nyuwun pangapunten',
  ),
  TranslationEntry(
    id: 'Apa kabar',
    en: 'How are you',
    jvNgoko: 'Piye kabare',
    jvKrama: 'Pripun kabaripun',
  ),
  TranslationEntry(
    id: 'Baik-baik saja',
    en: 'I am fine',
    jvNgoko: 'Apik-apik wae',
    jvKrama: 'Sae-sae kemawon',
  ),
  TranslationEntry(
    id: 'Senang bertemu dengan Anda',
    en: 'Nice to meet you',
    jvNgoko: 'Seneng ketemu karo sliramu',
    jvKrama: 'Remen pinanggih kalian panjenengan',
  ),
  TranslationEntry(
    id: 'Nama saya',
    en: 'My name is',
    jvNgoko: 'Jenengku',
    jvKrama: 'Nami kula',
  ),

  // ── 2. Kata ganti orang ─────────────────────────────────────────────────────
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
    id: 'Dia',
    en: 'He or she',
    jvNgoko: 'Dheweke',
    jvKrama: 'Piyambakipun',
  ),
  TranslationEntry(
    id: 'Kami',
    en: 'We',
    jvNgoko: 'Aku kabeh',
    jvKrama: 'Kula sedaya',
  ),
  TranslationEntry(
    id: 'Mereka',
    en: 'They',
    jvNgoko: 'Wong-wong iku',
    jvKrama: 'Tiyang-tiyang menika',
  ),
  TranslationEntry(
    id: 'Ini',
    en: 'This',
    jvNgoko: 'Iki',
    jvKrama: 'Menika',
  ),
  TranslationEntry(
    id: 'Itu',
    en: 'That',
    jvNgoko: 'Iku',
    jvKrama: 'Punika',
  ),

  // ── 3. Jawaban & respons dasar ──────────────────────────────────────────────
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
    id: 'Belum',
    en: 'Not yet',
    jvNgoko: 'Durung',
    jvKrama: 'Dereng',
  ),
  TranslationEntry(
    id: 'Sudah',
    en: 'Already',
    jvNgoko: 'Wis',
    jvKrama: 'Sampun',
  ),
  TranslationEntry(
    id: 'Boleh',
    en: 'May',
    jvNgoko: 'Oleh',
    jvKrama: 'Pareng',
  ),
  TranslationEntry(
    id: 'Tidak boleh',
    en: 'Not allowed',
    jvNgoko: 'Ora oleh',
    jvKrama: 'Mboten pareng',
  ),
  TranslationEntry(
    id: 'Saya tidak mengerti',
    en: "I don't understand",
    jvNgoko: 'Aku ora ngerti',
    jvKrama: 'Kula mboten mangertos',
  ),
  TranslationEntry(
    id: 'Saya mengerti',
    en: 'I understand',
    jvNgoko: 'Aku ngerti',
    jvKrama: 'Kula mangertos',
  ),
  TranslationEntry(
    id: 'Tolong',
    en: 'Please',
    jvNgoko: 'Tulung',
    jvKrama: 'Tulung',
  ),
  TranslationEntry(
    id: 'Benar',
    en: 'Correct',
    jvNgoko: 'Bener',
    jvKrama: 'Leres',
  ),
  TranslationEntry(
    id: 'Salah',
    en: 'Wrong',
    jvNgoko: 'Salah',
    jvKrama: 'Lepat',
  ),

  // ── 4. Kata kerja harian ────────────────────────────────────────────────────
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
    id: 'Bangun',
    en: 'Wake up',
    jvNgoko: 'Tangi',
    jvKrama: 'Tangi',
  ),
  TranslationEntry(
    id: 'Pergi',
    en: 'Go',
    jvNgoko: 'Lunga',
    jvKrama: 'Tindak',
  ),
  TranslationEntry(
    id: 'Datang',
    en: 'Come',
    jvNgoko: 'Teka',
    jvKrama: 'Rawuh',
  ),
  TranslationEntry(
    id: 'Pulang',
    en: 'Return home',
    jvNgoko: 'Mulih',
    jvKrama: 'Wangsul',
  ),
  TranslationEntry(
    id: 'Duduk',
    en: 'Sit',
    jvNgoko: 'Lungguh',
    jvKrama: 'Lenggah',
  ),
  TranslationEntry(
    id: 'Berdiri',
    en: 'Stand',
    jvNgoko: 'Ngadeg',
    jvKrama: 'Ngadeg',
  ),
  TranslationEntry(
    id: 'Berjalan',
    en: 'Walk',
    jvNgoko: 'Mlaku',
    jvKrama: 'Mlampah',
  ),
  TranslationEntry(
    id: 'Lari',
    en: 'Run',
    jvNgoko: 'Mlayu',
    jvKrama: 'Mlajeng',
  ),
  TranslationEntry(
    id: 'Berbicara',
    en: 'Speak',
    jvNgoko: 'Ngomong',
    jvKrama: 'Matur',
  ),
  TranslationEntry(
    id: 'Mendengar',
    en: 'Listen',
    jvNgoko: 'Krungu',
    jvKrama: 'Mireng',
  ),
  TranslationEntry(
    id: 'Melihat',
    en: 'See',
    jvNgoko: 'Ndelok',
    jvKrama: 'Ningali',
  ),
  TranslationEntry(
    id: 'Membeli',
    en: 'Buy',
    jvNgoko: 'Tuku',
    jvKrama: 'Tumbas',
  ),
  TranslationEntry(
    id: 'Menjual',
    en: 'Sell',
    jvNgoko: 'Adol',
    jvKrama: 'Sade',
  ),
  TranslationEntry(
    id: 'Bekerja',
    en: 'Work',
    jvNgoko: 'Nyambut gawe',
    jvKrama: 'Nyambut damel',
  ),
  TranslationEntry(
    id: 'Belajar',
    en: 'Study',
    jvNgoko: 'Sinau',
    jvKrama: 'Sinau',
  ),
  TranslationEntry(
    id: 'Menulis',
    en: 'Write',
    jvNgoko: 'Nulis',
    jvKrama: 'Nyerat',
  ),
  TranslationEntry(
    id: 'Membaca',
    en: 'Read',
    jvNgoko: 'Maca',
    jvKrama: 'Maos',
  ),
  TranslationEntry(
    id: 'Bermain',
    en: 'Play',
    jvNgoko: 'Dolanan',
    jvKrama: 'Dolanan',
  ),
  TranslationEntry(
    id: 'Memasak',
    en: 'Cook',
    jvNgoko: 'Masak',
    jvKrama: 'Masak',
  ),
  TranslationEntry(
    id: 'Mencuci',
    en: 'Wash',
    jvNgoko: 'Umbah-umbah',
    jvKrama: 'Umbah-umbah',
  ),
  TranslationEntry(
    id: 'Membantu',
    en: 'Help',
    jvNgoko: 'Nulung',
    jvKrama: 'Mbiyantu',
  ),
  TranslationEntry(
    id: 'Mencari',
    en: 'Search',
    jvNgoko: 'Goleki',
    jvKrama: 'Pados',
  ),
  TranslationEntry(
    id: 'Menemukan',
    en: 'Find',
    jvNgoko: 'Ketemu',
    jvKrama: 'Kepanggih',
  ),
  TranslationEntry(
    id: 'Memberi',
    en: 'Give',
    jvNgoko: 'Menehi',
    jvKrama: 'Paring',
  ),
  TranslationEntry(
    id: 'Mengambil',
    en: 'Take',
    jvNgoko: 'Njupuk',
    jvKrama: 'Mendhet',
  ),
  TranslationEntry(
    id: 'Tahu',
    en: 'Know',
    jvNgoko: 'Ngerti',
    jvKrama: 'Mangertos',
  ),
  TranslationEntry(
    id: 'Mau',
    en: 'Want',
    jvNgoko: 'Gelem',
    jvKrama: 'Kersa',
  ),
  TranslationEntry(
    id: 'Bisa',
    en: 'Can',
    jvNgoko: 'Iso',
    jvKrama: 'Saged',
  ),
  TranslationEntry(
    id: 'Harus',
    en: 'Must',
    jvNgoko: 'Kudu',
    jvKrama: 'Kedah',
  ),

  // ── 5. Kata benda — rumah & lingkungan sekitar ──────────────────────────────
  TranslationEntry(
    id: 'Rumah',
    en: 'House',
    jvNgoko: 'Omah',
    jvKrama: 'Griya',
  ),
  TranslationEntry(
    id: 'Pintu',
    en: 'Door',
    jvNgoko: 'Lawang',
    jvKrama: 'Konten',
  ),
  TranslationEntry(
    id: 'Jendela',
    en: 'Window',
    jvNgoko: 'Jendhela',
    jvKrama: 'Jendhela',
  ),
  TranslationEntry(
    id: 'Kursi',
    en: 'Chair',
    jvNgoko: 'Kursi',
    jvKrama: 'Kursi',
  ),
  TranslationEntry(
    id: 'Meja',
    en: 'Table',
    jvNgoko: 'Meja',
    jvKrama: 'Meja',
  ),
  TranslationEntry(
    id: 'Tempat tidur',
    en: 'Bed',
    jvNgoko: 'Amben',
    jvKrama: 'Pasarean',
  ),
  TranslationEntry(
    id: 'Dapur',
    en: 'Kitchen',
    jvNgoko: 'Pawon',
    jvKrama: 'Pawon',
  ),
  TranslationEntry(
    id: 'Kamar mandi',
    en: 'Bathroom',
    jvNgoko: 'Kamar mandi',
    jvKrama: 'Kamar mandi',
  ),
  TranslationEntry(
    id: 'Kebun',
    en: 'Garden',
    jvNgoko: 'Kebon',
    jvKrama: 'Kebon',
  ),
  TranslationEntry(
    id: 'Pasar',
    en: 'Market',
    jvNgoko: 'Pasar',
    jvKrama: 'Peken',
  ),
  TranslationEntry(
    id: 'Desa',
    en: 'Village',
    jvNgoko: 'Desa',
    jvKrama: 'Dhusun',
  ),
  TranslationEntry(
    id: 'Kota',
    en: 'City',
    jvNgoko: 'Kutha',
    jvKrama: 'Kitha',
  ),
  TranslationEntry(
    id: 'Jalan',
    en: 'Road',
    jvNgoko: 'Dalan',
    jvKrama: 'Margi',
  ),
  TranslationEntry(
    id: 'Sekolah',
    en: 'School',
    jvNgoko: 'Sekolah',
    jvKrama: 'Sekolah',
  ),
  TranslationEntry(
    id: 'Kantor',
    en: 'Office',
    jvNgoko: 'Kantor',
    jvKrama: 'Kantor',
  ),
  TranslationEntry(
    id: 'Toko',
    en: 'Shop',
    jvNgoko: 'Toko',
    jvKrama: 'Toko',
  ),

  // ── 6. Kata benda — alam ────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Air',
    en: 'Water',
    jvNgoko: 'Banyu',
    jvKrama: 'Toya',
  ),
  TranslationEntry(
    id: 'Api',
    en: 'Fire',
    jvNgoko: 'Geni',
    jvKrama: 'Latu',
  ),
  TranslationEntry(
    id: 'Tanah',
    en: 'Ground',
    jvNgoko: 'Lemah',
    jvKrama: 'Siti',
  ),
  TranslationEntry(
    id: 'Laut',
    en: 'Sea',
    jvNgoko: 'Segara',
    jvKrama: 'Seganten',
  ),
  TranslationEntry(
    id: 'Langit',
    en: 'Sky',
    jvNgoko: 'Langit',
    jvKrama: 'Langit',
  ),
  TranslationEntry(
    id: 'Matahari',
    en: 'Sun',
    jvNgoko: 'Srengenge',
    jvKrama: 'Surya',
  ),
  TranslationEntry(
    id: 'Bulan',
    en: 'Moon',
    jvNgoko: 'Wulan',
    jvKrama: 'Wulan',
  ),
  TranslationEntry(
    id: 'Bintang',
    en: 'Star',
    jvNgoko: 'Lintang',
    jvKrama: 'Lintang',
  ),
  TranslationEntry(
    id: 'Hujan',
    en: 'Rain',
    jvNgoko: 'Udan',
    jvKrama: 'Jawah',
  ),
  TranslationEntry(
    id: 'Angin',
    en: 'Wind',
    jvNgoko: 'Angin',
    jvKrama: 'Angin',
  ),
  TranslationEntry(
    id: 'Pohon',
    en: 'Tree',
    jvNgoko: 'Wit',
    jvKrama: 'Wit',
  ),
  TranslationEntry(
    id: 'Bunga',
    en: 'Flower',
    jvNgoko: 'Kembang',
    jvKrama: 'Sekar',
  ),
  TranslationEntry(
    id: 'Sawah',
    en: 'Rice field',
    jvNgoko: 'Sawah',
    jvKrama: 'Sabin',
  ),
  TranslationEntry(
    id: 'Sungai',
    en: 'River',
    jvNgoko: 'Kali',
    jvKrama: 'Lepen',
  ),
  TranslationEntry(
    id: 'Gunung',
    en: 'Mountain',
    jvNgoko: 'Gunung',
    jvKrama: 'Redi',
  ),
  TranslationEntry(
    id: 'Hutan',
    en: 'Forest',
    jvNgoko: 'Alas',
    jvKrama: 'Wana',
  ),

  // ── 7. Makanan & minuman ────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Nasi',
    en: 'Rice',
    jvNgoko: 'Sega',
    jvKrama: 'Sekul',
  ),
  TranslationEntry(
    id: 'Ayam',
    en: 'Chicken',
    jvNgoko: 'Pitik',
    jvKrama: 'Ayam',
  ),
  TranslationEntry(
    id: 'Ikan',
    en: 'Fish',
    jvNgoko: 'Iwak',
    jvKrama: 'Ulam',
  ),
  TranslationEntry(
    id: 'Sayuran',
    en: 'Vegetables',
    jvNgoko: 'Janganan',
    jvKrama: 'Janganan',
  ),
  TranslationEntry(
    id: 'Buah',
    en: 'Fruit',
    jvNgoko: 'Woh-wohan',
    jvKrama: 'Woh-wohan',
  ),
  TranslationEntry(
    id: 'Gula',
    en: 'Sugar',
    jvNgoko: 'Gula',
    jvKrama: 'Gendhis',
  ),
  TranslationEntry(
    id: 'Garam',
    en: 'Salt',
    jvNgoko: 'Uyah',
    jvKrama: 'Sarem',
  ),
  TranslationEntry(
    id: 'Susu',
    en: 'Milk',
    jvNgoko: 'Susu',
    jvKrama: 'Susu',
  ),
  TranslationEntry(
    id: 'Kopi',
    en: 'Coffee',
    jvNgoko: 'Kopi',
    jvKrama: 'Kopi',
  ),
  TranslationEntry(
    id: 'Teh',
    en: 'Tea',
    jvNgoko: 'Teh',
    jvKrama: 'Teh',
  ),
  TranslationEntry(
    id: 'Telur',
    en: 'Egg',
    jvNgoko: 'Endhog',
    jvKrama: 'Tigan',
  ),
  TranslationEntry(
    id: 'Roti',
    en: 'Bread',
    jvNgoko: 'Roti',
    jvKrama: 'Roti',
  ),
  TranslationEntry(
    id: 'Daging',
    en: 'Meat',
    jvNgoko: 'Daging',
    jvKrama: 'Daging',
  ),
  TranslationEntry(
    id: 'Minyak',
    en: 'Oil',
    jvNgoko: 'Lenga',
    jvKrama: 'Lenga',
  ),
  TranslationEntry(
    id: 'Nasi goreng',
    en: 'Fried rice',
    jvNgoko: 'Sega goreng',
    jvKrama: 'Sekul goreng',
  ),
  TranslationEntry(
    id: 'Tempe',
    en: 'Tempeh',
    jvNgoko: 'Tempe',
    jvKrama: 'Tempe',
  ),
  TranslationEntry(
    id: 'Tempe goreng',
    en: 'Fried tempeh',
    jvNgoko: 'Tempe goreng',
    jvKrama: 'Tempe goreng',
  ),

  // ── 8. Transportasi ─────────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Motor',
    en: 'Motorcycle',
    jvNgoko: 'Motor',
    jvKrama: 'Motor',
  ),
  TranslationEntry(
    id: 'Mobil',
    en: 'Car',
    jvNgoko: 'Mobil',
    jvKrama: 'Mobil',
  ),
  TranslationEntry(
    id: 'Bus',
    en: 'Bus',
    jvNgoko: 'Bus',
    jvKrama: 'Bus',
  ),
  TranslationEntry(
    id: 'Kereta',
    en: 'Train',
    jvNgoko: 'Sepur',
    jvKrama: 'Sepur',
  ),
  TranslationEntry(
    id: 'Sepeda',
    en: 'Bicycle',
    jvNgoko: 'Pit',
    jvKrama: 'Pit',
  ),
  TranslationEntry(
    id: 'Pesawat',
    en: 'Airplane',
    jvNgoko: 'Montor mabur',
    jvKrama: 'Montor mabur',
  ),
  TranslationEntry(
    id: 'Kapal',
    en: 'Ship',
    jvNgoko: 'Prahu',
    jvKrama: 'Baita',
  ),

  // ── 9. Tubuh ─────────────────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Kepala',
    en: 'Head',
    jvNgoko: 'Sirah',
    jvKrama: 'Mustaka',
  ),
  TranslationEntry(
    id: 'Mata',
    en: 'Eye',
    jvNgoko: 'Mripat',
    jvKrama: 'Paningal',
  ),
  TranslationEntry(
    id: 'Hidung',
    en: 'Nose',
    jvNgoko: 'Irung',
    jvKrama: 'Grana',
  ),
  TranslationEntry(
    id: 'Mulut',
    en: 'Mouth',
    jvNgoko: 'Cangkem',
    jvKrama: 'Tutuk',
  ),
  TranslationEntry(
    id: 'Telinga',
    en: 'Ear',
    jvNgoko: 'Kuping',
    jvKrama: 'Talingan',
  ),
  TranslationEntry(
    id: 'Tangan',
    en: 'Hand',
    jvNgoko: 'Tangan',
    jvKrama: 'Asta',
  ),
  TranslationEntry(
    id: 'Kaki',
    en: 'Foot',
    jvNgoko: 'Sikil',
    jvKrama: 'Suku',
  ),
  TranslationEntry(
    id: 'Perut',
    en: 'Stomach',
    jvNgoko: 'Weteng',
    jvKrama: 'Padharan',
  ),
  TranslationEntry(
    id: 'Jantung',
    en: 'Heart',
    jvNgoko: 'Jantung',
    jvKrama: 'Jantung',
  ),
  TranslationEntry(
    id: 'Gigi',
    en: 'Tooth',
    jvNgoko: 'Untu',
    jvKrama: 'Waja',
  ),

  // ── 10. Kata sifat ──────────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Besar',
    en: 'Big',
    jvNgoko: 'Gedhe',
    jvKrama: 'Ageng',
  ),
  TranslationEntry(
    id: 'Kecil',
    en: 'Small',
    jvNgoko: 'Cilik',
    jvKrama: 'Alit',
  ),
  TranslationEntry(
    id: 'Panjang',
    en: 'Long',
    jvNgoko: 'Dawa',
    jvKrama: 'Panjang',
  ),
  TranslationEntry(
    id: 'Pendek',
    en: 'Short',
    jvNgoko: 'Cendhek',
    jvKrama: 'Cendhak',
  ),
  TranslationEntry(
    id: 'Tinggi',
    en: 'Tall',
    jvNgoko: 'Dhuwur',
    jvKrama: 'Inggil',
  ),
  TranslationEntry(
    id: 'Rendah',
    en: 'Low',
    jvNgoko: 'Asor',
    jvKrama: 'Asor',
  ),
  TranslationEntry(
    id: 'Panas',
    en: 'Hot',
    jvNgoko: 'Panas',
    jvKrama: 'Panas',
  ),
  TranslationEntry(
    id: 'Dingin',
    en: 'Cold',
    jvNgoko: 'Adhem',
    jvKrama: 'Asrep',
  ),
  TranslationEntry(
    id: 'Bagus',
    en: 'Good',
    jvNgoko: 'Apik',
    jvKrama: 'Sae',
  ),
  TranslationEntry(
    id: 'Jelek',
    en: 'Bad',
    jvNgoko: 'Elek',
    jvKrama: 'Awon',
  ),
  TranslationEntry(
    id: 'Cantik',
    en: 'Beautiful',
    jvNgoko: 'Ayu',
    jvKrama: 'Ayu',
  ),
  TranslationEntry(
    id: 'Tampan',
    en: 'Handsome',
    jvNgoko: 'Bagus',
    jvKrama: 'Bagus',
  ),
  TranslationEntry(
    id: 'Senang',
    en: 'Happy',
    jvNgoko: 'Seneng',
    jvKrama: 'Remen',
  ),
  TranslationEntry(
    id: 'Sedih',
    en: 'Sad',
    jvNgoko: 'Sedhih',
    jvKrama: 'Sedhih',
  ),
  TranslationEntry(
    id: 'Lelah',
    en: 'Tired',
    jvNgoko: 'Kesel',
    jvKrama: 'Sayah',
  ),
  TranslationEntry(
    id: 'Lapar',
    en: 'Hungry',
    jvNgoko: 'Luwe',
    jvKrama: 'Luwe',
  ),
  TranslationEntry(
    id: 'Haus',
    en: 'Thirsty',
    jvNgoko: 'Ngelak',
    jvKrama: 'Ngelak',
  ),
  TranslationEntry(
    id: 'Mahal',
    en: 'Expensive',
    jvNgoko: 'Larang',
    jvKrama: 'Awis',
  ),
  TranslationEntry(
    id: 'Murah',
    en: 'Cheap',
    jvNgoko: 'Murah',
    jvKrama: 'Mirah',
  ),
  TranslationEntry(
    id: 'Baru',
    en: 'New',
    jvNgoko: 'Anyar',
    jvKrama: 'Enggal',
  ),
  TranslationEntry(
    id: 'Lama',
    en: 'Old',
    jvNgoko: 'Lawas',
    jvKrama: 'Sepuh',
  ),
  TranslationEntry(
    id: 'Cepat',
    en: 'Fast',
    jvNgoko: 'Cepet',
    jvKrama: 'Gancang',
  ),
  TranslationEntry(
    id: 'Lambat',
    en: 'Slow',
    jvNgoko: 'Alon',
    jvKrama: 'Aris',
  ),
  TranslationEntry(
    id: 'Kuat',
    en: 'Strong',
    jvNgoko: 'Kuat',
    jvKrama: 'Kiyat',
  ),
  TranslationEntry(
    id: 'Lemah',
    en: 'Weak',
    jvNgoko: 'Ringkih',
    jvKrama: 'Ringkih',
  ),
  TranslationEntry(
    id: 'Bersih',
    en: 'Clean',
    jvNgoko: 'Resik',
    jvKrama: 'Resik',
  ),
  TranslationEntry(
    id: 'Kotor',
    en: 'Dirty',
    jvNgoko: 'Reged',
    jvKrama: 'Reged',
  ),
  TranslationEntry(
    id: 'Penuh',
    en: 'Full',
    jvNgoko: 'Kebak',
    jvKrama: 'Kebak',
  ),
  TranslationEntry(
    id: 'Kosong',
    en: 'Empty',
    jvNgoko: 'Suwung',
    jvKrama: 'Suwung',
  ),

  // ── 11. Angka dan bilangan ──────────────────────────────────────────────────
  TranslationEntry(
    id: 'Satu',
    en: 'One',
    jvNgoko: 'Siji',
    jvKrama: 'Setunggal',
  ),
  TranslationEntry(
    id: 'Dua',
    en: 'Two',
    jvNgoko: 'Loro',
    jvKrama: 'Kalih',
  ),
  TranslationEntry(
    id: 'Tiga',
    en: 'Three',
    jvNgoko: 'Telu',
    jvKrama: 'Tiga',
  ),
  TranslationEntry(
    id: 'Empat',
    en: 'Four',
    jvNgoko: 'Papat',
    jvKrama: 'Sekawan',
  ),
  TranslationEntry(
    id: 'Lima',
    en: 'Five',
    jvNgoko: 'Lima',
    jvKrama: 'Gangsal',
  ),
  TranslationEntry(
    id: 'Enam',
    en: 'Six',
    jvNgoko: 'Enem',
    jvKrama: 'Enem',
  ),
  TranslationEntry(
    id: 'Tujuh',
    en: 'Seven',
    jvNgoko: 'Pitu',
    jvKrama: 'Pitu',
  ),
  TranslationEntry(
    id: 'Delapan',
    en: 'Eight',
    jvNgoko: 'Wolu',
    jvKrama: 'Wolu',
  ),
  TranslationEntry(
    id: 'Sembilan',
    en: 'Nine',
    jvNgoko: 'Sanga',
    jvKrama: 'Sanga',
  ),
  TranslationEntry(
    id: 'Sepuluh',
    en: 'Ten',
    jvNgoko: 'Sepuluh',
    jvKrama: 'Sedasa',
  ),
  TranslationEntry(
    id: 'Seratus',
    en: 'One hundred',
    jvNgoko: 'Satus',
    jvKrama: 'Satus',
  ),
  TranslationEntry(
    id: 'Seribu',
    en: 'One thousand',
    jvNgoko: 'Sewu',
    jvKrama: 'Sewu',
  ),
  TranslationEntry(
    id: 'Banyak',
    en: 'Many',
    jvNgoko: 'Akeh',
    jvKrama: 'Kathah',
  ),
  TranslationEntry(
    id: 'Sedikit',
    en: 'Few',
    jvNgoko: 'Sithik',
    jvKrama: 'Sakedhik',
  ),
  TranslationEntry(
    id: 'Semua',
    en: 'All',
    jvNgoko: 'Kabeh',
    jvKrama: 'Sedaya',
  ),

  // ── 12. Waktu dan hari ──────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Hari ini',
    en: 'Today',
    jvNgoko: 'Dina iki',
    jvKrama: 'Dinten menika',
  ),
  TranslationEntry(
    id: 'Kemarin',
    en: 'Yesterday',
    jvNgoko: 'Wingi',
    jvKrama: 'Kala wingi',
  ),
  TranslationEntry(
    id: 'Besok',
    en: 'Tomorrow',
    jvNgoko: 'Sesuk',
    jvKrama: 'Mbenjing',
  ),
  TranslationEntry(
    id: 'Sekarang',
    en: 'Now',
    jvNgoko: 'Saiki',
    jvKrama: 'Samenika',
  ),
  TranslationEntry(
    id: 'Nanti',
    en: 'Later',
    jvNgoko: 'Mengko',
    jvKrama: 'Mangke',
  ),
  TranslationEntry(
    id: 'Pagi',
    en: 'Morning',
    jvNgoko: 'Esuk',
    jvKrama: 'Enjing',
  ),
  TranslationEntry(
    id: 'Siang',
    en: 'Afternoon',
    jvNgoko: 'Awan',
    jvKrama: 'Siyang',
  ),
  TranslationEntry(
    id: 'Sore',
    en: 'Evening',
    jvNgoko: 'Sore',
    jvKrama: 'Sonten',
  ),
  TranslationEntry(
    id: 'Malam',
    en: 'Night',
    jvNgoko: 'Bengi',
    jvKrama: 'Dalu',
  ),
  TranslationEntry(
    id: 'Senin',
    en: 'Monday',
    jvNgoko: 'Senen',
    jvKrama: 'Senen',
  ),
  TranslationEntry(
    id: 'Selasa',
    en: 'Tuesday',
    jvNgoko: 'Selasa',
    jvKrama: 'Selasa',
  ),
  TranslationEntry(
    id: 'Rabu',
    en: 'Wednesday',
    jvNgoko: 'Rebo',
    jvKrama: 'Rebo',
  ),
  TranslationEntry(
    id: 'Kamis',
    en: 'Thursday',
    jvNgoko: 'Kemis',
    jvKrama: 'Kemis',
  ),
  TranslationEntry(
    id: 'Jumat',
    en: 'Friday',
    jvNgoko: 'Jemuwah',
    jvKrama: 'Jemuwah',
  ),
  TranslationEntry(
    id: 'Sabtu',
    en: 'Saturday',
    jvNgoko: 'Setu',
    jvKrama: 'Setu',
  ),
  TranslationEntry(
    id: 'Minggu',
    en: 'Sunday',
    jvNgoko: 'Ahad',
    jvKrama: 'Ahad',
  ),

  // ── 13. Keluarga ─────────────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Ayah',
    en: 'Father',
    jvNgoko: 'Bapak',
    jvKrama: 'Bapak',
  ),
  TranslationEntry(
    id: 'Ibu',
    en: 'Mother',
    jvNgoko: 'Ibu',
    jvKrama: 'Ibu',
  ),
  TranslationEntry(
    id: 'Kakak',
    en: 'Older sibling',
    jvNgoko: 'Kakang',
    jvKrama: 'Kakang',
  ),
  TranslationEntry(
    id: 'Adik',
    en: 'Younger sibling',
    jvNgoko: 'Adhi',
    jvKrama: 'Adhi',
  ),
  TranslationEntry(
    id: 'Kakek',
    en: 'Grandfather',
    jvNgoko: 'Simbah kakung',
    jvKrama: 'Eyang kakung',
  ),
  TranslationEntry(
    id: 'Nenek',
    en: 'Grandmother',
    jvNgoko: 'Simbah putri',
    jvKrama: 'Eyang putri',
  ),
  TranslationEntry(
    id: 'Paman',
    en: 'Uncle',
    jvNgoko: 'Paman',
    jvKrama: 'Paman',
  ),
  TranslationEntry(
    id: 'Bibi',
    en: 'Aunt',
    jvNgoko: 'Bibi',
    jvKrama: 'Bibi',
  ),
  TranslationEntry(
    id: 'Anak',
    en: 'Child',
    jvNgoko: 'Anak',
    jvKrama: 'Anak',
  ),
  TranslationEntry(
    id: 'Suami',
    en: 'Husband',
    jvNgoko: 'Bojo lanang',
    jvKrama: 'Garwa kakung',
  ),
  TranslationEntry(
    id: 'Istri',
    en: 'Wife',
    jvNgoko: 'Bojo wadon',
    jvKrama: 'Garwa putri',
  ),
  TranslationEntry(
    id: 'Teman',
    en: 'Friend',
    jvNgoko: 'Kanca',
    jvKrama: 'Rencang',
  ),

  // ── 14. Pendidikan ───────────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Guru',
    en: 'Teacher',
    jvNgoko: 'Guru',
    jvKrama: 'Guru',
  ),
  TranslationEntry(
    id: 'Murid',
    en: 'Student',
    jvNgoko: 'Murid',
    jvKrama: 'Murid',
  ),
  TranslationEntry(
    id: 'Buku',
    en: 'Book',
    jvNgoko: 'Buku',
    jvKrama: 'Buku',
  ),
  TranslationEntry(
    id: 'Pensil',
    en: 'Pencil',
    jvNgoko: 'Potlot',
    jvKrama: 'Potlot',
  ),
  TranslationEntry(
    id: 'Pena',
    en: 'Pen',
    jvNgoko: 'Pulpen',
    jvKrama: 'Pulpen',
  ),
  TranslationEntry(
    id: 'Papan tulis',
    en: 'Blackboard',
    jvNgoko: 'Papan tulis',
    jvKrama: 'Papan tulis',
  ),
  TranslationEntry(
    id: 'Pelajaran',
    en: 'Lesson',
    jvNgoko: 'Pelajaran',
    jvKrama: 'Pelajaran',
  ),
  TranslationEntry(
    id: 'Ujian',
    en: 'Exam',
    jvNgoko: 'Ujian',
    jvKrama: 'Ujian',
  ),
  TranslationEntry(
    id: 'Nilai',
    en: 'Grade',
    jvNgoko: 'Biji',
    jvKrama: 'Biji',
  ),

  // ── 15. Kesehatan ────────────────────────────────────────────────────────────
  TranslationEntry(
    id: 'Sakit',
    en: 'Sick',
    jvNgoko: 'Lara',
    jvKrama: 'Gerah',
  ),
  TranslationEntry(
    id: 'Sehat',
    en: 'Healthy',
    jvNgoko: 'Sehat',
    jvKrama: 'Sehat',
  ),
  TranslationEntry(
    id: 'Obat',
    en: 'Medicine',
    jvNgoko: 'Obat',
    jvKrama: 'Jampi',
  ),
  TranslationEntry(
    id: 'Dokter',
    en: 'Doctor',
    jvNgoko: 'Dokter',
    jvKrama: 'Dokter',
  ),
  TranslationEntry(
    id: 'Rumah sakit',
    en: 'Hospital',
    jvNgoko: 'Rumah sakit',
    jvKrama: 'Rumah sakit',
  ),
  TranslationEntry(
    id: 'Demam',
    en: 'Fever',
    jvNgoko: 'Demam',
    jvKrama: 'Demam',
  ),
  TranslationEntry(
    id: 'Batuk',
    en: 'Cough',
    jvNgoko: 'Watuk',
    jvKrama: 'Watuk',
  ),
  TranslationEntry(
    id: 'Pusing',
    en: 'Dizzy',
    jvNgoko: 'Mumet',
    jvKrama: 'Mumet',
  ),

  // ── 16. Percakapan & ungkapan praktis ───────────────────────────────────────
  TranslationEntry(
    id: 'Di mana',
    en: 'Where',
    jvNgoko: 'Neng ndi',
    jvKrama: 'Wonten pundi',
  ),
  TranslationEntry(
    id: 'Apa',
    en: 'What',
    jvNgoko: 'Opo',
    jvKrama: 'Menapa',
  ),
  TranslationEntry(
    id: 'Siapa',
    en: 'Who',
    jvNgoko: 'Sopo',
    jvKrama: 'Sinten',
  ),
  TranslationEntry(
    id: 'Kapan',
    en: 'When',
    jvNgoko: 'Kapan',
    jvKrama: 'Kapan',
  ),
  TranslationEntry(
    id: 'Mengapa',
    en: 'Why',
    jvNgoko: 'Kenopo',
    jvKrama: 'Kenging menapa',
  ),
  TranslationEntry(
    id: 'Bagaimana',
    en: 'How',
    jvNgoko: 'Kepiye',
    jvKrama: 'Kados pundi',
  ),
  TranslationEntry(
    id: 'Berapa',
    en: 'How much',
    jvNgoko: 'Piro',
    jvKrama: 'Pinten',
  ),
  TranslationEntry(
    id: 'Saya lapar',
    en: 'I am hungry',
    jvNgoko: 'Aku luwe',
    jvKrama: 'Kula luwe', // Catatan: 'luwe' digunakan untuk diri sendiri (krama lugu); krama alus 'ngelih' hanya untuk orang lain
  ),
  TranslationEntry(
    id: 'Saya haus',
    en: 'I am thirsty',
    jvNgoko: 'Aku ngelak',
    jvKrama: 'Kula ngelak', // Catatan: 'ngelak' krama lugu untuk diri sendiri; krama alus 'salit' hanya untuk orang lain
  ),
  TranslationEntry(
    id: 'Saya lelah',
    en: 'I am tired',
    jvNgoko: 'Aku kesel',
    jvKrama: 'Kula sayah',
  ),
  TranslationEntry(
    id: 'Saya senang',
    en: 'I am happy',
    jvNgoko: 'Aku seneng',
    jvKrama: 'Kula remen',
  ),
  TranslationEntry(
    id: 'Saya sedih',
    en: 'I am sad',
    jvNgoko: 'Aku sedhih',
    jvKrama: 'Kula sungkawa',
  ),
  TranslationEntry(
    id: 'Saya sakit',
    en: 'I am sick',
    jvNgoko: 'Aku lara',
    jvKrama: 'Kula sakit', // Catatan: diri sendiri menggunakan krama andhap 'sakit', bukan krama alus 'gerah'
  ),
  TranslationEntry(
    id: 'Berapa harganya',
    en: 'How much is it',
    jvNgoko: 'Regane piro',
    jvKrama: 'Reginipun pinten',
  ),
  TranslationEntry(
    id: 'Ini berapa',
    en: 'How much is this',
    jvNgoko: 'Iki piro',
    jvKrama: 'Menika pinten',
  ),
  TranslationEntry(
    id: 'Di mana toilet',
    en: 'Where is the toilet',
    jvNgoko: 'Neng ndi toilete',
    jvKrama: 'Wonten pundi toiletipun',
  ),
  TranslationEntry(
    id: 'Saya tidak tahu',
    en: 'I do not know',
    jvNgoko: 'Aku ora weruh',
    jvKrama: 'Kula mboten mangertos menapa-menapa',
  ),
  TranslationEntry(
    id: 'Tolong bantu saya',
    en: 'Please help me',
    jvNgoko: 'Tulung tulungana aku',
    jvKrama: 'Nyuwun tulung biyantu kula',
  ),
  TranslationEntry(
    id: 'Selamat belajar',
    en: 'Happy studying',
    jvNgoko: 'Sugeng sinau',
    jvKrama: 'Sugeng sinau',
  ),
  TranslationEntry(
    id: 'Selamat bekerja',
    en: 'Have a good work',
    jvNgoko: 'Sugeng nyambut gawe',
    jvKrama: 'Sugeng nyambut damel',
  ),
];

/// Seluruh entri kamus terjemahan gabungan (inti dan tambahan Starter Kit).
const List<TranslationEntry> kAllTranslationEntries = [
  ...kTranslationEntries,
  ...kExtendedTranslationEntries,
];
