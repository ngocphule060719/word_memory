import 'package:word_memory/data/datasources/word_pair_data_source.dart';
import 'package:word_memory/data/models/word_pair_model.dart';

class RemoteWordPairDataSource implements WordPairDataSource {
  final String baseUrl;

  RemoteWordPairDataSource({
    this.baseUrl = 'https://api.example.com',
  });

  @override
  Future<List<WordPairModel>> getWordPairs() async {
    throw UnimplementedError('Remote data source not implemented yet');
  }
}
