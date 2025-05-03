import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:word_memory/app/di/dependencies.dart';
import 'package:word_memory/data/datasources/word_pair_data_source.dart';
import 'package:word_memory/domain/repositories/word_repository.dart';

void main() {
  group('Dependencies', () {
    setUp(() {
      Get.reset();
    });

    tearDown(() {
      Get.reset();
    });

    test('init should register all dependencies', () {
      Dependencies.init();

      expect(
        Get.isPrepared<WordPairDataSource>(),
        true,
        reason: 'WordPairDataSource should be registered',
      );
      expect(
        Get.isPrepared<WordRepository>(),
        true,
        reason: 'WordRepository should be registered',
      );
    });

    test('dependencies should be lazily initialized', () {
      Dependencies.init();

      expect(
        Get.isPrepared<WordPairDataSource>(),
        true,
        reason: 'WordPairDataSource should be prepared',
      );
      expect(
        Get.isPrepared<WordRepository>(),
        true,
        reason: 'WordRepository should be prepared',
      );

      final dataSource = Get.find<WordPairDataSource>();
      final repository = Get.find<WordRepository>();

      expect(
        dataSource,
        isNotNull,
        reason: 'WordPairDataSource should be initialized after access',
      );
      expect(
        repository,
        isNotNull,
        reason: 'WordRepository should be initialized after access',
      );
    });

    test('dispose should remove all dependencies', () {
      Dependencies.init();

      final dataSource = Get.find<WordPairDataSource>();
      final repository = Get.find<WordRepository>();
      expect(dataSource, isNotNull);
      expect(repository, isNotNull);

      Dependencies.dispose();

      expect(
        () => Get.find<WordPairDataSource>(),
        throwsA(anything),
        reason: 'WordPairDataSource should be removed',
      );
      expect(
        () => Get.find<WordRepository>(),
        throwsA(anything),
        reason: 'WordRepository should be removed',
      );
    });

    test('dependencies should be recreated after disposal due to fenix', () {
      Dependencies.init();
      final firstDataSource = Get.find<WordPairDataSource>();
      Dependencies.dispose();
      Dependencies.init();

      final secondDataSource = Get.find<WordPairDataSource>();
      expect(
        identical(firstDataSource, secondDataSource),
        false,
        reason:
            'New instance should be created after disposal due to fenix: true',
      );
    });
  });
}
