import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/domain/repositories/word_repository.dart';
import 'package:word_memory/domain/usecases/get_word_pairs_usecase.dart';

@GenerateNiceMocks([MockSpec<WordRepository>()])
import 'get_word_pairs_usecase_test.mocks.dart';

void main() {
  late GetWordPairsUseCase useCase;
  late MockWordRepository mockRepository;

  final tWordPairs = [
    const WordPair(englishWord: 'hello', frenchWord: 'bonjour'),
    const WordPair(englishWord: 'world', frenchWord: 'monde'),
  ];

  setUp(() {
    mockRepository = MockWordRepository();
    useCase = GetWordPairsUseCase(repository: mockRepository);
  });

  group('execute', () {
    test('should return word pairs when repository call is successful',
        () async {
      // Arrange
      when(mockRepository.getWordPairs()).thenAnswer((_) async => tWordPairs);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(tWordPairs));
      verify(mockRepository.getWordPairs()).called(1);
    });

    test('should throw exception when repository returns empty list', () async {
      // Arrange
      when(mockRepository.getWordPairs()).thenAnswer((_) async => []);

      // Act & Assert
      expect(
        useCase.execute(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('No word pairs found'),
        )),
      );
    });

    test('should throw exception when repository call fails', () async {
      // Arrange
      final tError = Exception('Repository error');
      when(mockRepository.getWordPairs()).thenThrow(tError);

      // Act & Assert
      expect(
        useCase.execute(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to get word pairs'),
        )),
      );
    });
  });

  group('getPairCount', () {
    test('should return correct pair count when repository call is successful',
        () async {
      // Arrange
      when(mockRepository.pairCount).thenAnswer((_) async => tWordPairs.length);

      // Act
      final result = await useCase.getPairCount();

      // Assert
      expect(result, equals(tWordPairs.length));
      verify(mockRepository.pairCount).called(1);
    });

    test('should throw exception when repository call fails', () async {
      // Arrange
      final tError = Exception('Repository error');
      when(mockRepository.pairCount).thenThrow(tError);

      // Act & Assert
      expect(
        useCase.getPairCount(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Failed to get pair count'),
        )),
      );
    });
  });
}
