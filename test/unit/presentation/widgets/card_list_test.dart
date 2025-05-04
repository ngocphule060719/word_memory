import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/presentation/constants/app_constants.dart';
import 'package:word_memory/presentation/widgets/card_list.dart';
import 'package:word_memory/presentation/widgets/word_card.dart';

void main() {
  group('CardList', () {
    final testWords = ['hello', 'world'];
    final testWordPairs = {
      1: const WordPair(englishWord: 'hello', frenchWord: 'bonjour'),
    };
    final sourceWordPairs = [
      const WordPair(englishWord: 'hello', frenchWord: 'bonjour'),
      const WordPair(englishWord: 'world', frenchWord: 'monde'),
    ];

    Widget buildCardList({
      bool isEnglish = true,
      bool isGameEnded = false,
      int currentUserTapIndex = 0,
      void Function(String)? onTap,
      Map<int, WordPair>? wordPairMaps,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: CardList(
            isEnglish: isEnglish,
            isGameEnded: isGameEnded,
            words: testWords,
            currentUserTapIndex: currentUserTapIndex,
            wordPairMaps: wordPairMaps ?? testWordPairs,
            sourceWordPairs: sourceWordPairs,
            onTap: onTap ?? (_) {},
          ),
        ),
      );
    }

    testWidgets('renders correct title and words', (tester) async {
      await tester.pumpWidget(buildCardList());

      expect(find.text(AppStrings.englishTitle), findsOneWidget);
      for (final word in testWords) {
        expect(find.text(word), findsOneWidget);
      }
    });

    testWidgets('shows French title when isEnglish is false', (tester) async {
      await tester.pumpWidget(buildCardList(isEnglish: false));

      expect(find.text(AppStrings.frenchTitle), findsOneWidget);
    });

    testWidgets('handles tap events correctly', (tester) async {
      String? tappedWord;
      await tester.pumpWidget(
        buildCardList(
          wordPairMaps: {}, // Empty map so no words are selected
          onTap: (word) => tappedWord = word,
        ),
      );

      await tester.tap(find.text('hello'));
      expect(tappedWord, equals('hello'));
    });

    testWidgets('shows correct states for words', (tester) async {
      await tester.pumpWidget(
        buildCardList(
          currentUserTapIndex: 1,
          isGameEnded: false,
          wordPairMaps: {
            1: const WordPair(englishWord: 'hello', frenchWord: ''),
          },
        ),
      );

      final cards = tester.widgetList<WordCard>(find.byType(WordCard));
      for (final card in cards) {
        if (card.word == 'hello') {
          expect(card.state, equals(WordCardState.selecting));
        } else {
          expect(card.state, equals(WordCardState.none));
        }
      }
    });

    testWidgets('shows correct/incorrect states when game is ended',
        (tester) async {
      await tester.pumpWidget(
        buildCardList(
          isGameEnded: true,
          currentUserTapIndex: 1,
          wordPairMaps: {
            1: const WordPair(englishWord: 'hello', frenchWord: 'bonjour'),
            2: const WordPair(englishWord: 'world', frenchWord: 'incorrect'),
          },
        ),
      );

      final cards = tester.widgetList<WordCard>(find.byType(WordCard));
      for (final card in cards) {
        if (card.word == 'hello') {
          expect(card.state, equals(WordCardState.correct));
        } else {
          expect(card.state, equals(WordCardState.incorrect));
        }
      }
    });

    testWidgets('prevents tapping on selected words', (tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(
        buildCardList(
          currentUserTapIndex: 2, // Different from the selected pair's index
          wordPairMaps: {
            1: const WordPair(
                englishWord: 'hello',
                frenchWord: 'bonjour'), // Valid pair to make it selected
          },
          onTap: (_) => wasTapped = true,
        ),
      );

      // Verify the word is in selected state
      final card = tester.widget<WordCard>(find.byType(WordCard).first);
      expect(card.state, equals(WordCardState.selected));

      // Try to tap a selected word
      await tester.tap(find.text('hello'));
      expect(wasTapped, isFalse);
    });
  });
}
