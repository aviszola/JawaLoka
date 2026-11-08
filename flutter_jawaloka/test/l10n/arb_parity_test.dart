import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ARB Parity & Quality Guardrails', () {
    late Map<String, dynamic> arbId;
    late Map<String, dynamic> arbJv;
    late Map<String, dynamic> arbEn;
    late List<String> templateKeys;

    const kJvPendingKeys = <String>{
      'registerTermsPrefix',
      'registerPrivacyPolicy',
      'learnModuleEtiquetteTitle',
      'learnTagKamus',
      'translatorMockUnavailable',
    };

    // Allowed exceptions where Javanese or English text may legitimately match Indonesian
    // (e.g. loanwords, shared regional terms, brand names, or endonyms)
    const allowedIdenticalWithId = <String>{
      'langSelectIdSub', // "Bawaan" is acceptable in both ID and JV draft
      'splashAppName', // Brand name
      'authEmailLabel', // International technical term
      'settingsAccountEmailLabel', // International technical term
      'navHome',
      'navQuest',
      'navQuiz',
      'navProfile',
      'dayMon',
      'dayTue',
      'dayFri',
      'homeLevelPill',
      'homeHeroQuestTitle',
      'homeHeroQuestTarget',
      'homeContinueQuizNode',
      'homeQuickLearnAksara',
      'homeQuickLearnAksaraSub',
      'homeQuickLearnTranslator',
      'homeQuickLearnTranslatorSub',
      'homeQuickLearnEtiquetteSub',
      'homeQuickLearnProverbsSub',
      'learnSectionDailyWord',
      'learnModuleAksaraTitle',
      'learnTagAksara',
      'learnTagWicara',
      'learnTagSastra',
      'quizTopicSalam',
      'quizTopicPamit',
      'quizTopicLencana',
      'quizTopicNgoko',
      'quizTopicKrama',
      'quizOptionSemantics',
      'quizResultAwesome',
      'dailyResultTargetScript',
      'dailyResultStatusPassed',
      'dailyResultRequirement',
      'profileTitle',
      'profileLevelPill',
      'profileBadgeTitle',
      'profileBadgeCollection',
      'profileBadgeLevel5Title',
      'profileBadgeAksaraCompleteTitle',
      'profileChooseBlangkonButton',
      'blangkonTitle',
      'blangkonLevelRequired',
      'levelUpMicroTag',
      'levelUpTitle',
      'levelUpAchievementTitle',
      'settingsClose',
      'settingsAccountRow',
      'translatorTitle',
      'aksaraDetailTitle',
      'aksaraDetailSandanganHeader',
      'quizMilestoneNode',
      'quizCloseSemantics',
      'learnUnggahNgokoLuguTitle',
      'learnUnggahNgokoAlusTitle',
      'learnUnggahKramaLuguTitle',
      'learnUnggahKramaInggilTitle',
      ...kJvPendingKeys,
    };

    setUpAll(() {
      final baseDir = Directory.current.path.endsWith('flutter_jawaloka')
          ? Directory.current.path
          : '${Directory.current.path}/flutter_jawaloka';

      final fileId = File('$baseDir/lib/l10n/app_id.arb');
      final fileJv = File('$baseDir/lib/l10n/app_jv.arb');
      final fileEn = File('$baseDir/lib/l10n/app_en.arb');

      expect(fileId.existsSync(), isTrue, reason: 'app_id.arb must exist');
      expect(fileJv.existsSync(), isTrue, reason: 'app_jv.arb must exist');
      expect(fileEn.existsSync(), isTrue, reason: 'app_en.arb must exist');

      arbId = json.decode(fileId.readAsStringSync()) as Map<String, dynamic>;
      arbJv = json.decode(fileJv.readAsStringSync()) as Map<String, dynamic>;
      arbEn = json.decode(fileEn.readAsStringSync()) as Map<String, dynamic>;

      templateKeys = arbId.keys
          .where((k) => !k.startsWith('@'))
          .toList()
        ..sort();
    });

    test('All template keys must exist in both app_jv.arb and app_en.arb', () {
      for (final key in templateKeys) {
        expect(
          arbJv.containsKey(key),
          isTrue,
          reason: 'Key "$key" defined in template app_id.arb is MISSING in app_jv.arb',
        );
        expect(
          arbEn.containsKey(key),
          isTrue,
          reason: 'Key "$key" defined in template app_id.arb is MISSING in app_en.arb',
        );
      }
    });

    test('No orphan keys in app_jv.arb or app_en.arb that are missing in template', () {
      for (final key in arbJv.keys.where((k) => !k.startsWith('@'))) {
        expect(
          templateKeys.contains(key),
          isTrue,
          reason: 'Orphan key "$key" in app_jv.arb does not exist in template app_id.arb',
        );
      }
      for (final key in arbEn.keys.where((k) => !k.startsWith('@'))) {
        expect(
          templateKeys.contains(key),
          isTrue,
          reason: 'Orphan key "$key" in app_en.arb does not exist in template app_id.arb',
        );
      }
    });

    test('No empty string values in any ARB file', () {
      for (final key in templateKeys) {
        final valId = (arbId[key] as String).trim();
        final valJv = (arbJv[key] as String).trim();
        final valEn = (arbEn[key] as String).trim();

        expect(valId.isNotEmpty, isTrue, reason: 'Key "$key" has empty value in app_id.arb');
        expect(valJv.isNotEmpty, isTrue, reason: 'Key "$key" has empty value in app_jv.arb');
        expect(valEn.isNotEmpty, isTrue, reason: 'Key "$key" has empty value in app_en.arb');
      }
    });

    test('Placeholders must match identically across all three languages', () {
      final placeholderRegex = RegExp(r'\{([a-zA-Z0-9_]+)[,\}]');

      for (final key in templateKeys) {
        final valId = arbId[key] as String;
        final valJv = arbJv[key] as String;
        final valEn = arbEn[key] as String;

        final paramsId = placeholderRegex.allMatches(valId).map((m) => m.group(1)!).toSet();
        final paramsJv = placeholderRegex.allMatches(valJv).map((m) => m.group(1)!).toSet();
        final paramsEn = placeholderRegex.allMatches(valEn).map((m) => m.group(1)!).toSet();

        expect(
          paramsJv,
          equals(paramsId),
          reason: 'Placeholders for key "$key" in app_jv.arb ($paramsJv) do not match template ($paramsId)',
        );
        expect(
          paramsEn,
          equals(paramsId),
          reason: 'Placeholders for key "$key" in app_en.arb ($paramsEn) do not match template ($paramsId)',
        );
      }
    });

    test('No ARB value in any language contains "TODO" or "[PERLU"', () {
      for (final key in templateKeys) {
        final valId = arbId[key] as String;
        final valJv = arbJv[key] as String;
        final valEn = arbEn[key] as String;

        expect(valId.contains('TODO'), isFalse, reason: 'app_id.arb key "$key" contains TODO');
        expect(valId.contains('[PERLU'), isFalse, reason: 'app_id.arb key "$key" contains [PERLU');
        expect(valJv.contains('TODO'), isFalse, reason: 'app_jv.arb key "$key" contains TODO');
        expect(valJv.contains('[PERLU'), isFalse, reason: 'app_jv.arb key "$key" contains [PERLU');
        expect(valEn.contains('TODO'), isFalse, reason: 'app_en.arb key "$key" contains TODO');
        expect(valEn.contains('[PERLU'), isFalse, reason: 'app_en.arb key "$key" contains [PERLU');
      }
    });

    test('Non-exempt keys must not be character-for-character copies of Indonesian text', () {
      for (final key in templateKeys) {
        if (allowedIdenticalWithId.contains(key)) continue;

        final valId = arbId[key] as String;
        final valJv = arbJv[key] as String;
        final valEn = arbEn[key] as String;

        expect(
          valJv,
          isNot(equals(valId)),
          reason: 'Key "$key" in app_jv.arb is identical to Indonesian text. '
              'Provide a valid Javanese translation or add to allowedIdenticalWithId exception list.',
        );
        expect(
          valEn,
          isNot(equals(valId)),
          reason: 'Key "$key" in app_en.arb is identical to Indonesian text. '
              'Provide a valid English translation or add to allowedIdenticalWithId exception list.',
        );
      }
    });
  });
}

