import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fontPath = Directory.current.path.endsWith('flutter_jawaloka')
      ? 'assets/fonts/NotoSansJavanese-Regular.ttf'
      : 'flutter_jawaloka/assets/fonts/NotoSansJavanese-Regular.ttf';
  final fontFile = File(fontPath);
  final bool fontExists = fontFile.existsSync();

  group('NotoSansJavanese Binary Mask Rendering Tests', () {
    test(
      'renders ꦲ, ꦤ, ꦒ distinctly with ink > 0 when font is loaded',
      () async {
        const glyphs = ['ꦲ', 'ꦤ', 'ꦒ'];

        // Load font bytes and register into Flutter FontLoader
        final fontBytes = await fontFile.readAsBytes();
        final fontData = ByteData.sublistView(fontBytes);
        final loader = FontLoader('NotoSansJavanese');
        loader.addFont(Future.value(fontData));
        await loader.load();

        final masks = <String, Uint8List>{};
        final inkCounts = <String, int>{};

        for (final glyph in glyphs) {
          final textPainter = TextPainter(
            text: TextSpan(
              text: glyph,
              style: const TextStyle(
                fontSize: 64,
                fontFamily: 'NotoSansJavanese',
                color: Colors.black,
              ),
            ),
            textDirection: TextDirection.ltr,
          )..layout();

          final recorder = ui.PictureRecorder();
          final canvas = Canvas(recorder);
          textPainter.paint(canvas, Offset.zero);

          final picture = recorder.endRecording();
          final width = textPainter.width.ceil().clamp(1, 200);
          final height = textPainter.height.ceil().clamp(1, 200);
          final image = await picture.toImage(width, height);
          final byteData =
              await image.toByteData(format: ui.ImageByteFormat.rawRgba);

          expect(byteData, isNotNull);
          final bytes = byteData!.buffer.asUint8List();

          // Calculate binary mask: 1 where alpha > 30, 0 otherwise
          final binaryMask = Uint8List(width * height);
          int ink = 0;
          for (int i = 0; i < binaryMask.length; i++) {
            final alpha = bytes[i * 4 + 3];
            if (alpha > 30) {
              binaryMask[i] = 1;
              ink++;
            }
          }

          masks[glyph] = binaryMask;
          inkCounts[glyph] = ink;
        }

        for (final glyph in glyphs) {
          expect(inkCounts[glyph]!, greaterThan(0),
              reason: 'Glyph $glyph must have non-zero ink');
        }

        expect(masks['ꦲ'], isNot(equals(masks['ꦤ'])),
            reason: 'ꦲ and ꦤ masks must be distinct');
        expect(masks['ꦲ'], isNot(equals(masks['ꦒ'])),
            reason: 'ꦲ and ꦒ masks must be distinct');
        expect(masks['ꦤ'], isNot(equals(masks['ꦒ'])),
            reason: 'ꦤ and ꦒ masks must be distinct');
      },
      skip: !fontExists ? 'font belum ditaruh di assets/fonts' : false,
    );
  });
}
