class WordPairValidator {
  const WordPairValidator._();

  static Map<String, dynamic> validateJsonStructure(dynamic jsonData) {
    if (jsonData is! Map<String, dynamic>) {
      throw Exception('Invalid JSON format: expected a map');
    }

    if (!jsonData.containsKey('word_pairs')) {
      throw Exception('Invalid JSON structure: missing word_pairs key');
    }

    final wordPairs = jsonData['word_pairs'];
    if (wordPairs is! List) {
      throw Exception('Invalid JSON structure: word_pairs must be a list');
    }

    return jsonData;
  }

  static void validateWordPairFields(Map<String, dynamic> pair) {
    final english = pair['english'];
    final french = pair['french'];

    if (english == null || french == null) {
      throw Exception('Invalid word pair: missing english or french field');
    }

    if (english is! String || french is! String) {
      throw Exception('Invalid word pair: english and french must be strings');
    }

    if (english.isEmpty || french.isEmpty) {
      throw Exception('Invalid word pair: english and french cannot be empty');
    }
  }
}
