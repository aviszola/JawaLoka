// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/// Model internal untuk menampung entri dataset Starter Kit selama penyaringan.
class RawRecord {
  final String key;
  final String rawId;
  final String rawNgoko;
  final String rawKramaAlus;
  final String rawKramaInggil;

  late final String id;
  late final String ngoko;
  late final String kramaAlus;
  late final String kramaInggil;

  String status = 'LEWAT';
  String alasan = '';
  String en = '';

  RawRecord({
    required this.key,
    required this.rawId,
    required this.rawNgoko,
    required this.rawKramaAlus,
    required this.rawKramaInggil,
  }) {
    id = normalize(rawId);
    ngoko = normalize(rawNgoko);
    kramaAlus = normalize(rawKramaAlus);
    kramaInggil = normalize(rawKramaInggil);
  }

  /// Normalisasi: trim, rapikan spasi ganda, huruf pertama kapital, sisanya apa adanya.
  static String normalize(String s) {
    var trimmed = s.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.isEmpty) return trimmed;
    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }
}

/// Model untuk entri kamus aplikasi yang sudah ada.
class AppEntry {
  final String id;
  final String en;
  final String ngoko;
  final String krama;

  const AppEntry({
    required this.id,
    required this.en,
    required this.ngoko,
    required this.krama,
  });
}

/// Escape string untuk format CSV RFC 4180.
String escapeCsv(String value) {
  if (value.contains(',') || value.contains('"') || value.contains('\n') || value.contains('\r')) {
    return '"${value.replaceAll('"', '""')}"';
  }
  return value;
}

/// Unescape baris CSV sederhana.
List<String> parseCsvRow(String line) {
  final fields = <String>[];
  final sb = StringBuffer();
  var insideQuotes = false;

  for (var i = 0; i < line.length; i++) {
    final c = line[i];
    if (insideQuotes) {
      if (c == '"') {
        if (i + 1 < line.length && line[i + 1] == '"') {
          sb.write('"');
          i++;
        } else {
          insideQuotes = false;
        }
      } else {
        sb.write(c);
      }
    } else {
      if (c == '"') {
        insideQuotes = true;
      } else if (c == ',') {
        fields.add(sb.toString());
        sb.clear();
      } else {
        sb.write(c);
      }
    }
  }
  fields.add(sb.toString());
  return fields;
}

/// Kamus padanan bahasa Inggris yang ditulis sendiri dari kata Indonesianya.
/// Kata kerja bentuk dasar tanpa 'to', satu padanan paling umum untuk pemula, huruf pertama kapital.
/// Nilai null menandai 'en-ragu' (jangan menebak bila ragu / frasa janggal / typo).
const Map<String, String?> kEnEquivalents = {
  'Perintah': 'Command',
  'Diperintah': null, // pasif / ragu
  'Memerintah': 'Govern',
  'Pelana': 'Saddle',
  'Merah': 'Red',
  'Memberatkan': null, // ragu
  'Keberatan': 'Objection',
  'Menanak nasi': null, // ragu
  'Takaran beras': null, // ragu
  'Sambil Beridiri': null, // typo / ragu
  'Manja': 'Spoiled',
  'Bermanja': null, // ragu
  'Menjauh': null, // ragu
  'Terlalu jauh': null, // ragu
  'Menyabung': null, // ragu
  'Mengadukan': null, // ragu
  'Menyambung': 'Connect',
  'Bertengkar': 'Fight',
  'Mandi': 'Bathe',
  'Tempat mandi': null, // ragu
  'Kedinginan': null, // ragu
  'Agama': 'Religion',
  'Jangan berkata': null, // ragu
  'Menilai': 'Evaluate',
  'Bernilai': 'Valuable',
  'Mengajukan': 'Propose',
  'Barangkali': 'Perhaps',
  'Kebanyakan': null, // ragu
  'Umumnya': 'Generally',
  'Suruh': null, // ragu
  'Menyuruh': 'Order',
  'Ampun': 'Pardon',
  'Diakui': null, // ragu
  'Mengakui': 'Admit',
  'Kejelekan': 'Badness',
  'Meskipun': 'Although',
  'Menghalangi': 'Block',
  'Cincin': 'Ring',
  'Pindah': 'Move',
  'Alis': 'Eyebrow',
  'Memperluas': 'Expand',
  'Bau': 'Smell',
  'Bau-bauan': null, // ragu
  'Cium': 'Kiss',
  'Minta maaf': 'Apologize',
  'Singgah': null, // ragu / bentrok Stop
  'Ada': 'Exist',
  'Mengadakan': 'Hold',
  'Keadaan': 'Condition',
  'Adapun': null, // ragu
  'Bersalin': null, // ragu
  'Beranak': null, // ragu
  'Percaya': 'Believe',
  'Kepercayaan': 'Trust',
  'Menuai': 'Harvest',
  'Sampai': 'Arrive',
  'Menunggu': 'Wait',
  'Turut': 'Follow',
  'Asalkan': null, // ragu
  'Menggembala': 'Herd',
  'Penggembala': 'Shepherd',
  'Tawar-menawar': 'Bargain',
  'Hapal': 'Memorize',
  'Hapalan': null, // ragu
  'Memaafkan': 'Forgive',
  'Menyebut': 'Mention',
  'Depan': 'Front',
  'Bagian depan': null, // ragu
  'Ari-ari': null, // ragu
  'Anjing': 'Dog',
  'Hati': 'Heart',
  'Hati-hati': 'Careful',
  'Berhati-hati': null, // ragu
  'Badan': 'Body',
  'Melakukan sendiri': null, // ragu
  'Kesiangan': null, // ragu
  'Meskipun siang': null, // ragu
  'Melahirkan': 'Deliver',
  'Tembakau': 'Tobacco',
  'Pokok': 'Main',
  'Kembali': 'Return',
  'Berkali-kali': 'Repeatedly',
  'Tulang': 'Bone',
  'Borgol': 'Handcuff',
  'Tawanan': 'Captive',
  'Banjir': 'Flood',
  'Keterlaluan': null, // ragu
  'Terlalu': 'Too',
  'Bantal': 'Pillow',
  'Bantalan': null, // ragu
  'Bersama': 'Together',
  'Sulung': 'Eldest',
  'Batu bata': 'Brick',
  'Batin': 'Inner',
  'Memikir': null, // ragu
  'Kebatinan': null, // ragu
  'Batu': 'Stone',
  'Menemani': 'Accompany',
  'Batik': 'Batik',
  'Dahi': 'Forehead',
  'Jarik': null, // ragu
  'Itik': 'Duck',
  'Pipa rokok': null, // ragu
  'Hormat': 'Respect',
  'Berbakti': 'Devote',
  'Biar': 'Let',
  'Kemalaman': null, // ragu
  'Beras': 'Rice', // bentrok dengan Nasi di app -> en-bentrok
  'Kebaikan': 'Goodness',
  'Dahulunya': null, // ragu
  'Suami-istri': 'Couple',
  'Pantat': 'Buttock',
  'Benang': 'Thread',
  'Bedak': 'Powder',
  'Kumis': 'Mustache',
  'Selesai': 'Finish',
  'Berangkat': 'Depart',
  'Bubaran': null, // ragu
  'Gembira': 'Glad',
  'Bergembira': 'Rejoice',
  'Bupati': 'Regent',
  'Kejar': 'Chase',
  'Mengejar': null, // ragu
  'Berburu': 'Hunt',
  'Butuh': 'Need',
  'Kebutuhan': 'Necessity',
  'Buang': 'Throw',
  'Pegang': 'Hold',
  'Memegang': null, // ragu
  'Babi hutan': 'Boar',
  'Yang kecil': null, // ragu
  'Coba': 'Try',
  'Percobaan': 'Experiment',
  'Cerita': 'Story',
  'Kecukupan': 'Sufficiency',
  'Cukur': 'Shave',
  'Sanggama': null, // ragu
  'Memijit': 'Massage',
  'Menjadi': 'Become',
  'Terjadi': 'Happen',
  'Dagang': 'Trade',
  'Berhias': 'Dress',
  'Merias': null, // ragu
  'Memperpanjang': 'Lengthen',
  'Taruh': 'Put',
  'Sepenglihatan': null, // ragu
  'Amal': 'Charity',
  'Hanya karena': null, // ragu
  'Pedesaan': 'Countryside',
  'Dada': 'Chest',
  'Tamu': 'Guest',
  'Ketika': 'When',
  'Kesenangan': 'Pleasure',
  'Lutut': 'Knee',
  'Sendiri': 'Alone',
  'Uang': 'Money',
  'Di-': null, // ragu
  'Hari': 'Day',
  'Harian': 'Daily',
  'Kertas': 'Paper',
  'Kain': 'Cloth',
  'Jual beli': 'Commerce',
  'Main': 'Play',
  'Jarum': 'Needle',
  'Bukan': null, // ragu
  'Duga': 'Guess',
  'Persaudaraan': 'Brotherhood',
  'Sebelumnya': 'Previously',
  'Gila': 'Crazy',
  'Tergila-gila': 'Infatuated',
  'Ingat': 'Remember',
  'Mengingat-ingat': null, // ragu
  'Mengingat': null, // ragu
  'Ilmu': 'Knowledge',
  'Air mata': 'Tear',
  'Emas': 'Gold',
  'Tidak tahu': null, // ragu
  'Ubun-ubun': 'Crown',
  'Enak': 'Delicious',
  'Enak perasaan': null, // ragu
  'Mabuk': 'Drunk',
  'Henti': 'Pause',
  'Menghentikan': 'Stop',
  'Bertelur': 'Lay',
  'Diam': 'Silent',
  'Menuju': 'Head',
  'Janggut': 'Beard',
  'Dalam': 'Deep',
  'Untuk': 'For',
  'Memakai': 'Wear',
  'Menempati': 'Occupy',
  'Masa muda': 'Youth',
  'Habis': 'Exhausted',
  'Kehabisan': null, // ragu
  'Mengambilkan': 'Fetch',
  'Alat': 'Tool',
  'Gamelan': 'Gamelan',
  'Mudah': 'Easy',
  'Meremehkan': 'Underestimate',
  'Memperdalam': 'Deepen',
  'Jeruk': 'Orange',
  'Tari': 'Dance',
  'Tarian': null, // ragu
  'Menari': null, // ragu
  'Bersisir': null, // ragu
  'Menyisir': 'Comb',
  'Mencuri': 'Steal',
  'Istimewa': 'Special',
  'Mengaji': 'Recite',
  'Pengajian': null, // ragu
  'Naik Haji': null, // ragu
  'Kalung': 'Necklace',
  'Kelapa': 'Coconut',
  'Pimpinan Desa': 'Headman',
  'Sana': 'There',
  'Kehendak': 'Will', // bentrok Will di app -> en-bentrok
  'Tertinggal': 'Left',
  'Ternyata': 'Apparently',
  'Keduanya': 'Both',
  'Tentu': 'Certain',
  'Tidak Tentu': 'Uncertain',
  'Celana': 'Pants',
  'Bercelana': null, // ragu
  'Kerbau': 'Buffalo',
  'Keguguran': 'Miscarriage',
  'Hiasan': 'Decoration',
  'Bunga tiga warna': null, // ragu
  'Kumur': 'Gargle',
  'Berkumur': null, // ragu
  'Selimut': 'Blanket',
  'Berselimut': null, // ragu
  'Sini': 'Here',
  'Begitu': 'So',
  'Dikelilingi': 'Surrounded',
  'Kenduri': 'Feast',
  'Keris': 'Kris',
  'Tergesa-gesa': 'Hurried',
  'Menunjukan tanda': null, // ragu
  'Kelihatan': 'Visible',
  'Terbayang': 'Imagined',
  'Nisan': 'Gravestone',
  'Kira': 'Estimate',
  'Mengira': null, // ragu
  'Kirim': 'Send',
  'Mengirim': null, // ragu
  'Baju': 'Clothes',
  'Tikar': 'Mat',
  'Kliru': 'Mistaken',
  'Kumpulan': 'Collection',
  'Berkumpul': 'Gather',
  'Kau suruh': null, // ragu
  'Situ': null, // ragu
  'Mandi jamas': null, // ragu
  'Terasa': 'Felt',
  'Keringat': 'Sweat',
  'Kubur': 'Grave',
  'Makam': 'Tomb',
  'Mengubur': 'Bury',
  'Terlahir': 'Born',
  'Lahir batin': null, // ragu
  'Terlaksana': 'Accomplished',
  'Jalan-jalan': 'Stroll',
  'Menjalankan': 'Execute',
  'Lupa': 'Forget',
  'Terlupa': null, // ragu
  'Pelupa': 'Forgetful',
  'Bibir': 'Lip',
  'Perhatian': 'Attention',
  'Bawa': 'Bring',
  'Membawa': 'Carry',
  'Bawaan': 'Luggage',
  'Pisang': 'Banana',
  'Pembesar': 'Dignitary',
  'Punggung': 'Back',
  'Gelang': 'Bracelet',
  'Penurut': 'Obedient',
  'Gelung': 'Bun',
  'Lengap': null, // typo 'Lengkap' -> ragu
  'Melengkapi': 'Complete',
  'Gilir': 'Rotate',
  'Bergilir': 'Alternate',
  'Kurus': 'Thin',
  'Darah': 'Blood',
  'Daun': 'Leaf',
  'Dedaunan': 'Foliage',
  'Mencari-cari': null, // ragu
  'Yang dicari': null, // ragu
  'Bohong': 'Lie',
  'Adu': null, // ragu
  'Taat': 'Compliant',
  'Leher': 'Neck',
  'Guna': 'Use',
  'Menggunakan': 'Utilize',
  'Pegunungan': 'Mountains',
  'Tawa': 'Laughter',
  'Tertawa': 'Laugh',
  'Bercanda': 'Joke',
  'Menertawakan': 'Mock',
  'Ludah': 'Saliva',
  'Hijau': 'Green',
  'Tukar': 'Exchange',
  'Ikat kepala': 'Headband',
  'Hilang': 'Lost',
  'Kehilangan': 'Loss',
  'Cermin': 'Mirror',
  'Peram': 'Ripen',
  'Peraman': null, // ragu
  'Inap': 'Lodge',
  'Bermalam': 'Stay',
  'Piara': 'Breed',
  'Hitam': 'Black',
  'Mengiring': 'Escort',
  'Masih': 'Still',
  'Malu': 'Shy',
  'Buang hajat': 'Defecate',
  'Bawah': 'Bottom',
  'Di bawah': 'Below',
  'Luar': 'Outside',
  'Kecuali': 'Except',
  'Di luar': null, // ragu
  'Jaga': 'Guard',
  'Jago': 'Rooster',
  'Duduk-duduk': 'Lounge',
  'Taji': 'Spur',
  'Pinta': 'Request',
  'Jam': 'Clock',
  'Berobat': null, // ragu
  'Mengobati': 'Treat',
  'Dagu': 'Chin',
  'Kuda': 'Horse',
  'Katanya': 'Rumor',
  'Kain panjang': 'Sarong',
  'Menjelaskan': 'Explain',
  'Jati': 'Teak',
  'Kayu jati': null, // ragu
  'Sejati': 'Genuine',
  'Seperti jawa': null, // ragu
  'Pria': 'Man',
  'Jantan': 'Male',
  'Sakit hati': 'Hurt',
  'Kesakitan': 'Agony',
  'Penyakit': 'Disease',
  'Menyakiti': 'Harm',
  'Bekas': 'Trace',
  'Termasuk': 'Included',
  'Kemasukan': 'Possessed',
  'Terjaga': 'Awake',
  'Almari': 'Cupboard',
  'Halus': 'Smooth',
  'Gemuk': 'Fat',
  'Lewat': 'Pass',
  'Kelewat': null, // ragu
  'Utara': 'North',
  'Bajak': 'Plow',
  'Membajak': null, // ragu
  'Kulit': 'Skin',
  'Biasa': 'Normal',
  'Kesalahan': 'Mistake',
  'Kelebihan': 'Excess',
  'Madu': 'Honey',
  'Pencuri': 'Thief',
  'Mengunyah': 'Chew',
  'Sekian': null, // ragu
  'Burung': 'Bird',
  'Mati': 'Die',
  'Membunuh': 'Kill',
  'Tadi': 'Earlier',
  'Tergantung': 'Dependent',
  'Jenazah': 'Corpse',
  'Menang': 'Win',
  'Jika': 'If',
  'Rusa': 'Deer',
  'Kafan': 'Shroud',
  'Muat': 'Fit',
  'Memuat': 'Load',
  'Mudah-mudahan': 'Hopefully',
  'Maka': 'Then',
  'Musuh': 'Enemy',
  'Bermusuhan': 'Hostile',
  'Kemurahan': 'Generosity',
  'Murahan': null, // ragu
  'Serba murah': null, // ragu
  'Marah-marah': 'Rage',
  'Muntah': 'Vomit',
  'Bahaya': 'Danger',
  'Dan juga': null, // ragu
  'Negara': 'Country',
  'Pengertian': 'Understanding',
  'Ketahuan': 'Discovered',
  'Lalu': 'Next',
  'Segera': 'Immediately',
  'Bergerak': null, // ragu
  'Bakar': 'Burn',
  'Terbakar': null, // ragu
  'Kebakaran': 'Fire', // bentrok Fire di app -> en-bentrok
  'Oleh-oleh': 'Souvenir',
  'Kawin': 'Marry',
  'Pekarangan': 'Yard',
  'Bercakap-cakap': 'Chat',
  'Upah': 'Wage',
  'Bayaran': 'Payment',
  'Mengupah': 'Hire',
  'Ompong': 'Toothless',
  'Tidak mungkin': 'Impossible',
  'Sempit': 'Narrow',
  'Rusuh': 'Riotous',
  'Menganggu': 'Disturb',
  'Sabuk': 'Belt',
  'Sanggup': 'Capable',
  'Melayani': 'Serve',
  'Sajian': 'Dish',
  'Dari': null, // ragu (partikel / ada di _kFunctionalGrammar)
  'Ganti pakaian': null, // ragu
  'Berganti-ganti': null, // ragu
  'Sambung': 'Join',
  'Berhubungan': 'Relate',
  'Segala sesuatu': 'Everything',
  'Angkat': 'Lift',
  'Sapi': 'Cow',
  'Serba': null, // ragu
  'Berbulan-bulan': null, // ragu
  'Persawahan': null, // ragu
  'Sebar benih padi': null, // ragu
  'Menyebar benih': 'Sow',
  'Mengatakan': 'Say',
  'Menyebutkan': 'State',
  'Sebentar': 'Moment',
  'Cukupan': null, // ragu
  'Baru senang makan': null, // ragu
  'Lain-lain': 'Others',
  'Dua puluh lima': 'Twenty-five',
  'Menangguhkan': 'Postpone',
  'Menyembelih': 'Slaughter',
  'Sendok': 'Spoon',
  'Menyenangkan': 'Pleasant',
  'Mencintai': 'Love',
  'Separo': 'Half',
  'Membagi dua': 'Halve',
  'Masing-masing': 'Each',
  'Sepi': 'Quiet',
  'Menyepi': 'Seclude',
  'Tanpa pamrih': 'Selfless',
  'Sejak dahulu': null, // ragu
  'Sampai sekarang': null, // ragu
  'Besok pagi': null, // ragu
  'Siku': 'Elbow',
  'Pinjaman': 'Loan',
  'Yang': null, // partikel -> ragu
  'Selamat': 'Safe',
  'Selamatan': null, // ragu
  'Kadang-kadang': 'Sometimes',
  'Mungkin': 'Maybe',
  'Pada sore hari': null, // ragu
  'Sabar': 'Patient',
  'Menjamu': 'Entertain',
  'Rumput': 'Grass',
  'Khitan': 'Circumcise',
  'Supaya': null, // partikel -> ragu
  'Petang': 'Dusk',
  'Matahari terbenam': 'Sunset',
  'Sampai petang': null, // ragu
  'Susah': 'Difficult',
  'Susah hati': 'Grieved',
  'Menyusu': 'Suckle',
  'Masih menyusu': null, // ragu
  'Sugi': null, // ragu
  'Bersugi': null, // ragu
  'Suara': 'Voice',
  'Menegur': 'Rebuke',
  'Surga': 'Heaven',
  'Lama-kelamaan': 'Gradually',
  'Teralu lama': null, // typo 'terlalu' -> ragu
  'Membuat lama': 'Delay',
  'Subang': null, // ragu
  'Tahi': 'Feces',
  'Bertanya': 'Ask',
  'Tali': 'Rope',
  'Terima': 'Receive',
  'Tanam': 'Plant',
  'Mengerjakan': 'Do',
  'Tanda tangan': 'Signature',
  'Tetangga': 'Neighbor',
  'Para tetangga': null, // ragu
  'Tanggung': null, // ragu
  'Kurang banyak': null, // ragu
  'Menanggung': 'Bear',
  'Tanggung jawab': 'Responsibility',
  'Menangis': 'Cry',
  'Tapal': null, // ragu
  'Kain wanita': null, // ragu
  'Pernah': 'Ever',
  'Tebu': 'Sugarcane',
  'Kedatangan': 'Arrival',
  'Tiba': 'Reach',
  'Tongkat': 'Stick',
  'Tembaga': 'Copper',
  'Menyanyi': 'Sing',
  'Sungguh': 'Really',
  'Temu': 'Meet',
  'Kenal': 'Know',
  'Berkenalan': 'Acquaint',
  'Supit': null, // ragu
  'Berkunjung': 'Visit',
  'Pertunjukan': 'Show',
  'Memberitahukan': 'Inform',
  'Kutu Rambut': null, // ragu
  'Tombak': 'Spear',
  'Rugi': 'Lose',
  'Tunggal': 'Single',
  'Kendaraan': 'Vehicle',
  'Berbaring-baring': null, // ragu
  'Tumbuk padi': null, // ragu
  'Menumbuk padi': 'Pound',
  'Berkata': 'Speak',
  'Bersikap tua': null, // ragu
  'Sesepuh': 'Elder',
  'Waktu hujan': null, // ragu
  'Kehujanan': null, // ragu
  'Kendor': 'Slack',
  'Juga': null, // partikel -> ragu
  'Janji': 'Promise',
  'Berjanji untuk': null, // ragu
  'Ular': 'Snake',
  'Raut muka': 'Expression',
  'Undangan': 'Invitation',
  'Ingus': 'Snot',
  'Umur': 'Age',
  'Dewasa': 'Adult',
  'Panggil': 'Call',
  'Memanggil': 'Summon',
  'Tanjakan': 'Slope',
  'Membelakang': null, // ragu
  'Bunyi': 'Sound',
  'Bersuara': null, // ragu
  'Ungkapan': 'Phrase',
  'Pelihara': 'Foster',
  'Penghidupan': 'Livelihood',
  'Utama': 'Primary',
  'Atau': null, // partikel -> ragu
  'Kencing': 'Urinate',
  'Membacakan': null, // ragu
  'Bacaan': 'Reading',
  'Rahasia': 'Secret',
  'Perempuan': 'Female',
  'Berani': 'Brave',
  'Tertalu berani': null, // typo -> ragu
  'Nasehat keras': null, // ragu
  'Kenyang': 'Full', // bentrok Full di app -> en-bentrok
  'Warisan': 'Inheritance',
  'Warung': 'Stall',
  'Berkedai': null, // ragu
  'Waspada': 'Alert',
  'Menyebabkan batuk': null, // ragu
  'Cat kain': null, // ragu
  'Mewarnai kain': null, // ragu
  'Takut': 'Afraid',
  'Hantu': 'Ghost',
  'Kambing': 'Goat',
  'Waktu': 'Time',
  'Warna': 'Color',
  'Berita': 'News',
  'Pengetahuan': null, // ragu
  'Mengetahui': null, // ragu
  'Besi': 'Iron',
  'Pusaka': 'Heirloom',
  'Keluar': 'Exit',
  'Hari kelahiran': 'Birthday',
  'Hitung': 'Count',
  'Menghitung': null, // ragu
  'Bilangan': 'Number',
  'Orang': 'Person',
  'Sarung keris': 'Scabbard',
  'Pusar': 'Navel',
  'Bisul': 'Boil',
  'Sakit bisur': null, // typo -> ragu
  'Mengajar': 'Teach',
  'Pembelajaran': 'Instruction',
  'Buluh': null, // ragu
  'Batal': 'Cancel',
  'Membatalkan': null, // ragu
  'Menambahkan': 'Add',
  'Yaitu': null, // partikel -> ragu
  'Betu': null, // typo 'Betul' -> ragu
  'Sebetulnya': 'Actually',
};

void main(List<String> args) {
  final mode = args.isEmpty ? 'all' : args[0].toLowerCase();
  print('=== IMPORT KAMUS JAWA-INDONESIA STARTER KIT ===');
  print('Mode: $mode');

  final projectDir = Directory.current.path.endsWith('flutter_jawaloka')
      ? Directory.current.path
      : '${Directory.current.path}/flutter_jawaloka';

  final jsonFile = File('$projectDir/docs/translator/starter_kit/kamus-2cba6-export.json');
  if (!jsonFile.existsSync()) {
    print('Error: Berkas input tidak ditemukan di ${jsonFile.path}');
    exit(1);
  }

  final appEntriesFile = File('$projectDir/docs/translator/existing_entries.csv');
  if (!appEntriesFile.existsSync()) {
    print('Error: Berkas existing_entries.csv tidak ditemukan di ${appEntriesFile.path}');
    exit(1);
  }

  // Muat entri kamus aplikasi yang ada
  final appEntries = <AppEntry>[];
  final appLines = appEntriesFile.readAsLinesSync();
  for (var i = 1; i < appLines.length; i++) {
    final line = appLines[i].trim();
    if (line.isEmpty) continue;
    final cols = parseCsvRow(line);
    if (cols.length >= 4) {
      appEntries.add(AppEntry(
        id: cols[0],
        en: cols[1],
        ngoko: cols[2],
        krama: cols[3],
      ));
    }
  }
  print('Entri kamus aplikasi yang dimuat: ${appEntries.length}');

  final appIdsLower = {for (final e in appEntries) e.id.toLowerCase().trim(): e};
  final appNgokoLower = {for (final e in appEntries) e.ngoko.toLowerCase().trim()};
  final appKramaLower = {for (final e in appEntries) e.krama.toLowerCase().trim()};
  final appEnLower = {for (final e in appEntries) e.en.toLowerCase().trim()};

  // Muat dataset Starter Kit 955 catatan
  final jsonContent = json.decode(jsonFile.readAsStringSync()) as Map<String, dynamic>;
  final employees = jsonContent['employees'] as Map<String, dynamic>;
  print('Total catatan di dataset employees: ${employees.length}');

  final records = <RawRecord>[];
  for (final entry in employees.entries) {
    final map = entry.value as Map<String, dynamic>;
    records.add(RawRecord(
      key: entry.key,
      rawId: (map['indonesia'] ?? '').toString(),
      rawNgoko: (map['ngoko'] ?? '').toString(),
      rawKramaAlus: (map['kramaalus'] ?? '').toString(),
      rawKramaInggil: (map['kramainggil'] ?? '').toString(),
    ));
  }

  // ─── TAHAP 1: Mode Prepare (Penyaringan Leksikal & Jawa) ───────────────────
  final tandaBacaRegex = RegExp(r'[,;()/0-9]');

  // (a) Cek tanda baca di salah satu kolom
  for (final r in records) {
    if (tandaBacaRegex.hasMatch(r.rawId) ||
        tandaBacaRegex.hasMatch(r.rawNgoko) ||
        tandaBacaRegex.hasMatch(r.rawKramaAlus) ||
        tandaBacaRegex.hasMatch(r.rawKramaInggil)) {
      r.status = 'LEWAT';
      r.alasan = 'tanda-baca';
    }
  }

  // (b) Baris yang persis sama setelah normalisasi dijaga satu saja
  final seenExact = <String>{};
  for (final r in records) {
    if (r.alasan.isNotEmpty) continue;
    final signature = '${r.id}|${r.ngoko}|${r.kramaAlus}|${r.kramaInggil}';
    if (seenExact.contains(signature)) {
      r.status = 'LEWAT';
      r.alasan = 'duplikat';
    } else {
      seenExact.add(signature);
    }
  }

  // (b) Kata Indonesia yang sama muncul lebih dari satu kali dengan nilai berbeda (arti-ganda)
  final byIndoWord = <String, List<RawRecord>>{};
  for (final r in records) {
    if (r.alasan.isNotEmpty) continue;
    final idLower = r.id.toLowerCase();
    byIndoWord.putIfAbsent(idLower, () => []).add(r);
  }

  for (final group in byIndoWord.values) {
    if (group.length > 1) {
      final distinctVals = group.map((e) => '${e.ngoko}|${e.kramaAlus}|${e.kramaInggil}').toSet();
      if (distinctVals.length > 1) {
        for (final r in group) {
          r.status = 'LEWAT';
          r.alasan = 'arti-ganda';
        }
      }
    }
  }

  // (c) Kata Indonesia sudah ada di kamus aplikasi
  final conflicts = <Map<String, String>>[];
  var samaDenganAppCount = 0;
  for (final r in records) {
    if (r.alasan.isNotEmpty) continue;
    final idLower = r.id.toLowerCase();
    if (appIdsLower.containsKey(idLower)) {
      final appEnt = appIdsLower[idLower]!;
      final ngokoSama = r.ngoko.toLowerCase() == appEnt.ngoko.toLowerCase();
      final kramaSama = r.kramaAlus.toLowerCase() == appEnt.krama.toLowerCase();

      if (ngokoSama && kramaSama) {
        r.status = 'LEWAT';
        r.alasan = 'sama-dengan-aplikasi';
        samaDenganAppCount++;
      } else {
        r.status = 'LEWAT';
        r.alasan = 'beda-dengan-aplikasi';
        conflicts.add({
          'indonesia': r.id,
          'ngoko_app': appEnt.ngoko,
          'krama_app': appEnt.krama,
          'ngoko_dataset': r.ngoko,
          'krama_alus_dataset': r.kramaAlus,
          'krama_inggil_dataset': r.kramaInggil,
        });
      }
    }
  }

  // (d) Ngoko atau krama bentrok dengan aplikasi atau entri baru lain
  final newNgokoSet = <String>{};
  final newKramaSet = <String>{};

  for (final r in records) {
    if (r.alasan.isNotEmpty) continue;
    final ngokoLower = r.ngoko.toLowerCase();
    final kramaLower = r.kramaAlus.toLowerCase();

    if (appNgokoLower.contains(ngokoLower) || newNgokoSet.contains(ngokoLower)) {
      r.status = 'LEWAT';
      r.alasan = 'bentrok-ngoko';
    } else if (appKramaLower.contains(kramaLower) || newKramaSet.contains(kramaLower)) {
      r.status = 'LEWAT';
      r.alasan = 'bentrok-krama';
    } else {
      r.status = 'MASUK';
      r.alasan = '';
      newNgokoSet.add(ngokoLower);
      newKramaSet.add(kramaLower);
    }
  }

  // Tulis kamus_conflicts.csv
  final conflictsFile = File('$projectDir/docs/translator/kamus_conflicts.csv');
  final conflictsBuf = StringBuffer();
  conflictsBuf.writeln('indonesia,ngoko_app,krama_app,ngoko_dataset,krama_alus_dataset,krama_inggil_dataset');
  for (final c in conflicts) {
    conflictsBuf.writeln(
      '${escapeCsv(c['indonesia']!)},${escapeCsv(c['ngoko_app']!)},${escapeCsv(c['krama_app']!)},'
      '${escapeCsv(c['ngoko_dataset']!)},${escapeCsv(c['krama_alus_dataset']!)},${escapeCsv(c['krama_inggil_dataset']!)}',
    );
  }
  conflictsFile.writeAsStringSync(conflictsBuf.toString());
  print('Wrote docs/translator/kamus_conflicts.csv: ${conflicts.length} entri');

  // Tulis kamus_en.csv jika belum ada atau dalam mode prepare
  final enFile = File('$projectDir/docs/translator/kamus_en.csv');
  if (!enFile.existsSync() || mode == 'prepare' || mode == 'all') {
    final enBuf = StringBuffer();
    enBuf.writeln('indonesia,en');
    for (final r in records) {
      if (r.status == 'MASUK') {
        final enVal = kEnEquivalents[r.id] ?? '';
        enBuf.writeln('${escapeCsv(r.id)},${escapeCsv(enVal)}');
      }
    }
    enFile.writeAsStringSync(enBuf.toString());
    print('Wrote docs/translator/kamus_en.csv untuk baris MASUK');
  }

  // ─── TAHAP 2: Mode Build (Evaluasi Bahasa Inggris & Pembangkitan) ───────────
  if (mode == 'build' || mode == 'all') {
    // Baca kamus_en.csv
    final enMap = <String, String>{};
    if (enFile.existsSync()) {
      final enLines = enFile.readAsLinesSync();
      for (var i = 1; i < enLines.length; i++) {
        final line = enLines[i].trim();
        if (line.isEmpty) continue;
        final cols = parseCsvRow(line);
        if (cols.length >= 2) {
          enMap[cols[0].trim()] = cols[1].trim();
        }
      }
    }

    final usedEnLower = <String>{...appEnLower};
    final finalAccepted = <RawRecord>[];

    for (final r in records) {
      if (r.status != 'MASUK') continue;

      final enVal = enMap[r.id] ?? kEnEquivalents[r.id];
      if (enVal == null || enVal.trim().isEmpty || enVal == 'en-ragu') {
        r.status = 'LEWAT';
        r.alasan = 'en-ragu';
      } else {
        final enNormalized = RawRecord.normalize(enVal);
        final enLower = enNormalized.toLowerCase();
        if (usedEnLower.contains(enLower)) {
          r.status = 'LEWAT';
          r.alasan = 'en-bentrok';
        } else {
          r.en = enNormalized;
          usedEnLower.add(enLower);
          finalAccepted.add(r);
        }
      }
    }

    // Tulis docs/translator/kamus_review.csv untuk SEMUA 955 catatan
    final reviewFile = File('$projectDir/docs/translator/kamus_review.csv');
    final reviewBuf = StringBuffer();
    reviewBuf.writeln('indonesia,ngoko,krama_alus,krama_inggil,status,alasan');
    for (final r in records) {
      reviewBuf.writeln(
        '${escapeCsv(r.id)},${escapeCsv(r.ngoko)},${escapeCsv(r.kramaAlus)},${escapeCsv(r.kramaInggil)},'
        '${r.status},${escapeCsv(r.alasan)}',
      );
    }
    reviewFile.writeAsStringSync(reviewBuf.toString());
    print('Wrote docs/translator/kamus_review.csv untuk semua ${records.length} catatan');

    // Urutkan entri yang diterima menurut id secara alfabetik deterministik
    finalAccepted.sort((a, b) => a.id.toLowerCase().compareTo(b.id.toLowerCase()));

    // Tulis lib/data/translation_entries_extended.dart
    final extendedFile = File('$projectDir/lib/data/translation_entries_extended.dart');
    final extBuf = StringBuffer();
    extBuf.writeln('import \'../features/translator/domain/translation_models.dart\';');
    extBuf.writeln('import \'translation_entries.dart\';');
    extBuf.writeln();
    extBuf.writeln('// ─── EXTENDED TRANSLATION ENTRIES ──────────────────────────────────────────');
    extBuf.writeln('// Sumber: Indonesian Javanese Dictionary Starter Kit (Rahutomo, Yunhasnawa,');
    extBuf.writeln('// Narolis, Prayanta, 2018, Mendeley Data, DOI 10.17632/y3hstv4bfn.2, lisensi CC BY 4.0).');
    extBuf.writeln('// Perubahan yang dibuat:');
    extBuf.writeln('//   - Pemetaan kramaalus ke jvKrama (kramainggil disimpan di berkas tinjauan)');
    extBuf.writeln('//   - Tambahan padanan bahasa Inggris (en) satu padanan pemula bentuk dasar');
    extBuf.writeln('//   - Penyaringan integritas (tanda-baca, arti-ganda, keunikan, non-bentrok)');
    extBuf.writeln('// Status: DRAF: belum diverifikasi penutur Jawa');
    extBuf.writeln('// ─────────────────────────────────────────────────────────────────────────────');
    extBuf.writeln();
    extBuf.writeln('/// Entri kamus terjemahan tambahan dari dataset Starter Kit.');
    extBuf.writeln('const List<TranslationEntry> kExtendedTranslationEntries = [');
    for (final r in finalAccepted) {
      extBuf.writeln('  TranslationEntry(');
      extBuf.writeln('    id: \'${r.id.replaceAll("'", "\\'")}\',');
      extBuf.writeln('    en: \'${r.en.replaceAll("'", "\\'")}\',');
      extBuf.writeln('    jvNgoko: \'${r.ngoko.replaceAll("'", "\\'")}\',');
      extBuf.writeln('    jvKrama: \'${r.kramaAlus.replaceAll("'", "\\'")}\',');
      extBuf.writeln('  ),');
    }
    extBuf.writeln('];');
    extendedFile.writeAsStringSync(extBuf.toString());
    print('Wrote lib/data/translation_entries_extended.dart: ${finalAccepted.length} entri');

    // Ringkasan Alasan
    print('\n--- RINGKASAN PENYARINGAN ---');
    print('Total catatan dibaca: ${records.length}');
    final alasanCount = <String, int>{};
    for (final r in records) {
      final key = r.status == 'MASUK' ? 'MASUK' : r.alasan;
      alasanCount[key] = (alasanCount[key] ?? 0) + 1;
    }
    for (final entry in alasanCount.entries) {
      print('  ${entry.key}: ${entry.value}');
    }
    print('Konflik beda-dengan-aplikasi: ${conflicts.length}');
    print('Sama-dengan-aplikasi: $samaDenganAppCount');
    print('Total entri tambahan yang ditambahkan: ${finalAccepted.length}');
  }
}
