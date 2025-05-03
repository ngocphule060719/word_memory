import 'package:equatable/equatable.dart';
import 'package:word_memory/domain/entities/word_pair.dart';

sealed class WordPairState extends Equatable {
  const WordPairState();

  @override
  List<Object?> get props => [];
}

final class WordPairLoadingState extends WordPairState {
  const WordPairLoadingState();
}

final class WordPairLoadedState extends WordPairState {
  final List<WordPair> wordPairs;

  const WordPairLoadedState({required this.wordPairs});

  @override
  List<Object?> get props => [wordPairs];
}

final class WordPairErrorState extends WordPairState {
  final String message;

  const WordPairErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
