import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/domain/usecases/get_word_pairs_usecase.dart';
import 'package:word_memory/presentation/cubit/word_pair_state.dart';
import 'package:word_memory/presentation/models/game_ui_state.dart';

class WordPairCubit extends Cubit<WordPairState> {
  WordPairCubit({required GetWordPairsUseCase useCase})
      : _useCase = useCase,
        super(const WordPairLoadingState()) {
    loadWordPairs();
  }

  final GetWordPairsUseCase _useCase;

  Future<void> loadWordPairs() async {
    try {
      emit(const WordPairLoadingState());
      final wordPairs = await _useCase.execute();
      emit(WordPairLoadedState(
        wordPairs: wordPairs,
        gameState: const GameUiState(),
      ));
    } catch (e) {
      emit(WordPairErrorState(e.toString()));
    }
  }

  Future<void> shuffleAndStart() async {
    final currentState = state;
    if (currentState is! WordPairLoadedState ||
        currentState.wordPairs.isEmpty) {
      return;
    }

    try {
      final englishWords =
          currentState.wordPairs.map((e) => e.englishWord).toList()..shuffle();
      final frenchWords =
          currentState.wordPairs.map((e) => e.frenchWord).toList()..shuffle();

      final newGameState = currentState.gameState.copyWith(
        status: GameStatus.inProgress,
        currentUserTapIndex: 0,
        grade: '',
        englishWords: englishWords,
        frenchWords: frenchWords,
        wordPairsMap: const {},
        sourceWordPairs: currentState.wordPairs,
      );

      emit(currentState.copyWith(gameState: newGameState));
    } catch (e) {
      emit(WordPairErrorState(e.toString()));
    }
  }

  WordPair? updateWordPair(int index, WordPair wordPair) {
    if (index < 1) return null;

    final currentState = state;
    if (currentState is! WordPairLoadedState) return null;
    if (index > currentState.wordPairs.length) return null;

    try {
      final wordPairsMap =
          Map<int, WordPair>.from(currentState.gameState.wordPairsMap);
      final updatedPair = wordPairsMap[index]?.copyWith(
            englishWord: wordPair.englishWord,
            frenchWord: wordPair.frenchWord,
          ) ??
          wordPair;

      wordPairsMap[index] = updatedPair;

      final newGameState = currentState.gameState.copyWith(
        wordPairsMap: wordPairsMap,
      );

      emit(currentState.copyWith(gameState: newGameState));

      return updatedPair;
    } catch (e) {
      emit(WordPairErrorState(e.toString()));
      return null;
    }
  }

  void grade() {
    final currentState = state;
    if (currentState is! WordPairLoadedState) return;

    try {
      final sourceWordPairs = currentState.gameState.sourceWordPairs;
      final userWordPairs =
          Map<int, WordPair>.from(currentState.gameState.wordPairsMap)
              .entries
              .map((entry) => entry.value)
              .where((wordPair) => wordPair.isValid)
              .toList();

      final correctPairsMap = {
        for (var pair in sourceWordPairs)
          '${pair.englishWord}:${pair.frenchWord}': true
      };

      final correctCount = userWordPairs
          .where((pair) =>
              correctPairsMap['${pair.englishWord}:${pair.frenchWord}'] == true)
          .length;

      final newGameState = currentState.gameState.copyWith(
        status: GameStatus.completed,
        grade: '$correctCount/${sourceWordPairs.length}',
      );

      emit(currentState.copyWith(gameState: newGameState));
    } catch (e) {
      emit(WordPairErrorState(e.toString()));
    }
  }

  void resetGame() {
    final currentState = state;
    if (currentState is! WordPairLoadedState) return;

    try {
      final newGameState = currentState.gameState.copyWith(
        status: GameStatus.initial,
        currentUserTapIndex: 0,
        grade: '',
        englishWords: const [],
        frenchWords: const [],
        wordPairsMap: const {},
        sourceWordPairs: const [],
      );

      emit(currentState.copyWith(gameState: newGameState));
    } catch (e) {
      emit(WordPairErrorState(e.toString()));
    }
  }

  void updateCurrentUserTapIndex(int index) {
    final currentState = state;
    if (currentState is! WordPairLoadedState) return;

    try {
      final newGameState = currentState.gameState.copyWith(
        currentUserTapIndex: index,
      );

      emit(currentState.copyWith(gameState: newGameState));
    } catch (e) {
      emit(WordPairErrorState(e.toString()));
    }
  }
}
