import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/features/translator/data/offline_dictionary_service.dart';
import 'package:flutter_jawaloka/features/translator/domain/translation_models.dart';

void main() {
  const service = OfflineDictionaryService();

  group('English Translation Enhancement Tests', () {
    test('1. English Functional Grammar (prepositions, conjunctions, particles)', () async {
      // Conjunctions
      final andRes = await service.translate(
        text: 'and',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((andRes as Found).text, equals('lan'));

      final orRes = await service.translate(
        text: 'or',
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((orRes as Found).text, equals('utawi'));

      final butRes = await service.translate(
        text: 'but',
        from: TranslationVariant.en,
        to: TranslationVariant.id,
      );
      expect((butRes as Found).text, equals('tetapi'));

      // Prepositions
      final inRes = await service.translate(
        text: 'in',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((inRes as Found).text, equals('neng'));

      final toRes = await service.translate(
        text: 'to',
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((toRes as Found).text, equals('dhateng'));

      final fromRes = await service.translate(
        text: 'from',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((fromRes as Found).text, equals('saka'));

      final withRes = await service.translate(
        text: 'with',
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((withRes as Found).text, equals('kaliyan'));

      // Negation & Modals
      final doNotRes = await service.translate(
        text: 'do not',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((doNotRes as Found).text, equals('aja'));

      final dontRes = await service.translate(
        text: "don't",
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((dontRes as Found).text, equals('sampun'));

      // Conversational idioms
      final thankYouRes = await service.translate(
        text: 'thank you very much',
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((thankYouRes as Found).text, equals('matur nuwun sanget'));
    });

    test('2. English Spelling & Canonical Aliases', () async {
      // Third person pronouns
      final heRes = await service.translate(
        text: 'he',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((heRes as Found).text, equals('Dheweke'));

      final sheRes = await service.translate(
        text: 'she',
        from: TranslationVariant.en,
        to: TranslationVariant.id,
      );
      expect((sheRes as Found).text, equals('Dia'));

      // Locations & Relatives
      final homeRes = await service.translate(
        text: 'home',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((homeRes as Found).text, equals('Omah'));

      final dadRes = await service.translate(
        text: 'dad',
        from: TranslationVariant.en,
        to: TranslationVariant.id,
      );
      expect((dadRes as Found).text, equals('Ayah'));

      // Multi-word phrase aliases
      final takeRes = await service.translate(
        text: 'take',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((takeRes as Found).text, equals('Njupuk'));

      final heartRes = await service.translate(
        text: 'heart',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((heartRes as Found).text, equals('Jantung'));

      final innerHeartRes = await service.translate(
        text: 'inner heart',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((innerHeartRes as Found).text, equals('Ati'));

      final danceRes = await service.translate(
        text: 'dance',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((danceRes as Found).text, equals('Joged'));

      // Irregular past verbs
      final wentRes = await service.translate(
        text: 'went',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((wentRes as Found).text, equals('Lunga'));

      final ateRes = await service.translate(
        text: 'ate',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((ateRes as Found).text, equals('Mangan'));

      final sleptRes = await service.translate(
        text: 'slept',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((sleptRes as Found).text, equals('Turu'));
    });

    test('3. English Morphology & Inflection Stemming', () async {
      // Suffix -s & -es
      final sleepsRes = await service.translate(
        text: 'sleeps',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((sleepsRes as Found).text, equals('Turu'));

      final goesRes = await service.translate(
        text: 'goes',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((goesRes as Found).text, equals('Lunga'));

      final booksRes = await service.translate(
        text: 'books',
        from: TranslationVariant.en,
        to: TranslationVariant.id,
      );
      expect((booksRes as Found).text, equals('Buku'));

      // Suffix -ing
      final walkingRes = await service.translate(
        text: 'walking',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((walkingRes as Found).text, equals('Mlaku'));

      final goingRes = await service.translate(
        text: 'going',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((goingRes as Found).text, equals('Lunga'));

      // Suffix -ed
      final walkedRes = await service.translate(
        text: 'walked',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((walkedRes as Found).text, equals('Mlaku'));
    });

    test('4. English Copulas, Progressive Aspect & Articles', () async {
      // Progressive aspect with copula: 'is reading'
      final progRes = await service.translate(
        text: 'He is reading a book',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((progRes as Found).text, equals('Dheweke lagi Maca Buku'));

      final progKrama = await service.translate(
        text: 'He is reading a book',
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((progKrama as Found).text, equals('Piyambakipun nembe Maos Buku'));

      // Articles 'a', 'an', 'the' smoothly omitted without emitting [?]
      final artRes = await service.translate(
        text: 'Mother goes to the market',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((artRes as Found).text, equals('Ibu Lunga menyang Pasar'));
      expect(artRes.text.contains('[?]'), isFalse);

      // Inverted copula question: 'Where are you going'
      final qRes = await service.translate(
        text: 'Where are you going',
        from: TranslationVariant.en,
        to: TranslationVariant.jvNgoko,
      );
      expect((qRes as Found).text, equals('Neng ndi Kowe Lunga'));
    });

    test('5. English Subject Unggah-Ungguh Register Selection', () async {
      // Honored subject -> Krama Inggil
      final honoredRes = await service.translate(
        text: 'Father sleeps in the house',
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((honoredRes as Found).text, equals('Bapak Sare wonten Dalem'));
      expect(honoredRes.appliedRegister, equals(SpeechRegister.kramaInggil));

      final motherRes = await service.translate(
        text: 'Mother goes to market',
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((motherRes as Found).text, equals('Ibu Tindak dhateng Peken'));
      expect(motherRes.appliedRegister, equals(SpeechRegister.kramaInggil));

      // Self subject -> Krama Lugu
      final selfRes = await service.translate(
        text: 'I eat rice',
        from: TranslationVariant.en,
        to: TranslationVariant.jvKrama,
      );
      expect((selfRes as Found).text, equals('Kula Nedha Sekul'));
      expect(selfRes.appliedRegister, equals(SpeechRegister.kramaLugu));
    });

    test('6. Benchmark Sentences 0% Failure Rate', () async {
      final sentences = [
        'I eat rice and you drink water',
        'Father sleeps in the house',
        'Mother goes to the market',
        'Where are you going',
        'What is your name',
        'I want to sleep',
        'He is reading a book',
        'They come from home',
        'We walk together',
        'Do not go there',
        'Please come here',
        'I know you',
        'She buys clothes',
        'I have two books',
        'Good morning father',
        'Thank you very much',
      ];

      for (final s in sentences) {
        final res = await service.translate(
          text: s,
          from: TranslationVariant.en,
          to: TranslationVariant.jvNgoko,
        );
        expect(res, isA<Found>());
        final text = (res as Found).text;
        expect(
          text.contains('[?]'),
          isFalse,
          reason: 'Sentence "$s" contains unknown marker [?]: $text',
        );
      }
    });
  });
}
