import 'package:equatable/equatable.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/presentation/models/game_ui_state.dart';

sealed class WordPairState extends Equatable {
  const WordPairState();

  @override
  List<Object?> get props => [];
}

final class WordPairLoadingState extends WordPairState {
  const WordPairLoadingState();
}

final class WordPairLoadedState extends WordPairState {
  const WordPairLoadedState({
    required this.wordPairs,
    required this.gameState,
  });

  final List<WordPair> wordPairs;
  final GameUiState gameState;

  @override
  List<Object?> get props => [wordPairs, gameState];

  WordPairLoadedState copyWith({
    List<WordPair>? wordPairs,
    GameUiState? gameState,
  }) =>
      WordPairLoadedState(
        wordPairs: wordPairs ?? this.wordPairs,
        gameState: gameState ?? this.gameState,
      );
}

final class WordPairErrorState extends WordPairState {
  const WordPairErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
