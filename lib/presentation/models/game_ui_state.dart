import 'package:equatable/equatable.dart';
import 'package:word_memory/domain/entities/word_pair.dart';

enum GameStatus { initial, inProgress, completed }

class GameUiState extends Equatable {
  const GameUiState({
    this.status = GameStatus.initial,
    this.currentUserTapIndex = 0,
    this.grade = '',
    this.englishWords = const [],
    this.frenchWords = const [],
    this.wordPairsMap = const {},
    this.sourceWordPairs = const [],
  });

  final GameStatus status;
  final int currentUserTapIndex;
  final String grade;
  final List<String> englishWords;
  final List<String> frenchWords;
  final Map<int, WordPair> wordPairsMap;
  final List<WordPair> sourceWordPairs;

  bool get canStartGame => status != GameStatus.inProgress;
  bool get canGrade => status == GameStatus.inProgress;
  bool get showGrade => status == GameStatus.completed;
  bool get showGameContent => status != GameStatus.initial;

  GameUiState copyWith({
    GameStatus? status,
    int? currentUserTapIndex,
    String? grade,
    List<String>? englishWords,
    List<String>? frenchWords,
    Map<int, WordPair>? wordPairsMap,
    List<WordPair>? sourceWordPairs,
  }) {
    return GameUiState(
      status: status ?? this.status,
      currentUserTapIndex: currentUserTapIndex ?? this.currentUserTapIndex,
      grade: grade ?? this.grade,
      englishWords: englishWords ?? this.englishWords,
      frenchWords: frenchWords ?? this.frenchWords,
      wordPairsMap: wordPairsMap ?? this.wordPairsMap,
      sourceWordPairs: sourceWordPairs ?? this.sourceWordPairs,
    );
  }

  @override
  List<Object?> get props => [
        status,
        currentUserTapIndex,
        grade,
        englishWords,
        frenchWords,
        wordPairsMap,
        sourceWordPairs,
      ];
}
