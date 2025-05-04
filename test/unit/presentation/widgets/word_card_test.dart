import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_memory/presentation/constants/app_constants.dart';
import 'package:word_memory/presentation/widgets/word_card.dart';

void main() {
  group('WordCard', () {
    testWidgets('renders with correct word and index', (tester) async {
      const word = 'test';
      const index = 1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: WordCard(
              word: word,
              index: index,
            ),
          ),
        ),
      );

      expect(find.text(word), findsOneWidget);
      expect(find.text(index.toString()), findsOneWidget);
    });

    testWidgets('shows default index when index is 0', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const WordCard(
              word: 'test',
              index: 0,
            ),
          ),
        ),
      );

      expect(find.text(AppStrings.defaultIndex), findsOneWidget);
    });

    testWidgets('applies correct styles for each state', (tester) async {
      for (final state in WordCardState.values) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: WordCard(
                word: 'test',
                index: 1,
                state: state,
              ),
            ),
          ),
        );

        final container =
            tester.widget<Container>(find.byType(Container).first);
        final decoration = container.decoration as BoxDecoration;

        switch (state) {
          case WordCardState.none:
            expect(decoration.border?.top.color.alpha, equals(128));
            break;
          case WordCardState.selecting:
            expect(decoration.color?.alpha, equals(51));
            break;
          case WordCardState.selected:
            expect(decoration.color?.alpha, equals(25));
            break;
          case WordCardState.correct:
            expect(decoration.border?.top.color, equals(Colors.green.shade600));
            break;
          case WordCardState.incorrect:
            expect(decoration.color?.alpha, equals(51));
            break;
        }
      }
    });
  });
}
