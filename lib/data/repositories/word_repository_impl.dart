import 'package:word_memory/data/datasources/word_pair_data_source.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/domain/repositories/word_repository.dart';

class WordRepositoryImpl implements WordRepository {
  final WordPairDataSource dataSource;
  List<WordPair>? _cachedWordPairs;

  WordRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<WordPair>> getWordPairs() async {
    try {
      if (_cachedWordPairs != null) {
        return List.from(_cachedWordPairs!);
      }

      final wordPairs = await dataSource.getWordPairs();
      _cachedWordPairs = wordPairs;
      return List.from(wordPairs);
    } catch (e) {
      throw Exception('Failed to get word pairs: $e');
    }
  }

  @override
  Future<int> get pairCount async {
    try {
      final pairs = await getWordPairs();
      return pairs.length;
    } catch (e) {
      throw Exception('Failed to get pair count: $e');
    }
  }

  void clearCache() {
    _cachedWordPairs = null;
  }
}
