import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:word_memory/data/datasources/word_pair_data_source.dart';
import 'package:word_memory/data/models/word_pair_model.dart';
import 'package:word_memory/data/repositories/word_repository_impl.dart';
import 'package:word_memory/domain/entities/word_pair.dart';

@GenerateNiceMocks([MockSpec<WordPairDataSource>()])
import 'word_repository_impl_test.mocks.dart';

void main() {
  late WordRepositoryImpl repository;
  late MockWordPairDataSource mockDataSource;

  final testWordPairs = [
    const WordPairModel(
      englishWord: 'forest',
      frenchWord: 'forét',
    ),
    const WordPairModel(
      englishWord: 'bicycle',
      frenchWord: 'vélo',
    ),
  ];

  setUp(() {
    mockDataSource = MockWordPairDataSource();
    repository = WordRepositoryImpl(dataSource: mockDataSource);
  });

  group('WordRepositoryImpl', () {
    test('getWordPairs should return a list of word pairs', () async {
      when(mockDataSource.getWordPairs())
          .thenAnswer((_) async => testWordPairs);

      final pairs = await repository.getWordPairs();

      expect(pairs, isA<List<WordPair>>());
      expect(pairs, isNotEmpty);
      expect(pairs.first, isA<WordPair>());
      verify(mockDataSource.getWordPairs()).called(1);
    });

    test('getWordPairs should return cached data on subsequent calls',
        () async {
      when(mockDataSource.getWordPairs())
          .thenAnswer((_) async => testWordPairs);

      final firstCall = await repository.getWordPairs();
      final secondCall = await repository.getWordPairs();

      expect(identical(firstCall, secondCall), isFalse);
      expect(firstCall, equals(secondCall));
      verify(mockDataSource.getWordPairs()).called(1);
    });

    test('pairCount should return correct number of pairs', () async {
      when(mockDataSource.getWordPairs())
          .thenAnswer((_) async => testWordPairs);

      expect(await repository.pairCount, equals(testWordPairs.length));
    });

    test('clearCache should force reload from data source', () async {
      when(mockDataSource.getWordPairs())
          .thenAnswer((_) async => testWordPairs);

      await repository.getWordPairs(); // First call
      repository.clearCache();
      await repository.getWordPairs(); // Second call

      verify(mockDataSource.getWordPairs()).called(2);
    });
  });
}
