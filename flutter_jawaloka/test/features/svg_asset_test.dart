import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  testWidgets('renders all character SVGs cleanly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              SvgPicture.asset(
                'assets/images/characters/avatar_putra.svg',
                width: 100,
                height: 100,
              ),
              SvgPicture.asset(
                'assets/images/characters/avatar_putri.svg',
                width: 100,
                height: 100,
              ),
              SvgPicture.asset(
                'assets/images/characters/karakter_putra.svg',
                width: 100,
                height: 100,
              ),
              SvgPicture.asset(
                'assets/images/characters/karakter_putri.svg',
                width: 100,
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(SvgPicture), findsNWidgets(4));
  });
}
