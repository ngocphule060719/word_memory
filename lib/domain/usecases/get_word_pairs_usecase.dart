import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/domain/repositories/word_repository.dart';

class GetWordPairsUseCase {
  final WordRepository _repository;

  const GetWordPairsUseCase({required WordRepository repository})
      : _repository = repository;

  Future<List<WordPair>> execute() async {
    try {
      final wordPairs = await _repository.getWordPairs();
      if (wordPairs.isEmpty) {
        throw Exception('No word pairs found');
      }
      return wordPairs;
    } on Exception catch (e) {
      throw Exception('Failed to get word pairs: $e');
    }
  }

  Future<int> getPairCount() async {
    try {
      return await _repository.pairCount;
    } on Exception catch (e) {
      throw Exception('Failed to get pair count: $e');
    }
  }
}
