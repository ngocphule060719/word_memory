import 'package:word_memory/core/utils/parser.dart';
import 'package:word_memory/core/utils/word_pair_validator.dart';
import 'package:word_memory/domain/entities/word_pair.dart';

class WordPairModel extends WordPair {
  const WordPairModel({
    required String englishWord,
    required String frenchWord,
  }) : super(englishWord: englishWord, frenchWord: frenchWord);

  factory WordPairModel.fromJson(Map<String, dynamic> json) {
    _validateJson(json);
    return WordPairModel(
      englishWord: json.parseString('english'),
      frenchWord: json.parseString('french'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'english': englishWord,
      'french': frenchWord,
    };
  }

  static List<WordPairModel> fromJsonList(List<dynamic> jsonList) {
    if (jsonList.isEmpty) {
      throw Exception('Word pairs list cannot be empty');
    }

    return jsonList.map<WordPairModel>((dynamic pair) {
      try {
        if (pair is! Map<String, dynamic>) {
          throw Exception('Invalid word pair format: expected a map');
        }

        WordPairValidator.validateWordPairFields(pair);
        return WordPairModel(
          englishWord: pair['english'] as String,
          frenchWord: pair['french'] as String,
        );
      } catch (e) {
        throw Exception('Failed to parse word pair: $e');
      }
    }).toList();
  }

  static void _validateJson(Map<String, dynamic> json) {
    if (!json.containsKey('english')) {
      throw Exception('Missing required field: english');
    }
    if (!json.containsKey('french')) {
      throw Exception('Missing required field: french');
    }

    final english = json.parseString('english');
    final french = json.parseString('french');

    if (english.isEmpty) {
      throw Exception('English word cannot be empty');
    }
    if (french.isEmpty) {
      throw Exception('French word cannot be empty');
    }
  }

  @override
  String toString() =>
      'WordPairModel(englishWord: $englishWord, frenchWord: $frenchWord)';
}
