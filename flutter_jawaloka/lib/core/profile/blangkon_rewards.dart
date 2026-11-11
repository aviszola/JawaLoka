import '../../features/profile/presentation/widgets/blangkon_painter.dart';

// PERLU VALIDASI BUDAYA
// PERLU KEPUTUSAN

/// Single Source of Truth untuk pemetaan hadiah blangkon, ambang level,
/// dan kondisi pembukaan di JawaLoka.
class BlangkonRewards {
  BlangkonRewards._();

  /// Mapping dari [BlangkonType] ke Level minimal pembukaan.
  /// `null` menandakan blangkon tidak dibuka lewat ambang Level (mis. awal atau evaluasi khusus).
  // PERLU KEPUTUSAN
  // PERLU VALIDASI BUDAYA
  static const Map<BlangkonType, int?> requiredLevels = {
    BlangkonType.yogyakarta: 1, // Awal (terbuka sejak awal)
    BlangkonType.surakarta: 5, // Level 5
    BlangkonType.banyumas: 6, // Level 6
    BlangkonType.kedu: 8, // Level 8
    BlangkonType.cirebon: 10, // Level 10
    BlangkonType.pusaka:
        null, // Khusus: Selesai materi/evaluasi aksara (Mastery Aksara)
  };

  /// Memeriksa apakah tipe blangkon memiliki CustomPainter tersendiri yang digambar sungguhan.
  /// Seluruh 6 tipe yang tersedia saat ini memiliki implementasi vector painter autentik.
  static bool hasRealPainter(BlangkonType type) {
    switch (type) {
      case BlangkonType.yogyakarta:
      case BlangkonType.surakarta:
      case BlangkonType.banyumas:
      case BlangkonType.kedu:
      case BlangkonType.cirebon:
      case BlangkonType.pusaka:
        return true;
    }
  }

  /// Memeriksa apakah suatu [BlangkonType] terbuka untuk level dan status pengguna tertentu.
  static bool isUnlocked(
    BlangkonType type, {
    required int userLevel,
    bool hasMasteredAksara = false,
  }) {
    // Blangkon tanpa painter sungguhan tidak boleh terbuka
    if (!hasRealPainter(type)) return false;

    // Yogyakarta selalu terbuka sejak awal
    if (type == BlangkonType.yogyakarta) return true;

    // Pusaka terbuka khusus saat materi aksara selesai (evaluasi Unit 2 lulus)
    // PERLU VALIDASI BUDAYA
    if (type == BlangkonType.pusaka) {
      return hasMasteredAksara;
    }

    final reqLevel = requiredLevels[type];
    if (reqLevel == null) return false;
    return userLevel >= reqLevel;
  }

  /// Mengembalikan seluruh [BlangkonType] yang berhak terbuka untuk [userLevel] dan [hasMasteredAksara].
  static List<BlangkonType> getUnlockedBlangkons({
    required int userLevel,
    bool hasMasteredAksara = false,
  }) {
    return BlangkonType.values
        .where((type) {
          return isUnlocked(
            type,
            userLevel: userLevel,
            hasMasteredAksara: hasMasteredAksara,
          );
        })
        .toList(growable: false);
  }

  /// Mengembalikan daftar blangkon baru yang terbuka saat naik dari [fromLevel] ke [toLevel].
  /// Hasil diurutkan dari level terendah ke tertinggi (hadiah tertinggi berada di elemen terakhir).
  static List<BlangkonType> getNewRewards(int fromLevel, int toLevel) {
    if (toLevel <= fromLevel) return const [];

    final rewards = <BlangkonType>[];
    for (final entry in requiredLevels.entries) {
      final reqLevel = entry.value;
      if (reqLevel != null && reqLevel > 1) {
        if (fromLevel < reqLevel && toLevel >= reqLevel) {
          if (hasRealPainter(entry.key)) {
            rewards.add(entry.key);
          }
        }
      }
    }

    // Urutkan berdasarkan level persyaratan (reward tertinggi di akhir)
    rewards.sort(
      (a, b) => (requiredLevels[a] ?? 0).compareTo(requiredLevels[b] ?? 0),
    );
    return rewards;
  }

  /// Nama kanonikal blangkon untuk tampilan UI.
  static String getName(BlangkonType type) {
    switch (type) {
      case BlangkonType.yogyakarta:
        return 'Blangkon Yogyakarta';
      case BlangkonType.surakarta:
        return 'Blangkon Surakarta';
      case BlangkonType.banyumas:
        return 'Blangkon Banyumas';
      case BlangkonType.kedu:
        return 'Blangkon Kedu';
      case BlangkonType.cirebon:
        return 'Blangkon Cirebon';
      case BlangkonType.pusaka:
        return 'Blangkon Pusaka';
    }
  }

  /// Label ringkas syarat pembukaan untuk kartu katalog.
  static String getRequirementLabel(BlangkonType type) {
    if (type == BlangkonType.yogyakarta) {
      return 'Terpasang awal';
    }
    if (type == BlangkonType.pusaka) {
      return 'Selesai aksara';
    }
    final level = requiredLevels[type];
    return level != null ? 'Level $level' : 'Terkunci';
  }
}
