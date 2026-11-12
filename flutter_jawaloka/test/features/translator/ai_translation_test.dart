import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/l10n/app_locales.dart';
import 'package:flutter_jawaloka/core/l10n/jv_localizations_delegate.dart';
import 'package:flutter_jawaloka/core/l10n/locale_controller.dart';
import 'package:flutter_jawaloka/core/l10n/locale_preferences.dart';
import 'package:flutter_jawaloka/core/l10n/locale_scope.dart';
import 'package:flutter_jawaloka/core/theme/app_theme.dart';
import 'package:flutter_jawaloka/features/translator/data/ai_translation_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';
import 'package:flutter_jawaloka/features/translator/presentation/screens/translator_screen.dart';
import 'package:flutter_jawaloka/l10n/app_localizations.dart';

Widget _buildApp({
  required LocaleController controller,
  required Widget child,
}) {
  return LocaleScope(
    controller: controller,
    child: Builder(
      builder: (context) {
        return MediaQuery(
          data: const MediaQueryData(size: Size(360, 800)),
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            locale: LocaleScope.of(context).locale,
            supportedLocales: AppLocales.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              JvMaterialLocalizationsDelegate(),
              JvCupertinoLocalizationsDelegate(),
              ...AppLocalizationDelegates.delegates,
            ],
            home: child,
          ),
        );
      },
    ),
  );
}

String _geminiOkEnvelope(String innerText) {
  return jsonEncode({
    'candidates': [
      {
        'finishReason': 'STOP',
        'content': {
          'parts': [
            {'text': innerText},
          ],
        },
      },
    ],
  });
}

void main() {
  group('GeminiTranslationBackend Unit Tests (Offline Fake Transport)', () {
    test(
      'Mengirim kunci lewat header x-goog-api-key (tidak di URL) dan mem-parse JSON valid',
      () async {
        Uri? capturedUri;
        Map<String, String>? capturedHeaders;
        String? capturedBody;
        int callCount = 0;

        final backend = GeminiTranslationBackend(
          apiKey: 'test-key-placeholder',
          model: 'gemini-test-model',
          httpPost:
              ({
                required Uri uri,
                required Map<String, String> headers,
                required String body,
                required Duration timeout,
              }) async {
                callCount++;
                capturedUri = uri;
                capturedHeaders = headers;
                capturedBody = body;
                return AiHttpResponse(
                  statusCode: 200,
                  body: _geminiOkEnvelope(
                    jsonEncode({
                      'detected_language': 'id',
                      'translation': 'Sugeng enjing',
                      'confidence': 'tinggi',
                      'note': 'Bentuk krama lazim',
                    }),
                  ),
                );
              },
        );

        final outcome = await backend.translate(
          text: 'Selamat pagi',
          target: TranslationVariant.jvKrama,
        );

        expect(callCount, equals(1));
        expect(
          capturedUri.toString(),
          equals(
            'https://generativelanguage.googleapis.com/v1beta/models/gemini-test-model:generateContent',
          ),
        );
        expect(capturedUri!.queryParameters, isEmpty);
        expect(capturedUri.toString(), isNot(contains('test-key-placeholder')));
        expect(
          capturedHeaders?['x-goog-api-key'],
          equals('test-key-placeholder'),
        );
        expect(capturedHeaders?['Content-Type'], equals('application/json'));

        final reqJson = jsonDecode(capturedBody!) as Map<String, dynamic>;
        final genConfig = reqJson['generationConfig'] as Map<String, dynamic>;
        expect(genConfig['responseMimeType'], equals('application/json'));
        expect(genConfig['temperature'], equals(0.2));

        expect(outcome, isA<AiTranslationSuccess>());
        final ok = outcome as AiTranslationSuccess;
        expect(ok.detectedLanguage, equals(AiDetectedLanguage.id));
        expect(ok.translation, equals('Sugeng enjing'));
        expect(ok.confidence, equals(AiConfidence.tinggi));
        expect(ok.note, equals('Bentuk krama lazim'));
      },
    );

    test('Mem-parse JSON di dalam pagar kode markdown ```json', () async {
      final backend = GeminiTranslationBackend(
        apiKey: 'test-key-placeholder',
        model: 'gemini-test-model',
        httpPost:
            ({
              required Uri uri,
              required Map<String, String> headers,
              required String body,
              required Duration timeout,
            }) async {
              return AiHttpResponse(
                statusCode: 200,
                body: _geminiOkEnvelope(
                  '```json\n{"detected_language":"en","translation":"Mangan","confidence":"sedang","note":""}\n```',
                ),
              );
            },
      );

      final outcome = await backend.translate(
        text: 'Eat',
        target: TranslationVariant.jvNgoko,
      );

      expect(outcome, isA<AiTranslationSuccess>());
      final ok = outcome as AiTranslationSuccess;
      expect(ok.detectedLanguage, equals(AiDetectedLanguage.en));
      expect(ok.translation, equals('Mangan'));
      expect(ok.confidence, equals(AiConfidence.sedang));
    });

    test('JSON rusak atau kolom wajib hilang ditangani ramah tanpa exception', () async {
      for (final badPayload in [
        'ini bukan json sama sekali',
        _geminiOkEnvelope('{json-rusak'),
        _geminiOkEnvelope('{"detected_language":"id","confidence":"tinggi"}'),
        _geminiOkEnvelope('{"translation":"Halo","confidence":"tinggi"}'),
        _geminiOkEnvelope('{"detected_language":"id","translation":"Halo"}'),
      ]) {
        final backend = GeminiTranslationBackend(
          apiKey: 'test-key-placeholder',
          model: 'gemini-test-model',
          httpPost:
              ({
                required Uri uri,
                required Map<String, String> headers,
                required String body,
                required Duration timeout,
              }) async {
                return AiHttpResponse(statusCode: 200, body: badPayload);
              },
        );

        final outcome = await backend.translate(
          text: 'Halo',
          target: TranslationVariant.jvNgoko,
        );
        expect(outcome, isA<AiTranslationFailure>());
        expect(
          (outcome as AiTranslationFailure).error,
          equals(AiTranslationError.other),
        );
      }
    });

    test('Respons kosong atau diblokir menghasilkan emptyOrBlocked', () async {
      final blockedPayloads = <String>[
        '',
        jsonEncode({
          'promptFeedback': {'blockReason': 'SAFETY'},
        }),
        jsonEncode({'candidates': []}),
        jsonEncode({
          'candidates': [
            {
              'finishReason': 'SAFETY',
              'content': {
                'parts': [
                  {'text': ''},
                ],
              },
            },
          ],
        }),
        _geminiOkEnvelope(
          jsonEncode({
            'detected_language': 'id',
            'translation': '   ',
            'confidence': 'rendah',
            'note': '',
          }),
        ),
      ];

      for (final payload in blockedPayloads) {
        final backend = GeminiTranslationBackend(
          apiKey: 'test-key-placeholder',
          model: 'gemini-test-model',
          httpPost:
              ({
                required Uri uri,
                required Map<String, String> headers,
                required String body,
                required Duration timeout,
              }) async => AiHttpResponse(statusCode: 200, body: payload),
        );
        final outcome = await backend.translate(
          text: 'Tes',
          target: TranslationVariant.en,
        );
        expect(outcome, isA<AiTranslationFailure>());
        expect(
          (outcome as AiTranslationFailure).error,
          equals(AiTranslationError.emptyOrBlocked),
        );
      }
    });

    test(
      'Pemetaan status 401/403, 429, timeout, noInternet tanpa percobaan ulang otomatis',
      () async {
        Future<AiTranslationError> runStatus(int status) async {
          int calls = 0;
          final backend = GeminiTranslationBackend(
            apiKey: 'test-key-placeholder',
            model: 'gemini-test-model',
            httpPost:
                ({
                  required Uri uri,
                  required Map<String, String> headers,
                  required String body,
                  required Duration timeout,
                }) async {
                  calls++;
                  return AiHttpResponse(statusCode: status, body: '{}');
                },
          );
          final res = await backend.translate(
            text: 'Halo',
            target: TranslationVariant.en,
          );
          expect(calls, equals(1));
          return (res as AiTranslationFailure).error;
        }

        expect(await runStatus(401), equals(AiTranslationError.invalidKey));
        expect(await runStatus(403), equals(AiTranslationError.invalidKey));
        expect(await runStatus(429), equals(AiTranslationError.quotaExceeded));

        int timeoutCalls = 0;
        final timeoutBackend = GeminiTranslationBackend(
          apiKey: 'test-key-placeholder',
          model: 'gemini-test-model',
          httpPost:
              ({
                required Uri uri,
                required Map<String, String> headers,
                required String body,
                required Duration timeout,
              }) async {
                timeoutCalls++;
                throw TimeoutException('15s');
              },
        );
        final timeoutRes = await timeoutBackend.translate(
          text: 'Halo',
          target: TranslationVariant.en,
        );
        expect(timeoutCalls, equals(1));
        expect(
          (timeoutRes as AiTranslationFailure).error,
          equals(AiTranslationError.timeout),
        );

        int socketCalls = 0;
        final offlineBackend = GeminiTranslationBackend(
          apiKey: 'test-key-placeholder',
          model: 'gemini-test-model',
          httpPost:
              ({
                required Uri uri,
                required Map<String, String> headers,
                required String body,
                required Duration timeout,
              }) async {
                socketCalls++;
                throw const SocketException('offline');
              },
        );
        final offlineRes = await offlineBackend.translate(
          text: 'Halo',
          target: TranslationVariant.en,
        );
        expect(socketCalls, equals(1));
        expect(
          (offlineRes as AiTranslationFailure).error,
          equals(AiTranslationError.noInternet),
        );
      },
    );

    test('apiKey kosong menonaktifkan backend dan nol panggilan transport', () async {
      int calls = 0;
      final backend = GeminiTranslationBackend(
        apiKey: '',
        httpPost:
            ({
              required Uri uri,
              required Map<String, String> headers,
              required String body,
              required Duration timeout,
            }) async {
              calls++;
              return const AiHttpResponse(statusCode: 200, body: '{}');
            },
      );

      expect(backend.isConfigured, isFalse);
      final outcome = await backend.translate(
        text: 'Selamat pagi',
        target: TranslationVariant.en,
      );
      expect(calls, equals(0));
      expect(outcome, isA<AiTranslationFailure>());
      expect(
        (outcome as AiTranslationFailure).error,
        equals(AiTranslationError.disabled),
      );
    });

    test('Bahasa terdeteksi sama dengan tujuan menghasilkan sameLanguage', () async {
      final backend = GeminiTranslationBackend(
        apiKey: 'test-key-placeholder',
        model: 'gemini-test-model',
        httpPost:
            ({
              required Uri uri,
              required Map<String, String> headers,
              required String body,
              required Duration timeout,
            }) async => AiHttpResponse(
              statusCode: 200,
              body: _geminiOkEnvelope(
                jsonEncode({
                  'detected_language': 'id',
                  'translation': 'Selamat pagi',
                  'confidence': 'tinggi',
                  'note': '',
                }),
              ),
            ),
      );

      final outcome = await backend.translate(
        text: 'Selamat pagi',
        target: TranslationVariant.id,
      );
      expect(outcome, isA<AiTranslationFailure>());
      expect(
        (outcome as AiTranslationFailure).error,
        equals(AiTranslationError.sameLanguage),
      );
    });

    test('Input invalid (>200 atau kosong) ditolak sebelum memanggil transport', () async {
      int calls = 0;
      final backend = GeminiTranslationBackend(
        apiKey: 'test-key-placeholder',
        model: 'gemini-test-model',
        httpPost:
            ({
              required Uri uri,
              required Map<String, String> headers,
              required String body,
              required Duration timeout,
            }) async {
              calls++;
              return const AiHttpResponse(statusCode: 200, body: '{}');
            },
      );

      await backend.translate(text: '   ', target: TranslationVariant.en);
      await backend.translate(text: 'a' * 201, target: TranslationVariant.en);
      expect(calls, equals(0));
    });
  });

  group('TranslatorScreen AI Integration Widget Tests', () {
    Future<LocaleController> createLocaleController([String code = 'id']) async {
      final ctrl = LocaleController(
        preferences: InMemoryLocalePreferences(
          initialLocale: code,
          initialHasChosen: true,
        ),
      );
      await ctrl.loadSavedLocale();
      return ctrl;
    }

    testWidgets(
      'apiKey kosong: tombol AI nonaktif, tampil pesan belum diaktifkan, nol panggilan jaringan',
      (tester) async {
        final ctrl = await createLocaleController();
        int calls = 0;
        final disabledBackend = GeminiTranslationBackend(
          apiKey: '',
          httpPost:
              ({
                required Uri uri,
                required Map<String, String> headers,
                required String body,
                required Duration timeout,
              }) async {
                calls++;
                return const AiHttpResponse(statusCode: 200, body: '{}');
              },
        );

        await tester.pumpWidget(
          _buildApp(
            controller: ctrl,
            child: TranslatorScreen(aiTranslationBackend: disabledBackend),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(const Key('translator_ai_button')), findsNothing);
        expect(find.text('Fitur AI belum diaktifkan'), findsNothing);
        expect(calls, equals(0));
      },
    );

    testWidgets(
      'Penerjemah offline tidak memanggil backend AI sama sekali dan tidak menampilkan label AI',
      (tester) async {
        final ctrl = await createLocaleController();
        int aiCalls = 0;
        final countingBackend = GeminiTranslationBackend(
          apiKey: 'test-key-placeholder',
          model: 'gemini-test-model',
          httpPost:
              ({
                required Uri uri,
                required Map<String, String> headers,
                required String body,
                required Duration timeout,
              }) async {
                aiCalls++;
                return const AiHttpResponse(statusCode: 200, body: '{}');
              },
        );

        await tester.pumpWidget(
          _buildApp(
            controller: ctrl,
            child: TranslatorScreen(aiTranslationBackend: countingBackend),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Terima kasih');
        await tester.pumpAndSettle();

        await tester.tap(find.text('Terjemahkan'));
        await tester.pumpAndSettle();

        expect(find.text('Matur nuwun'), findsOneWidget);
        expect(
          find.text('Terjemahan AI (perkiraan), belum diperiksa penutur Jawa'),
          findsNothing,
        );
        expect(aiCalls, equals(0));
      },
    );

    testWidgets(
      'Validasi input, pemilih Otomatis, label hasil AI, penolakan bahasa sama, dan anti-double-tap',
      (tester) async {
        final ctrl = await createLocaleController();
        int aiCalls = 0;

        final backend = GeminiTranslationBackend(
          apiKey: 'test-key-placeholder',
          model: 'gemini-test-model',
          httpPost:
              ({
                required Uri uri,
                required Map<String, String> headers,
                required String body,
                required Duration timeout,
              }) async {
                aiCalls++;
                if (aiCalls == 2) {
                  return AiHttpResponse(
                    statusCode: 200,
                    body: _geminiOkEnvelope(
                      jsonEncode({
                        'detected_language': 'jv_ngoko',
                        'translation': 'Aku arep mangan',
                        'confidence': 'tinggi',
                        'note': '',
                      }),
                    ),
                  );
                }
                return AiHttpResponse(
                  statusCode: 200,
                  body: _geminiOkEnvelope(
                    jsonEncode({
                      'detected_language': 'id',
                      'translation': 'Aku arep mangan sega',
                      'confidence': 'sedang',
                      'note': 'Perkiraan ngoko',
                    }),
                  ),
                );
              },
        );

        await tester.pumpWidget(
          _buildApp(
            controller: ctrl,
            child: TranslatorScreen(aiTranslationBackend: backend),
          ),
        );
        await tester.pumpAndSettle();

        // Catatan privasi tampil di bawah tombol AI
        expect(
          find.text('Teks yang kamu ketik dikirim ke Google Gemini.'),
          findsOneWidget,
        );

        // Input kosong -> ditolak validator, nol panggilan AI
        final aiBtnFinder = find.byKey(const Key('translator_ai_button'));
        await tester.ensureVisible(aiBtnFinder);
        await tester.tap(aiBtnFinder);
        await tester.pumpAndSettle();
        expect(aiCalls, equals(0));
        expect(
          find.text('Teks terjemahan tidak boleh kosong'),
          findsOneWidget,
        );

        // Pilih sumber "Otomatis" di picker bahasa asal
        final fromChip = find.text('Indonesia').first;
        await tester.ensureVisible(fromChip);
        await tester.pumpAndSettle();
        await tester.tap(fromChip);
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('translator_lang_auto_option')));
        await tester.pumpAndSettle();
        expect(find.text('Otomatis'), findsWidgets);

        // Masukkan teks valid dan ketuk tombol AI dua kali berturut-turut saat cooldown
        await tester.enterText(find.byType(TextField), 'Saya mau makan nasi');
        await tester.pumpAndSettle();
        await tester.ensureVisible(aiBtnFinder);
        await tester.tap(aiBtnFinder);
        await tester.pump();
        // Ketukan kedua selama jeda cooldown tidak memicu panggilan kedua
        await tester.tap(aiBtnFinder);
        await tester.pumpAndSettle();

        expect(aiCalls, equals(1));
        expect(find.text('Aku arep mangan sega'), findsOneWidget);
        expect(
          find.text('Terjemahan AI (perkiraan), belum diperiksa penutur Jawa'),
          findsOneWidget,
        );
        expect(
          find.text('Terdeteksi: Indonesia • Keyakinan: Sedang'),
          findsOneWidget,
        );

        // Skenario 2: sumber terdeteksi sama dengan tujuan -> pesan ARB
        await tester.enterText(find.byType(TextField), 'Aku arep mangan');
        await tester.pumpAndSettle();
        await tester.ensureVisible(aiBtnFinder);
        await tester.tap(aiBtnFinder);
        await tester.pumpAndSettle();

        expect(aiCalls, equals(2));
        expect(find.text('Bahasa sumber dan tujuan sama'), findsOneWidget);
      },
    );

    testWidgets(
      'Semua jenis galat AI menampilkan pesan ramah berbahasa aplikasi tanpa crash',
      (tester) async {
        final ctrl = await createLocaleController();
        final errors = <({AiTranslationError err, String expectedText})>[
          (
            err: AiTranslationError.noInternet,
            expectedText:
                'Tidak ada koneksi internet. Coba lagi nanti atau gunakan kamus offline.',
          ),
          (
            err: AiTranslationError.invalidKey,
            expectedText: 'Kunci API AI tidak valid atau ditolak (401/403).',
          ),
          (
            err: AiTranslationError.quotaExceeded,
            expectedText:
                'Kuota permintaan AI tercapai (429). Coba lagi nanti.',
          ),
          (
            err: AiTranslationError.timeout,
            expectedText: 'Permintaan AI melebihi batas waktu 15 detik.',
          ),
          (
            err: AiTranslationError.emptyOrBlocked,
            expectedText:
                'Respons AI kosong atau diblokir oleh filter keamanan.',
          ),
        ];

        int idx = 0;
        final backend = _QueueFakeAiBackend(() {
          final current = errors[idx].err;
          idx++;
          return AiTranslationFailure(current);
        });

        await tester.pumpWidget(
          _buildApp(
            controller: ctrl,
            child: TranslatorScreen(aiTranslationBackend: backend),
          ),
        );
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField), 'Selamat pagi');
        await tester.pumpAndSettle();
        final aiBtnFinder = find.byKey(const Key('translator_ai_button'));

        for (final entry in errors) {
          await tester.ensureVisible(aiBtnFinder);
          await tester.tap(aiBtnFinder);
          await tester.pumpAndSettle();
          expect(find.text(entry.expectedText), findsOneWidget);
        }
      },
    );
  });
}

class _QueueFakeAiBackend implements AiTranslationBackend {
  final AiTranslationOutcome Function() _next;
  _QueueFakeAiBackend(this._next);

  @override
  bool get isConfigured => true;

  @override
  Future<AiTranslationOutcome> translate({
    required String text,
    required TranslationVariant target,
  }) async => _next();
}
