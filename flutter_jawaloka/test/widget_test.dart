import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/main.dart';
import 'package:flutter_jawaloka/features/splash/presentation/screens/splash_screen.dart';

void main() {
  testWidgets('JawaLoka splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JawaLokaApp());

    // Verify that the Splash Screen is present.
    expect(find.byType(SplashScreen), findsOneWidget);

    // Verify brand name and tagline exist.
    expect(find.text('JawaLoka'), findsOneWidget);
    expect(find.text('Belajar bahasa dan aksara Jawa setiap hari'), findsOneWidget);
  });
}
