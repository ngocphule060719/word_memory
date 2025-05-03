import 'package:word_memory/data/models/word_pair_model.dart';

abstract class WordPairDataSource {
  Future<List<WordPairModel>> getWordPairs();
}
