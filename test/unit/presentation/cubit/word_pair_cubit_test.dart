import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/domain/usecases/get_word_pairs_usecase.dart';
import 'package:word_memory/presentation/cubit/word_pair_cubit.dart';
import 'package:word_memory/presentation/cubit/word_pair_state.dart';

@GenerateNiceMocks([MockSpec<GetWordPairsUseCase>()])
import 'word_pair_cubit_test.mocks.dart';

void main() {
  late MockGetWordPairsUseCase mockUseCase;

  final tWordPairs = [
    const WordPair(englishWord: 'hello', frenchWord: 'bonjour'),
    const WordPair(englishWord: 'world', frenchWord: 'monde'),
  ];

  setUp(() {
    mockUseCase = MockGetWordPairsUseCase();
  });

  group('initialization', () {
    test('should emit [Loading, Loaded] states when initialized successfully',
        () async {
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        return tWordPairs;
      });

      final cubit = WordPairCubit(useCase: mockUseCase);
      addTearDown(cubit.close);

      expect(cubit.state, isA<WordPairLoadingState>());

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.wordPairs,
            'wordPairs',
            equals(tWordPairs),
          ),
        ),
      );

      verify(mockUseCase.execute()).called(1);
    });

    test('should emit [Loading, Error] states when initialization fails',
        () async {
      final tError = Exception('Failed to load word pairs');
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        throw tError;
      });

      final cubit = WordPairCubit(useCase: mockUseCase);
      addTearDown(cubit.close);

      expect(cubit.state, isA<WordPairLoadingState>());

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairErrorState>().having(
            (state) => state.message,
            'error message',
            equals(tError.toString()),
          ),
        ),
      );

      verify(mockUseCase.execute()).called(1);
    });
  });

  group('loadWordPairs', () {
    test('should emit [Loading, Loaded] states on success', () async {
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        return tWordPairs;
      });

      final cubit = WordPairCubit(useCase: mockUseCase);
      addTearDown(cubit.close);

      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );
      clearInteractions(mockUseCase);

      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        return tWordPairs;
      });

      cubit.loadWordPairs();

      expect(cubit.state, isA<WordPairLoadingState>());

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.wordPairs,
            'wordPairs',
            equals(tWordPairs),
          ),
        ),
      );

      verify(mockUseCase.execute()).called(1);
    });

    test('should emit [Loading, Error] states on failure', () async {
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        return tWordPairs;
      });

      final cubit = WordPairCubit(useCase: mockUseCase);
      addTearDown(cubit.close);

      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );
      clearInteractions(mockUseCase);

      final tError = Exception('Failed to load');
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        throw tError;
      });

      cubit.loadWordPairs();

      expect(cubit.state, isA<WordPairLoadingState>());

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairErrorState>().having(
            (state) => state.message,
            'error message',
            equals(tError.toString()),
          ),
        ),
      );

      verify(mockUseCase.execute()).called(1);
    });
  });

  group('refresh', () {
    test('should reload data when in LoadedState', () async {
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        return tWordPairs;
      });

      final cubit = WordPairCubit(useCase: mockUseCase);
      addTearDown(cubit.close);

      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );
      clearInteractions(mockUseCase);

      final newWordPairs = [
        const WordPair(englishWord: 'test', frenchWord: 'test'),
      ];
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        return newWordPairs;
      });

      cubit.refresh();

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.wordPairs,
            'wordPairs',
            equals(newWordPairs),
          ),
        ),
      );

      verify(mockUseCase.execute()).called(1);
    });

    test('should emit error when refresh fails in LoadedState', () async {
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        return tWordPairs;
      });

      final cubit = WordPairCubit(useCase: mockUseCase);
      addTearDown(cubit.close);

      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );
      clearInteractions(mockUseCase);

      final tError = Exception('Failed to refresh');
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        throw tError;
      });

      cubit.refresh();

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairErrorState>().having(
            (state) => state.message,
            'error message',
            equals(tError.toString()),
          ),
        ),
      );

      verify(mockUseCase.execute()).called(1);
    });

    test('should call loadWordPairs when not in LoadedState', () async {
      final initialError = Exception('Initial load failed');
      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        throw initialError;
      });

      final cubit = WordPairCubit(useCase: mockUseCase);
      addTearDown(cubit.close);

      await expectLater(
        cubit.stream,
        emits(isA<WordPairErrorState>()),
      );
      clearInteractions(mockUseCase);

      when(mockUseCase.execute()).thenAnswer((_) async {
        await Future.delayed(const Duration(microseconds: 1));
        return tWordPairs;
      });

      cubit.refresh();

      expect(cubit.state, isA<WordPairLoadingState>());

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.wordPairs,
            'wordPairs',
            equals(tWordPairs),
          ),
        ),
      );

      verify(mockUseCase.execute()).called(1);
    });
  });
}
