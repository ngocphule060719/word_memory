import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/presentation/constants/app_constants.dart';
import 'package:word_memory/presentation/widgets/word_card.dart';

class CardList extends StatelessWidget {
  const CardList({
    super.key,
    required this.isEnglish,
    required this.isGameEnded,
    required this.words,
    required this.currentUserTapIndex,
    required this.wordPairMaps,
    required this.sourceWordPairs,
    required this.onTap,
  });

  final bool isEnglish;
  final bool isGameEnded;
  final List<String> words;
  final int currentUserTapIndex;
  final Map<int, WordPair> wordPairMaps;
  final List<WordPair> sourceWordPairs;
  final Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            isEnglish ? AppStrings.englishTitle : AppStrings.frenchTitle,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          ...words.mapIndexed((index, word) {
            final cardState = _getWordCardState(word);
            final cardSelectedIndex = _getCardSelectedIndex(word);
            return GestureDetector(
              onTap: () {
                if (cardState == WordCardState.selected) {
                  return;
                }
                onTap(word);
              },
              child: WordCard(
                word: word,
                index: cardSelectedIndex,
                state: cardState,
              ),
            );
          }),
        ],
      ),
    );
  }

  int _getCardSelectedIndex(String word) {
    return wordPairMaps.entries
            .firstWhereOrNull((entry) => isEnglish
                ? entry.value.englishWord == word
                : entry.value.frenchWord == word)
            ?.key ??
        0;
  }

  bool _isWordMatch(WordPair pair, String word) {
    return isEnglish ? pair.englishWord == word : pair.frenchWord == word;
  }

  WordCardState _getWordCardState(String word) {
    if (isGameEnded) {
      final cardSelectedIndex = _getCardSelectedIndex(word);
      final selectedPair = wordPairMaps[cardSelectedIndex];
      final correctPair =
          sourceWordPairs.firstWhereOrNull((pair) => _isWordMatch(pair, word));

      final isCorrect = selectedPair != null &&
          selectedPair.isValid &&
          correctPair != null &&
          selectedPair.englishWord == correctPair.englishWord &&
          selectedPair.frenchWord == correctPair.frenchWord;

      return isCorrect ? WordCardState.correct : WordCardState.incorrect;
    }

    final currentPair = wordPairMaps[currentUserTapIndex];
    if (currentPair != null && _isWordMatch(currentPair, word)) {
      return WordCardState.selecting;
    }

    final isInCompletedPair = wordPairMaps.values
        .where((pair) => pair.isValid)
        .any((pair) => _isWordMatch(pair, word));

    return isInCompletedPair ? WordCardState.selected : WordCardState.none;
  }
}
