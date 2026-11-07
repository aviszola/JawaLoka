// DATA CONTOH
// Sumber data tunggal untuk metrik dan profil pengguna statis saat pengujian.

class MockUserStats {
  MockUserStats._();

  // DATA CONTOH: nama bawaan "Dimas" dipakai sampai ada backend
  static const String userName = 'Dimas';
  static const int userLevel = 4;
  static const int streakDays = 5;
  static const int quizzesThisWeek = 8;
  static const int totalCompletedQuizzes = 7;

  /// Indeks hari dalam seminggu di mana kuis berhasil diselesaikan (1 = Senin, ..., 7 = Minggu)
  static const List<int> completedQuizDaysOfWeek = [1, 2, 3, 4, 5];

  /// Status apakah seluruh materi aksara dasar telah diselesaikan
  static const bool hasMasteredAksara = false;
}

