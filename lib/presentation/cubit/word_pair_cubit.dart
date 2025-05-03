import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:word_memory/domain/usecases/get_word_pairs_usecase.dart';
import 'package:word_memory/presentation/cubit/word_pair_state.dart';

class WordPairCubit extends Cubit<WordPairState> {
  final GetWordPairsUseCase _useCase;

  WordPairCubit({
    required GetWordPairsUseCase useCase,
  })  : _useCase = useCase,
        super(const WordPairLoadingState()) {
    loadWordPairs();
  }

  Future<void> loadWordPairs() async {
    try {
      emit(const WordPairLoadingState());
      final wordPairs = await _useCase.execute();
      emit(WordPairLoadedState(wordPairs: wordPairs));
    } catch (e) {
      emit(WordPairErrorState(message: e.toString()));
    }
  }

  Future<void> refresh() async {
    try {
      final currentState = state;
      if (currentState is WordPairLoadedState) {
        final wordPairs = await _useCase.execute();
        emit(WordPairLoadedState(wordPairs: wordPairs));
      } else {
        await loadWordPairs();
      }
    } catch (e) {
      emit(WordPairErrorState(message: e.toString()));
    }
  }
}
