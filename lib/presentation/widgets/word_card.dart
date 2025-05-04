import 'package:flutter/material.dart';
import 'package:word_memory/presentation/constants/app_constants.dart';

enum WordCardState {
  none,
  selecting,
  selected,
  correct,
  incorrect,
}

class WordCard extends StatelessWidget {
  const WordCard({
    super.key,
    required this.word,
    required this.index,
    this.state = WordCardState.none,
  });

  final String word;
  final int index;
  final WordCardState state;

  @override
  Widget build(BuildContext context) {
    final width =
        MediaQuery.sizeOf(context).width / AppConstants.cardWidthRatio;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.tinyPadding),
      width: width,
      decoration: BoxDecoration(
        color: _getStateColor(theme.colorScheme),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(color: _getBorderColor(theme.colorScheme)),
      ),
      child: _buildCardContent(context),
    );
  }

  Widget _buildCardContent(BuildContext context) {
    return Row(
      children: [
        _CardIndex(index: index, state: state),
        _CardContent(word: word, state: state),
      ],
    );
  }

  Color _getStateColor(ColorScheme colorScheme) => switch (state) {
        WordCardState.none => colorScheme.surface,
        WordCardState.selecting => colorScheme.primary.withAlpha(51),
        WordCardState.selected => colorScheme.onSurface.withAlpha(25),
        WordCardState.correct => colorScheme.secondary,
        WordCardState.incorrect => colorScheme.error.withAlpha(51),
      };

  Color _getBorderColor(ColorScheme colorScheme) => switch (state) {
        WordCardState.none => colorScheme.onSurface.withAlpha(128),
        WordCardState.selecting => colorScheme.primary,
        WordCardState.selected => colorScheme.onSurface.withAlpha(25),
        WordCardState.correct => Colors.green.shade600,
        WordCardState.incorrect => colorScheme.error,
      };
}

class _CardIndex extends StatelessWidget {
  const _CardIndex({
    required this.index,
    required this.state,
  });

  final int index;
  final WordCardState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Flexible(
      flex: AppConstants.cardIndexFlexRatio.toInt(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.smallPadding,
          horizontal: AppConstants.tinyPadding,
        ),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(color: _getBorderColor(theme.colorScheme)),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppConstants.defaultBorderRadius),
            bottomLeft: Radius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
        child: Text(
          index < 1 ? AppStrings.defaultIndex : index.toString(),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: _getTextColor(theme.colorScheme),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getBorderColor(ColorScheme colorScheme) => switch (state) {
        WordCardState.none => colorScheme.onSurface.withAlpha(128),
        WordCardState.selecting => colorScheme.primary,
        WordCardState.selected => colorScheme.onSurface.withAlpha(25),
        WordCardState.correct => Colors.green.shade600,
        WordCardState.incorrect => colorScheme.error,
      };

  Color _getTextColor(ColorScheme colorScheme) => switch (state) {
        WordCardState.none => colorScheme.onSurface.withAlpha(128),
        WordCardState.selecting => colorScheme.primary,
        WordCardState.selected => colorScheme.onSurface.withAlpha(25),
        WordCardState.correct => Colors.green.shade600,
        WordCardState.incorrect => colorScheme.error,
      };
}

class _CardContent extends StatelessWidget {
  const _CardContent({
    required this.word,
    required this.state,
  });

  final String word;
  final WordCardState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Flexible(
      flex: AppConstants.cardContentFlexRatio.toInt(),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.smallPadding,
          horizontal: AppConstants.tinyPadding,
        ),
        child: Text(
          word,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: _getTextColor(theme.colorScheme),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Color _getTextColor(ColorScheme colorScheme) => switch (state) {
        WordCardState.none => colorScheme.onSurface.withAlpha(128),
        WordCardState.selecting => colorScheme.primary,
        WordCardState.selected => colorScheme.onSurface.withAlpha(25),
        WordCardState.correct => Colors.green.shade600,
        WordCardState.incorrect => colorScheme.error,
      };
}
