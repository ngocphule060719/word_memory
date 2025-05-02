import 'package:flutter_test/flutter_test.dart';
import 'package:word_memory/domain/entities/word_pair.dart';

void main() {
  group('WordPair', () {
    const wordPair = WordPair(
      englishWord: 'hello',
      frenchWord: 'bonjour',
    );

    test('should be equal when properties are the same', () {
      const wordPair2 = WordPair(
        englishWord: 'hello',
        frenchWord: 'bonjour',
      );

      expect(wordPair, equals(wordPair2));
    });

    test('should not be equal when properties are different', () {
      const wordPair2 = WordPair(
        englishWord: 'world',
        frenchWord: 'monde',
      );

      expect(wordPair, isNot(equals(wordPair2)));
    });

    test('copyWith should return a new instance with updated values', () {
      final newPair = wordPair.copyWith(
        englishWord: 'world',
      );

      expect(newPair.englishWord, equals('world'));
      expect(newPair.frenchWord, equals('bonjour'));
      expect(newPair, isNot(equals(wordPair)));
    });

    test('toString should return a readable string representation', () {
      expect(
        wordPair.toString(),
        equals('WordPair(englishWord: hello, frenchWord: bonjour)'),
      );
    });
  });
}
