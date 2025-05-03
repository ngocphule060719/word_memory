import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:word_memory/core/utils/parser.dart';
import 'package:word_memory/core/utils/word_pair_validator.dart';
import 'package:word_memory/data/datasources/word_pair_data_source.dart';
import 'package:word_memory/data/models/word_pair_model.dart';

class LocalWordPairDataSource implements WordPairDataSource {
  final String assetPath;
  final AssetBundle assetBundle;

  LocalWordPairDataSource({
    this.assetPath = 'assets/data/word_pairs.json',
    AssetBundle? assetBundle,
  }) : assetBundle = assetBundle ?? rootBundle;

  @override
  Future<List<WordPairModel>> getWordPairs() async {
    try {
      final jsonString = await _loadJsonString();
      return _parseAndValidateWordPairs(jsonString);
    } on Exception catch (e) {
      throw Exception('Failed to load word pairs: $e');
    }
  }

  Future<String> _loadJsonString() async {
    try {
      return await assetBundle.loadString(assetPath);
    } catch (e) {
      throw Exception('Failed to load asset file: $e');
    }
  }

  List<WordPairModel> _parseAndValidateWordPairs(String jsonString) {
    final dynamic jsonData;
    try {
      jsonData = json.decode(jsonString);
    } catch (e) {
      throw Exception('Invalid JSON format: $e');
    }

    final validatedJson = WordPairValidator.validateJsonStructure(jsonData);
    final wordPairsList = validatedJson.parseListMap('word_pairs');
    return WordPairModel.fromJsonList(wordPairsList);
  }
}
