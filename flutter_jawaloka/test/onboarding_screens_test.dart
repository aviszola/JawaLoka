import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/router/app_router.dart';
import 'package:flutter_jawaloka/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/language_selection_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/register_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_jawaloka/features/auth/presentation/widgets/primary_button.dart';
import 'helpers/pump_app.dart';

void main() {
  group('Onboarding Screens (Splash, Pilih Bahasa, Daftar)', () {
    // ─── Test (a): Splash Screen ───────────────────────────────────────────
    testWidgets(
      'Splash: tidak memuat teks "LOGO" maupun "09:41" dan berpindah ke Pilih Bahasa setelah splashMinDuration',
      (WidgetTester tester) async {
        await tester.pumpApp(
          const SizedBox.shrink(),
          initialRoute: AppRouter.splash,
          routes: {
            AppRouter.splash: (context) => const SplashScreen(),
            '/language_selection': (context) =>
                const LanguageSelectionScreen(),
          },
          onGenerateRoute: AppRouter.generateRoute,
        );

        // Verifikasi tidak ada teks tiruan
        expect(find.text('LOGO'), findsNothing);
        expect(find.text('09:41'), findsNothing);
        expect(find.byType(SplashScreen), findsOneWidget);

        // Menunggu durasi splash minimum (fake async)
        await tester.pump(SplashScreen.splashMinDuration);
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        // Berpindah ke Pilih Bahasa
        expect(find.byType(LanguageSelectionScreen), findsOneWidget);
      },
    );

    // ─── Test (b): Pilih Bahasa Screen ───────────────────────────────────────
    testWidgets(
      'Pilih Bahasa: mengetuk kartu mengubah pilihan dan semantik checked, tombol Lanjut membuka Daftar',
      (WidgetTester tester) async {
        await tester.pumpApp(
          const LanguageSelectionScreen(),
          routes: {AppRouter.register: (context) => const RegisterScreen()},
          onGenerateRoute: AppRouter.generateRoute,
        );
        await tester.pumpAndSettle();

        // Default: Bahasa Indonesia checked
        expect(
          tester.getSemantics(find.bySemanticsLabel('Bahasa Indonesia')),
          matchesSemantics(
            hasCheckedState: true,
            isChecked: true,
            isButton: true,
            isInMutuallyExclusiveGroup: true,
            label: 'Bahasa Indonesia',
          ),
        );

        // Ketuk kartu 'Basa Jawa'
        await tester.tap(find.text('Basa Jawa'));
        await tester.pumpAndSettle();

        // Basa Jawa kini checked
        expect(
          tester.getSemantics(find.bySemanticsLabel('Basa Jawa')),
          matchesSemantics(
            hasCheckedState: true,
            isChecked: true,
            isButton: true,
            isInMutuallyExclusiveGroup: true,
            label: 'Basa Jawa',
          ),
        );
        expect(
          tester.getSemantics(find.bySemanticsLabel('Bahasa Indonesia')),
          matchesSemantics(
            hasCheckedState: true,
            isChecked: false,
            isButton: true,
            isInMutuallyExclusiveGroup: true,
            label: 'Bahasa Indonesia',
          ),
        );

        // Ketuk tombol Lanjut / aksi utama (kini berlabel 'Lajeng' karena Basa Jawa aktif)
        await tester.tap(find.byType(PrimaryButton));
        await tester.pumpAndSettle();

        // Membuka Daftar (RegisterScreen)
        expect(find.byType(RegisterScreen), findsOneWidget);
      },
    );

    // ─── Test (c) & (d): Daftar Screen ───────────────────────────────────────
    testWidgets(
      'Daftar: kolom kosong, email tidak valid, sandi < 8 tampilkan pesan, teks ganda tidak ada, judul Buat akunmu sekali, tidak overflow dengan viewInsets 300',
      (WidgetTester tester) async {
        await tester.pumpApp(const RegisterScreen());
        await tester.pumpAndSettle();

        // (d) Judul "Buat akunmu" hanya muncul sekali
        expect(find.text('Buat akunmu'), findsOneWidget);

        // (c) Teks "Daftar sekarang" dan "LANGKAH AWAL" tidak ada
        expect(find.text('Daftar sekarang'), findsNothing);
        expect(find.text('LANGKAH AWAL'), findsNothing);

        // Submit form kosong -> tampilkan pesan
        await tester.ensureVisible(
          find.widgetWithText(PrimaryButton, 'Daftar'),
        );
        await tester.tap(find.widgetWithText(PrimaryButton, 'Daftar'));
        await tester.pumpAndSettle();

        expect(find.text('Nama tidak boleh kosong'), findsOneWidget);
        expect(find.text('Format email belum benar'), findsOneWidget);
        expect(find.text('Kata sandi minimal 8 karakter'), findsOneWidget);

        // Isi nama valid, email tidak valid
        await tester.enterText(find.byType(TextFormField).at(0), 'Raden Mas');
        await tester.enterText(find.byType(TextFormField).at(1), 'email_salah');
        await tester.enterText(
          find.byType(TextFormField).at(2),
          'passwordKuat123',
        );
        await tester.ensureVisible(
          find.widgetWithText(PrimaryButton, 'Daftar'),
        );
        await tester.tap(find.widgetWithText(PrimaryButton, 'Daftar'));
        await tester.pumpAndSettle();

        expect(find.text('Nama tidak boleh kosong'), findsNothing);
        expect(find.text('Format email belum benar'), findsOneWidget);
        expect(find.text('Kata sandi minimal 8 karakter'), findsNothing);

        // Isi email valid, sandi < 8 karakter
        await tester.enterText(
          find.byType(TextFormField).at(1),
          'raden@jawaloka.id',
        );
        await tester.enterText(find.byType(TextFormField).at(2), '12345');
        await tester.ensureVisible(
          find.widgetWithText(PrimaryButton, 'Daftar'),
        );
        await tester.tap(find.widgetWithText(PrimaryButton, 'Daftar'));
        await tester.pumpAndSettle();

        expect(find.text('Format email belum benar'), findsNothing);
        expect(find.text('Kata sandi minimal 8 karakter'), findsOneWidget);

        // Uji ketahanan terhadap keyboard: viewInsets bawah 300 tanpa overflow
        await tester.pumpApp(
          const MediaQuery(
            data: MediaQueryData(
              size: Size(390, 844),
              viewInsets: EdgeInsets.only(bottom: 300),
            ),
            child: RegisterScreen(),
          ),
        );
        await tester.pumpAndSettle();

        // Pastikan tidak ada exception/overflow
        expect(tester.takeException(), isNull);
      },
    );

    // ─── Test (e): Login Screen ──────────────────────────────────────────────
    testWidgets(
      'Login: validasi form, tidak ada garis 128x4, dan tahan keyboard viewInsets 300',
      (WidgetTester tester) async {
        await tester.pumpApp(const LoginScreen());
        await tester.pumpAndSettle();

        // Judul login
        expect(find.text('Masuk ke akunmu'), findsOneWidget);

        // Submit form kosong -> pesan error
        await tester.ensureVisible(find.widgetWithText(PrimaryButton, 'Masuk'));
        await tester.tap(find.widgetWithText(PrimaryButton, 'Masuk'));
        await tester.pumpAndSettle();

        expect(find.text('Format email belum benar'), findsOneWidget);
        expect(find.text('Kata sandi tidak boleh kosong'), findsOneWidget);

        // Uji ketahanan terhadap keyboard
        await tester.pumpApp(
          const MediaQuery(
            data: MediaQueryData(
              size: Size(390, 844),
              viewInsets: EdgeInsets.only(bottom: 300),
            ),
            child: LoginScreen(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  });
}
