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
      englishWord: englishWord != null && englishWord.isNotEmpty
          ? englishWord
          : this.englishWord,
      frenchWord: frenchWord != null && frenchWord.isNotEmpty
          ? frenchWord
          : this.frenchWord,
    );
  }

  static WordPair empty() {
    return const WordPair(englishWord: '', frenchWord: '');
  }

  bool get isValid => englishWord.isNotEmpty && frenchWord.isNotEmpty;
}
