import 'package:flutter_test/flutter_test.dart';
import 'package:word_memory/data/models/word_pair_model.dart';

void main() {
  group('WordPairModel', () {
    const testJson = {
      'english': 'forest',
      'french': 'forét',
    };

    const testJsonList = [
      {
        'english': 'forest',
        'french': 'forét',
      },
      {
        'english': 'bicycle',
        'french': 'vélo',
      },
    ];

    group('fromJson', () {
      test('should correctly parse valid JSON map', () {
        // Act
        final result = WordPairModel.fromJson(testJson);

        // Assert
        expect(result, isA<WordPairModel>());
        expect(result.englishWord, equals('forest'));
        expect(result.frenchWord, equals('forét'));
      });

      test('should throw when required fields are missing', () {
        // Arrange
        final invalidJson = {'english': 'forest'};

        // Act & Assert
        expect(
          () => WordPairModel.fromJson(invalidJson),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Missing required field: french'),
          )),
        );
      });

      test('should throw when fields are empty', () {
        // Arrange
        final invalidJson = {
          'english': '',
          'french': 'forét',
        };

        // Act & Assert
        expect(
          () => WordPairModel.fromJson(invalidJson),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('English word cannot be empty'),
          )),
        );
      });
    });

    group('toJson', () {
      test('should return correct JSON map', () {
        // Arrange
        const wordPair = WordPairModel(
          englishWord: 'forest',
          frenchWord: 'forét',
        );

        // Act
        final result = wordPair.toJson();

        // Assert
        expect(result, equals(testJson));
      });
    });

    group('fromJsonList', () {
      test('should correctly parse list of valid JSON maps', () {
        // Act
        final result = WordPairModel.fromJsonList(testJsonList);

        // Assert
        expect(result, hasLength(2));
        expect(result.first, isA<WordPairModel>());
        expect(result.first.englishWord, equals('forest'));
        expect(result.first.frenchWord, equals('forét'));
        expect(result.last.englishWord, equals('bicycle'));
        expect(result.last.frenchWord, equals('vélo'));
      });

      test('should throw when list is empty', () {
        // Act & Assert
        expect(
          () => WordPairModel.fromJsonList([]),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Word pairs list cannot be empty'),
          )),
        );
      });

      test('should throw when list contains invalid items', () {
        // Arrange
        final invalidList = [
          {'not_english': 'hello', 'not_french': 'bonjour'}
        ];

        // Act & Assert
        expect(
          () => WordPairModel.fromJsonList(invalidList),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid word pair: missing english or french field'),
          )),
        );
      });

      test('should throw when list contains non-map items', () {
        // Arrange
        final invalidList = ['not a map'];

        // Act & Assert
        expect(
          () => WordPairModel.fromJsonList(invalidList),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid word pair format: expected a map'),
          )),
        );
      });
    });

    test('toString should return a readable string representation', () {
      // Arrange
      const wordPair = WordPairModel(
        englishWord: 'forest',
        frenchWord: 'forét',
      );

      // Act & Assert
      expect(
        wordPair.toString(),
        equals('WordPairModel(englishWord: forest, frenchWord: forét)'),
      );
    });
  });
}
