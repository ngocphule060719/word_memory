import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:word_memory/domain/entities/word_pair.dart';
import 'package:word_memory/domain/usecases/get_word_pairs_usecase.dart';
import 'package:word_memory/presentation/constants/app_constants.dart';
import 'package:word_memory/presentation/cubit/word_pair_cubit.dart';
import 'package:word_memory/presentation/cubit/word_pair_state.dart';
import 'package:word_memory/presentation/models/game_ui_state.dart';
import 'package:word_memory/presentation/widgets/action_button.dart';
import 'package:word_memory/presentation/widgets/card_list.dart';

class WordMemoryScreen extends StatelessWidget {
  const WordMemoryScreen({super.key});

  static Widget newInstance() {
    return BlocProvider(
      create: (context) => WordPairCubit(
        useCase: Get.find<GetWordPairsUseCase>(),
      ),
      child: const WordMemoryScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appTitle),
        centerTitle: false,
        actions: [
          _buildAppBarActions(),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildAppBarActions() {
    return BlocBuilder<WordPairCubit, WordPairState>(
      buildWhen: (previous, current) {
        if (previous is WordPairLoadedState && current is WordPairLoadedState) {
          return previous.gameState.status != current.gameState.status;
        }
        return true;
      },
      builder: (context, state) {
        if (state is! WordPairLoadedState) return const SizedBox.shrink();

        final gameState = state.gameState;
        final buttonText = gameState.canStartGame
            ? AppStrings.startButtonText
            : AppStrings.gradeButtonText;

        return Padding(
          padding: const EdgeInsets.only(right: AppConstants.defaultPadding),
          child: AppBarActionButton(
            title: buttonText,
            onTap: () {
              final cubit = context.read<WordPairCubit>();
              if (gameState.canStartGame) {
                cubit.shuffleAndStart();
              } else if (gameState.canGrade) {
                cubit.grade();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return BlocBuilder<WordPairCubit, WordPairState>(
      builder: (context, state) => switch (state) {
        WordPairLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
        WordPairErrorState() => _ErrorScreen(message: state.message),
        WordPairLoadedState() => _buildGameContent(state),
      },
    );
  }

  Widget _buildGameContent(WordPairLoadedState state) {
    final gameState = state.gameState;

    if (!gameState.showGameContent) {
      return const Center(
        child: Text(AppStrings.startGamePrompt),
      );
    }

    return Column(
      children: [
        if (gameState.showGrade) _buildGradeDisplay(gameState.grade),
        Expanded(
          child: _buildCardColumns(gameState),
        ),
      ],
    );
  }

  Widget _buildGradeDisplay(String grade) {
    return Builder(builder: (context) {
      return Column(
        children: [
          Text(
            '${AppStrings.gradePrefix}$grade',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.green.shade600,
                ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
        ],
      );
    });
  }

  Widget _buildCardColumns(GameUiState gameState) {
    return Builder(builder: (context) {
      return Row(
        children: [
          _buildCardListColumn(
            context,
            true,
            gameState,
          ),
          _buildCardListColumn(
            context,
            false,
            gameState,
          ),
        ],
      );
    });
  }

  Widget _buildCardListColumn(
    BuildContext context,
    bool isEnglish,
    GameUiState gameState,
  ) {
    return Expanded(
      child: CardList(
        isEnglish: isEnglish,
        isGameEnded: gameState.status == GameStatus.completed,
        words: isEnglish ? gameState.englishWords : gameState.frenchWords,
        currentUserTapIndex: gameState.currentUserTapIndex,
        wordPairMaps: gameState.wordPairsMap,
        sourceWordPairs: gameState.sourceWordPairs,
        onTap: (word) => _onCardTap(context, isEnglish, word),
      ),
    );
  }

  void _onCardTap(BuildContext context, bool isEnglish, String word) {
    final cubit = context.read<WordPairCubit>();
    final state = cubit.state;
    if (state is! WordPairLoadedState) return;

    final gameState = state.gameState;
    final currentIndex =
        gameState.currentUserTapIndex == 0 ? 1 : gameState.currentUserTapIndex;

    WordPair wordPair = WordPair.empty();
    if (isEnglish) {
      wordPair = wordPair.copyWith(englishWord: word);
    } else {
      wordPair = wordPair.copyWith(frenchWord: word);
    }

    final newWordPair = cubit.updateWordPair(currentIndex, wordPair);
    if (newWordPair != null && newWordPair.isValid) {
      cubit.updateCurrentUserTapIndex(currentIndex + 1);
    } else if (newWordPair != null) {
      cubit.updateCurrentUserTapIndex(currentIndex);
    }
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
      ),
    );
  }
}
