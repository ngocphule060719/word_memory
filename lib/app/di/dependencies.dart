import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:word_memory/data/datasources/local/local_word_pair_data_source.dart';
import 'package:word_memory/data/datasources/word_pair_data_source.dart';
import 'package:word_memory/data/repositories/word_repository_impl.dart';
import 'package:word_memory/domain/repositories/word_repository.dart';

class Dependencies {
  const Dependencies._();

  static void init() {
    Get.reset();
    _registerDependencies();
  }

  static void _registerDependencies() {
    Get.lazyPut<WordPairDataSource>(
      () => LocalWordPairDataSource(
        assetPath: 'assets/data/word_pairs.json',
        assetBundle: rootBundle,
      ),
      fenix: true,
    );

    Get.lazyPut<WordRepository>(
      () => WordRepositoryImpl(
        dataSource: Get.find<WordPairDataSource>(),
      ),
      fenix: true,
    );
  }

  static void dispose() {
    Get.reset();
  }
}
