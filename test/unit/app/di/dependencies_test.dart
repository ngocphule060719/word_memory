import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:word_memory/app/di/dependencies.dart';
import 'package:word_memory/data/datasources/local/local_word_pair_data_source.dart';
import 'package:word_memory/data/datasources/word_pair_data_source.dart';
import 'package:word_memory/data/repositories/word_repository_impl.dart';
import 'package:word_memory/domain/repositories/word_repository.dart';
import 'package:word_memory/domain/usecases/get_word_pairs_usecase.dart';

void main() {
  group('Dependencies', () {
    tearDown(() {
      Dependencies.dispose();
    });

    test('should register all dependencies correctly', () {
      // Act
      Dependencies.init();

      // Assert
      expect(Get.find<WordPairDataSource>(), isA<LocalWordPairDataSource>());
      expect(Get.find<WordRepository>(), isA<WordRepositoryImpl>());
      expect(Get.find<GetWordPairsUseCase>(), isA<GetWordPairsUseCase>());
    });

    test('should maintain singleton instances with fenix', () {
      // Arrange
      Dependencies.init();
      final firstDataSource = Get.find<WordPairDataSource>();
      final firstRepository = Get.find<WordRepository>();
      final firstUseCase = Get.find<GetWordPairsUseCase>();

      // Act
      Get.reset();
      Dependencies.init();
      final secondDataSource = Get.find<WordPairDataSource>();
      final secondRepository = Get.find<WordRepository>();
      final secondUseCase = Get.find<GetWordPairsUseCase>();

      // Assert
      expect(identical(firstDataSource, secondDataSource), isFalse);
      expect(identical(firstRepository, secondRepository), isFalse);
      expect(identical(firstUseCase, secondUseCase), isFalse);
    });

    test('should dispose all dependencies correctly', () {
      // Arrange
      Dependencies.init();

      // Act
      Dependencies.dispose();

      // Assert
      expect(() => Get.find<WordPairDataSource>(), throwsA(anything));
      expect(() => Get.find<WordRepository>(), throwsA(anything));
      expect(() => Get.find<GetWordPairsUseCase>(), throwsA(anything));
    });

    test('should create dependencies with correct dependencies', () {
      // Arrange & Act
      Dependencies.init();

      // Assert
      final repository = Get.find<WordRepository>() as WordRepositoryImpl;
      final useCase = Get.find<GetWordPairsUseCase>();

      expect(repository.dataSource, equals(Get.find<WordPairDataSource>()));
      expect(useCase, isNotNull);
    });
  });
}
