import 'package:equatable/equatable.dart';

class WordPair extends Equatable {
  final String englishWord;
  final String frenchWord;

  const WordPair({
    required this.englishWord,
    required this.frenchWord,
  });

  @override
  List<Object?> get props => [englishWord, frenchWord];

  @override
  String toString() =>
      'WordPair(englishWord: $englishWord, frenchWord: $frenchWord)';

  WordPair copyWith({
    String? englishWord,
    String? frenchWord,
  }) {
    return WordPair(
      englishWord: englishWord ?? this.englishWord,
      frenchWord: frenchWord ?? this.frenchWord,
    );
  }
}
