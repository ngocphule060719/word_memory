import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:word_memory/data/datasources/local/local_word_pair_data_source.dart';
import 'package:word_memory/data/models/word_pair_model.dart';

@GenerateNiceMocks([MockSpec<AssetBundle>()])
import 'local_word_pair_data_source_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalWordPairDataSource dataSource;
  late MockAssetBundle mockAssetBundle;

  setUp(() {
    mockAssetBundle = MockAssetBundle();
    dataSource = LocalWordPairDataSource(assetBundle: mockAssetBundle);
  });

  group('getWordPairs', () {
    final tValidJsonString = json.encode({
      'word_pairs': [
        {'english': 'hello', 'french': 'bonjour'},
        {'english': 'world', 'french': 'monde'}
      ]
    });

    final tWordPairs = [
      const WordPairModel(englishWord: 'hello', frenchWord: 'bonjour'),
      const WordPairModel(englishWord: 'world', frenchWord: 'monde'),
    ];

    test('should return List<WordPairModel> when JSON is valid', () async {
      // Arrange
      when(mockAssetBundle.loadString(any))
          .thenAnswer((_) async => tValidJsonString);

      // Act
      final result = await dataSource.getWordPairs();

      // Assert
      expect(result, equals(tWordPairs));
      verify(mockAssetBundle.loadString('assets/data/word_pairs.json'));
    });

    test('should throw when asset loading fails', () async {
      // Arrange
      when(mockAssetBundle.loadString(any))
          .thenThrow(Exception('Asset not found'));

      // Act & Assert
      expect(
        dataSource.getWordPairs(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to load asset file'),
        )),
      );
    });

    test('should throw when JSON is invalid', () async {
      // Arrange
      when(mockAssetBundle.loadString(any))
          .thenAnswer((_) async => 'invalid json');

      // Act & Assert
      expect(
        dataSource.getWordPairs(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Invalid JSON format'),
        )),
      );
    });

    test('should throw when JSON structure is incorrect', () async {
      // Arrange
      final invalidStructureJson = json.encode({
        'wrong_key': [
          {'english': 'hello', 'french': 'bonjour'}
        ]
      });
      when(mockAssetBundle.loadString(any))
          .thenAnswer((_) async => invalidStructureJson);

      // Act & Assert
      expect(
        dataSource.getWordPairs(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Invalid JSON structure: missing word_pairs key'),
        )),
      );
    });

    test('should throw when word pair fields are invalid', () async {
      // Arrange
      final invalidFieldsJson = json.encode({
        'word_pairs': [
          {'english': '', 'french': 'bonjour'} // empty english field
        ]
      });
      when(mockAssetBundle.loadString(any))
          .thenAnswer((_) async => invalidFieldsJson);

      // Act & Assert
      expect(
        dataSource.getWordPairs(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Invalid word pair: english and french cannot be empty'),
        )),
      );
    });
  });
}
