import 'package:flutter_test/flutter_test.dart';
import 'package:word_memory/core/utils/word_pair_validator.dart';

void main() {
  group('WordPairValidator', () {
    group('validateJsonStructure', () {
      test('should validate correct JSON structure', () {
        // Arrange
        final validJson = {
          'word_pairs': [
            {'english': 'hello', 'french': 'bonjour'}
          ]
        };

        // Act
        final result = WordPairValidator.validateJsonStructure(validJson);

        // Assert
        expect(result, equals(validJson));
      });

      test('should throw when input is not a map', () {
        // Arrange
        final invalidJson = ['not a map'];

        // Act & Assert
        expect(
          () => WordPairValidator.validateJsonStructure(invalidJson),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid JSON format: expected a map'),
          )),
        );
      });

      test('should throw when word_pairs key is missing', () {
        // Arrange
        final invalidJson = {'wrong_key': []};

        // Act & Assert
        expect(
          () => WordPairValidator.validateJsonStructure(invalidJson),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid JSON structure: missing word_pairs key'),
          )),
        );
      });

      test('should throw when word_pairs is not a list', () {
        // Arrange
        final invalidJson = {'word_pairs': 'not a list'};

        // Act & Assert
        expect(
          () => WordPairValidator.validateJsonStructure(invalidJson),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid JSON structure: word_pairs must be a list'),
          )),
        );
      });
    });

    group('validateWordPairFields', () {
      test('should validate correct word pair fields', () {
        // Arrange
        final validPair = {
          'english': 'hello',
          'french': 'bonjour',
        };

        // Act & Assert
        expect(
          () => WordPairValidator.validateWordPairFields(validPair),
          returnsNormally,
        );
      });

      test('should throw when fields are missing', () {
        // Arrange
        final invalidPair = {'english': 'hello'};

        // Act & Assert
        expect(
          () => WordPairValidator.validateWordPairFields(invalidPair),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid word pair: missing english or french field'),
          )),
        );
      });

      test('should throw when fields are not strings', () {
        // Arrange
        final invalidPair = {
          'english': 123,
          'french': 456,
        };

        // Act & Assert
        expect(
          () => WordPairValidator.validateWordPairFields(invalidPair),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid word pair: english and french must be strings'),
          )),
        );
      });

      test('should throw when fields are empty strings', () {
        // Arrange
        final invalidPair = {
          'english': '',
          'french': 'bonjour',
        };

        // Act & Assert
        expect(
          () => WordPairValidator.validateWordPairFields(invalidPair),
          throwsA(isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid word pair: english and french cannot be empty'),
          )),
        );
      });
    });
  });
}
