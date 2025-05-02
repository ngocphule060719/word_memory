import 'package:word_memory/domain/entities/word_pair.dart';

abstract class WordRepository {
  Future<List<WordPair>> getWordPairs();

  Future<int> get pairCount;
}
