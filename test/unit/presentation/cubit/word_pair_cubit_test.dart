import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/domain/usecases/get_word_pairs_usecase.dart';
import 'package:word_memory/presentation/cubit/word_pair_cubit.dart';
import 'package:word_memory/presentation/cubit/word_pair_state.dart';
import 'package:word_memory/presentation/models/game_ui_state.dart';

@GenerateNiceMocks([MockSpec<GetWordPairsUseCase>()])
import 'word_pair_cubit_test.mocks.dart';

void main() {
  late MockGetWordPairsUseCase mockUseCase;
  late WordPairCubit cubit;

  final tWordPairs = [
    const WordPair(englishWord: 'hello', frenchWord: 'bonjour'),
    const WordPair(englishWord: 'world', frenchWord: 'monde'),
  ];

  setUp(() {
    mockUseCase = MockGetWordPairsUseCase();
  });

  tearDown(() {
    cubit.close();
  });

  group('initialization', () {
    test('initial state should be WordPairLoadingState', () {
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);
      cubit = WordPairCubit(useCase: mockUseCase);
      expect(cubit.state, isA<WordPairLoadingState>());
    });

    test('should emit [Loading, Loaded] states when initialized successfully',
        () async {
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);
      cubit = WordPairCubit(useCase: mockUseCase);

      await expectLater(
        cubit.stream,
        emitsInOrder([
          isA<WordPairLoadedState>()
              .having(
                  (state) => state.wordPairs, 'wordPairs', equals(tWordPairs))
              .having((state) => state.gameState.status, 'game status',
                  equals(GameStatus.initial)),
        ]),
      );

      verify(mockUseCase.execute()).called(1);
    });

    test('should emit [Loading, Error] states when initialization fails',
        () async {
      final tError = Exception('Failed to load');
      when(mockUseCase.execute()).thenThrow(tError);
      cubit = WordPairCubit(useCase: mockUseCase);

      await expectLater(
        cubit.stream,
        emitsInOrder([
          isA<WordPairErrorState>().having((state) => state.message,
              'error message', equals(tError.toString())),
        ]),
      );
    });
  });

  group('loadWordPairs', () {
    setUp(() {
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);
      cubit = WordPairCubit(useCase: mockUseCase);
    });

    test('should emit [Loading, Loaded] states when loading succeeds',
        () async {
      // Wait for initial load
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );
      clearInteractions(mockUseCase);

      // Setup for reload
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);

      // Trigger reload
      cubit.loadWordPairs();

      await expectLater(
        cubit.stream,
        emitsInOrder([
          isA<WordPairLoadingState>(),
          isA<WordPairLoadedState>()
              .having(
                  (state) => state.wordPairs, 'wordPairs', equals(tWordPairs))
              .having((state) => state.gameState.status, 'game status',
                  equals(GameStatus.initial)),
        ]),
      );

      verify(mockUseCase.execute()).called(1);
    });

    test('should emit [Loading, Error] states when loading fails', () async {
      // Wait for initial load
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );
      clearInteractions(mockUseCase);

      final tError = Exception('Failed to load');
      when(mockUseCase.execute()).thenThrow(tError);

      cubit.loadWordPairs();

      await expectLater(
        cubit.stream,
        emitsInOrder([
          isA<WordPairLoadingState>(),
          isA<WordPairErrorState>().having((state) => state.message,
              'error message', equals(tError.toString())),
        ]),
      );
    });
  });

  group('shuffleAndStart', () {
    setUp(() {
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);
      cubit = WordPairCubit(useCase: mockUseCase);
    });

    test('should not emit new state when not in LoadedState', () async {
      // Create a new cubit that will be in error state
      final tError = Exception('Failed to load');
      when(mockUseCase.execute()).thenThrow(tError);
      final errorCubit = WordPairCubit(useCase: mockUseCase);

      // Wait for error state
      await expectLater(
        errorCubit.stream,
        emits(isA<WordPairErrorState>()),
      );

      errorCubit.shuffleAndStart();

      // Verify no new emissions
      expect(errorCubit.stream, neverEmits(anything));

      addTearDown(errorCubit.close);
    });

    test('should not emit new state when word pairs is empty', () async {
      // Create a new cubit that will have empty word pairs
      when(mockUseCase.execute()).thenAnswer((_) async => []);
      final emptyCubit = WordPairCubit(useCase: mockUseCase);

      await expectLater(
        emptyCubit.stream,
        emits(isA<WordPairLoadedState>()),
      );

      emptyCubit.shuffleAndStart();

      expect(emptyCubit.stream, neverEmits(anything));

      addTearDown(emptyCubit.close);
    });

    test('should update game state and shuffle words when in valid state',
        () async {
      // Wait for initial load
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );

      cubit.shuffleAndStart();

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.gameState,
            'gameState',
            isA<GameUiState>()
                .having(
                    (gs) => gs.status, 'status', equals(GameStatus.inProgress))
                .having((gs) => gs.currentUserTapIndex, 'tapIndex', equals(0))
                .having((gs) => gs.grade, 'grade', isEmpty)
                .having((gs) => gs.englishWords.length, 'englishWords length',
                    equals(2))
                .having((gs) => gs.frenchWords.length, 'frenchWords length',
                    equals(2))
                .having((gs) => gs.wordPairsMap, 'wordPairsMap', isEmpty)
                .having((gs) => gs.sourceWordPairs, 'sourceWordPairs',
                    equals(tWordPairs)),
          ),
        ),
      );
    });
  });

  group('updateWordPair', () {
    setUp(() {
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);
      cubit = WordPairCubit(useCase: mockUseCase);
    });

    test('should not update when index is less than 1', () async {
      // Wait for initial load
      await expectLater(cubit.stream, emits(isA<WordPairLoadedState>()));

      final result = cubit.updateWordPair(0, tWordPairs[0]);
      expect(result, isNull);
      expect(cubit.stream, neverEmits(anything));
    });

    test('should not update when not in LoadedState', () async {
      final tError = Exception('Failed to load');
      when(mockUseCase.execute()).thenThrow(tError);
      final errorCubit = WordPairCubit(useCase: mockUseCase);

      await expectLater(errorCubit.stream, emits(isA<WordPairErrorState>()));

      final result = errorCubit.updateWordPair(1, tWordPairs[0]);
      expect(result, isNull);
      expect(errorCubit.stream, neverEmits(anything));

      addTearDown(errorCubit.close);
    });

    test('should update wordPairsMap when in valid state', () async {
      // Wait for initial load and start game
      await expectLater(cubit.stream, emits(isA<WordPairLoadedState>()));
      cubit.shuffleAndStart();
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>().having(
          (state) => state.gameState.status,
          'status',
          equals(GameStatus.inProgress),
        )),
      );

      final newPair = const WordPair(englishWord: 'test', frenchWord: 'test');
      final result = cubit.updateWordPair(1, newPair);

      expect(result, equals(newPair));
      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.gameState.wordPairsMap,
            'wordPairsMap',
            equals({1: newPair}),
          ),
        ),
      );
    });

    test('should update existing pair in wordPairsMap', () async {
      // Wait for initial load and start game
      await expectLater(cubit.stream, emits(isA<WordPairLoadedState>()));
      cubit.shuffleAndStart();
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );

      // First update
      final firstPair = const WordPair(englishWord: 'test', frenchWord: '');
      cubit.updateWordPair(1, firstPair);
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );

      // Second update
      final secondPair =
          const WordPair(englishWord: 'test', frenchWord: 'test');
      final result = cubit.updateWordPair(1, secondPair);

      expect(result?.englishWord, equals('test'));
      expect(result?.frenchWord, equals('test'));
      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.gameState.wordPairsMap,
            'wordPairsMap',
            equals({1: secondPair}),
          ),
        ),
      );
    });
  });

  group('grade', () {
    setUp(() {
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);
      cubit = WordPairCubit(useCase: mockUseCase);
    });

    test('should not grade when not in LoadedState', () async {
      final tError = Exception('Failed to load');
      when(mockUseCase.execute()).thenThrow(tError);
      final errorCubit = WordPairCubit(useCase: mockUseCase);

      await expectLater(errorCubit.stream, emits(isA<WordPairErrorState>()));

      errorCubit.grade();
      expect(errorCubit.stream, neverEmits(anything));

      addTearDown(errorCubit.close);
    });

    test('should calculate correct grade for matching pairs', () async {
      // Wait for initial load and start game
      await expectLater(cubit.stream, emits(isA<WordPairLoadedState>()));
      cubit.shuffleAndStart();
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );

      // Add correct pairs
      cubit.updateWordPair(1, tWordPairs[0]);
      cubit.updateWordPair(2, tWordPairs[1]);
      await expectLater(
        cubit.stream,
        emitsInOrder([
          isA<WordPairLoadedState>(),
          isA<WordPairLoadedState>(),
        ]),
      );

      cubit.grade();

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>()
              .having((state) => state.gameState.status, 'status',
                  equals(GameStatus.completed))
              .having((state) => state.gameState.grade, 'grade', equals('2/2')),
        ),
      );
    });

    test('should calculate correct grade for partially matching pairs',
        () async {
      // Wait for initial load and start game
      await expectLater(cubit.stream, emits(isA<WordPairLoadedState>()));
      cubit.shuffleAndStart();
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );

      // Add one correct pair and one incorrect pair
      cubit.updateWordPair(1, tWordPairs[0]);
      cubit.updateWordPair(
          2, const WordPair(englishWord: 'wrong', frenchWord: 'incorrect'));
      await expectLater(
        cubit.stream,
        emitsInOrder([
          isA<WordPairLoadedState>(),
          isA<WordPairLoadedState>(),
        ]),
      );

      cubit.grade();

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>()
              .having((state) => state.gameState.status, 'status',
                  equals(GameStatus.completed))
              .having((state) => state.gameState.grade, 'grade', equals('1/2')),
        ),
      );
    });
  });

  group('resetGame', () {
    setUp(() {
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);
      cubit = WordPairCubit(useCase: mockUseCase);
    });

    test('should not reset when not in LoadedState', () async {
      final tError = Exception('Failed to load');
      when(mockUseCase.execute()).thenThrow(tError);
      final errorCubit = WordPairCubit(useCase: mockUseCase);

      await expectLater(errorCubit.stream, emits(isA<WordPairErrorState>()));

      errorCubit.resetGame();
      expect(errorCubit.stream, neverEmits(anything));

      addTearDown(errorCubit.close);
    });

    test('should reset game state to initial values', () async {
      // Wait for initial load and start game
      await expectLater(cubit.stream, emits(isA<WordPairLoadedState>()));
      cubit.shuffleAndStart();
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );

      // Add some pairs and grade
      cubit.updateWordPair(1, tWordPairs[0]);
      cubit.updateWordPair(2, tWordPairs[1]);
      cubit.grade();
      await expectLater(
        cubit.stream,
        emitsInOrder([
          isA<WordPairLoadedState>(),
          isA<WordPairLoadedState>(),
          isA<WordPairLoadedState>(),
        ]),
      );

      cubit.resetGame();

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.gameState,
            'gameState',
            isA<GameUiState>()
                .having((gs) => gs.status, 'status', equals(GameStatus.initial))
                .having((gs) => gs.currentUserTapIndex, 'tapIndex', equals(0))
                .having((gs) => gs.grade, 'grade', isEmpty)
                .having((gs) => gs.englishWords, 'englishWords', isEmpty)
                .having((gs) => gs.frenchWords, 'frenchWords', isEmpty)
                .having((gs) => gs.wordPairsMap, 'wordPairsMap', isEmpty)
                .having((gs) => gs.sourceWordPairs, 'sourceWordPairs', isEmpty),
          ),
        ),
      );
    });
  });

  group('updateCurrentUserTapIndex', () {
    setUp(() {
      when(mockUseCase.execute()).thenAnswer((_) async => tWordPairs);
      cubit = WordPairCubit(useCase: mockUseCase);
    });

    test('should not update when not in LoadedState', () async {
      final tError = Exception('Failed to load');
      when(mockUseCase.execute()).thenThrow(tError);
      final errorCubit = WordPairCubit(useCase: mockUseCase);

      await expectLater(errorCubit.stream, emits(isA<WordPairErrorState>()));

      errorCubit.updateCurrentUserTapIndex(1);
      expect(errorCubit.stream, neverEmits(anything));

      addTearDown(errorCubit.close);
    });

    test('should update current user tap index', () async {
      // Wait for initial load and start game
      await expectLater(cubit.stream, emits(isA<WordPairLoadedState>()));
      cubit.shuffleAndStart();
      await expectLater(
        cubit.stream,
        emits(isA<WordPairLoadedState>()),
      );

      cubit.updateCurrentUserTapIndex(1);

      await expectLater(
        cubit.stream,
        emits(
          isA<WordPairLoadedState>().having(
            (state) => state.gameState.currentUserTapIndex,
            'currentUserTapIndex',
            equals(1),
          ),
        ),
      );
    });
  });
}
