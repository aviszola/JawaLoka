import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_jawaloka/core/profile/profile_controller.dart';
import 'package:flutter_jawaloka/core/profile/profile_preferences.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_path_models.dart';
import 'package:flutter_jawaloka/features/quiz/domain/quiz_path_data.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/screens/quiz_path_screen.dart';
import 'package:flutter_jawaloka/features/quiz/presentation/widgets/temple_zone_background.dart';
import '../helpers/pump_app.dart';

void main() {
  group('50-Node Quiz Path Curriculum & Model Integrity', () {
    test('QuizPathData has exactly 5 units and 50 nodes', () {
      expect(QuizPathData.units.length, 5);
      expect(QuizPathData.allNodes.length, 50);

      for (int i = 0; i < QuizPathData.units.length; i++) {
        final unit = QuizPathData.units[i];
        expect(unit.unitId, i + 1);
        expect(
          unit.nodes.length,
          10,
          reason: 'Unit ${unit.unitId} should contain exactly 10 nodes',
        );
      }
    });

    test(
      'All 50 nodes have unique canonical IDs matching path_node_uX_nYY format',
      () {
        final ids = <String>{};
        final idPattern = RegExp(
          r'^path_node_u[1-5]_n(0[1-9]|[1-4][0-9]|50)_[a-z0-9_]+$',
        );

        for (final node in QuizPathData.allNodes) {
          expect(
            ids.contains(node.id),
            isFalse,
            reason: 'Duplicate node ID found: ${node.id}',
          );
          ids.add(node.id);
          expect(
            idPattern.hasMatch(node.id),
            isTrue,
            reason: 'Node ID does not match canonical pattern: ${node.id}',
          );
        }
        expect(ids.length, 50);
      },
    );

    test('All 50 nodes have unique semantic topicKeys', () {
      final keys = <String>{};
      for (final node in QuizPathData.allNodes) {
        expect(
          keys.contains(node.topicKey),
          isFalse,
          reason: 'Duplicate topicKey found: ${node.topicKey}',
        );
        keys.add(node.topicKey);
      }
      expect(keys.length, 50);
    });

    test('Sequential nodeNumber (1-50) and indexInUnit (1-10) ordering', () {
      for (int i = 0; i < QuizPathData.allNodes.length; i++) {
        final node = QuizPathData.allNodes[i];
        final expectedGlobalNum = i + 1;
        final expectedUnitId = (i ~/ 10) + 1;
        final expectedIndexInUnit = (i % 10) + 1;

        expect(node.nodeNumber, expectedGlobalNum);
        expect(node.unitId, expectedUnitId);
        expect(node.indexInUnit, expectedIndexInUnit);
      }
    });

    test(
      'Checkpoints and milestone gates are at Node 10, 20, 30, 40, and 50',
      () {
        final milestonePositions = [10, 20, 30, 40];
        for (final num in milestonePositions) {
          final node = QuizPathData.getNodeByNumber(num)!;
          expect(
            node.type,
            QuizNodeType.milestone,
            reason: 'Node $num should be QuizNodeType.milestone',
          );
          expect(node.isMilestone, isTrue);
        }

        final finalExamNode = QuizPathData.getNodeByNumber(50)!;
        expect(
          finalExamNode.type,
          QuizNodeType.finalExam,
          reason: 'Node 50 should be QuizNodeType.finalExam',
        );
        expect(finalExamNode.isMilestone, isTrue);

        // Node 3 is Tanya Kabar (lesson node)
        final node3 = QuizPathData.getNodeByNumber(3)!;
        expect(node3.topicKey, 'tanya_kabar');
        expect(node3.isMilestone, isFalse);
      },
    );

    test(
      'Winding path positions exhibit rich variety (left, center, right)',
      () {
        int leftCount = 0;
        int centerCount = 0;
        int rightCount = 0;

        for (final node in QuizPathData.allNodes) {
          switch (node.position) {
            case QuizNodePosition.left:
              leftCount++;
              expect(node.position.alignmentX, -0.55);
              expect(node.position.fractionX, closeTo(0.225, 0.001));
              break;
            case QuizNodePosition.center:
              centerCount++;
              expect(node.position.alignmentX, 0.0);
              expect(node.position.fractionX, closeTo(0.500, 0.001));
              break;
            case QuizNodePosition.right:
              rightCount++;
              expect(node.position.alignmentX, 0.55);
              expect(node.position.fractionX, closeTo(0.775, 0.001));
              break;
          }
        }

        expect(leftCount, greaterThan(10));
        expect(centerCount, greaterThan(10));
        expect(rightCount, greaterThan(10));
        expect(leftCount + centerCount + rightCount, 50);
      },
    );

    test('Lookup helpers getNodeByNumber and getNodeById work correctly', () {
      expect(QuizPathData.getNodeByNumber(0), isNull);
      expect(QuizPathData.getNodeByNumber(51), isNull);
      expect(QuizPathData.getNodeByNumber(1)?.id, 'path_node_u1_n01_salam');
      expect(
        QuizPathData.getNodeByNumber(50)?.id,
        'path_node_u5_n50_evaluasi_akhir',
      );

      expect(QuizPathData.getNodeById('invalid_id'), isNull);
      expect(QuizPathData.getNodeById('path_node_u1_n01_salam')?.nodeNumber, 1);
      expect(
        QuizPathData.getNodeById('path_node_u5_n50_evaluasi_akhir')?.nodeNumber,
        50,
      );
    });

    test('Unit progress calculation', () {
      final unit1 = QuizPathData.units[0];
      // 3 completed in unit 1
      expect(unit1.completedCount, 3);
      expect(unit1.progressRatio, 0.3);
      expect(unit1.isLocked, isFalse);

      final unit2 = QuizPathData.units[1];
      expect(unit2.completedCount, 0);
      expect(unit2.progressRatio, 0.0);
      expect(unit2.isLocked, isTrue);
    });
  });

  group('QuizPathScreen Widget & 50-Node Layout Tests', () {
    testWidgets('Renders QuizPathScreen with continue banner, Kediri temple zone, and no difficulty chips or mini map', (
      tester,
    ) async {
      await tester.pumpApp(const QuizPathScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(QuizPathScreen), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
      expect(find.byType(ChoiceChip), findsNothing);
      expect(find.text('Lanjutkan Misi'), findsOneWidget);
      expect(find.text('Mulai'), findsOneWidget);
      expect(find.text('Kediri'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (w) => w is CustomPaint && w.painter is TempleZoneBackgroundPainter,
        ),
        findsWidgets,
      );
      expect(find.byIcon(Icons.navigation_rounded), findsOneWidget);
    });

    testWidgets('Tapping continue banner scrolls towards active node and Mulai opens sheet', (
      tester,
    ) async {
      final profile = ProfileController(
        preferences: InMemoryProfilePreferences(
          initialClearedActivities: {
            'path_node_u1_n01_salam',
            'path_node_u1_n02_pamit',
            'path_node_u1_n03_lencana',
          },
        ),
      );
      await profile.loadProfile();
      await tester.pumpApp(const QuizPathScreen(), profileController: profile);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final scrollFinder = find.byType(CustomScrollView);
      expect(scrollFinder, findsOneWidget);

      await tester.tap(find.text('Lanjutkan Misi'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 700));

      // Active node is Node 4 ('Perkenalan')
      expect(find.text('Perkenalan'), findsOneWidget);

      // Scroll back up to banner and tap Mulai -> opens QuizBottomSheet
      await tester.drag(scrollFinder, const Offset(0, 600));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.tap(find.text('Mulai'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Mulai Misi'), findsOneWidget);
    });

    testWidgets('Can scroll through the entire 50-node path without overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpApp(const QuizPathScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Scroll incrementally to the bottom
      final scrollFinder = find.byType(CustomScrollView);
      for (int i = 0; i < 15; i++) {
        await tester.drag(scrollFinder, const Offset(0, -600));
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Node 50 'Evaluasi Akhir JawaLoka' should now be reachable and visible
      expect(find.text('Evaluasi Akhir JawaLoka'), findsOneWidget);
    });
  });
}
