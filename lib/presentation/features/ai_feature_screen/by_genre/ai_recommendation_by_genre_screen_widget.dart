import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/by_genre/viewmodel/ai_recommendation_by_genre_viewmodel.dart';

class AiRecommendationByGenreView extends StatelessWidget {
  const AiRecommendationByGenreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.aiRecommendation),
      ),
      body: const _GenerateMovieByGenreWidget(),
    );
  }
}

class _GenerateMovieByGenreWidget extends StatefulWidget {
  const _GenerateMovieByGenreWidget();

  @override
  State<_GenerateMovieByGenreWidget> createState() => _GenerateMovieByGenreWidgetState();
}

class _GenerateMovieByGenreWidgetState extends State<_GenerateMovieByGenreWidget> {
  double _sliderValue = 10.0;
  final List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AiRecommendationByGenreViewModel>();
    final isMovieSelected = _isSelected.first;

    final Map<String, bool> currentGenreActions = isMovieSelected
        ? viewModel.movieGenreActions
        : viewModel.tvGenreActions;

    void Function(String) currentToggleAction = isMovieSelected
        ? viewModel.toggleMovieGenre
        : viewModel.toggleTvGenre;

    return Padding(
      padding: AppSpacing.screenPaddingAll10,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              context.l10n.selectMovieOrTv,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.gapH10,
            ToggleButtons(
              onPressed: (int index) {
                if (_isSelected[index]) return;
                context.read<AiRecommendationByGenreViewModel>().resetGenre(index == 0);
                setState(() {
                  for (int i = 0; i < _isSelected.length; i++) {
                    _isSelected[i] = i == index;
                  }
                });
              },
              borderRadius: BorderRadius.circular(10.0),
              isSelected: _isSelected,
              constraints: BoxConstraints(minWidth: (MediaQuery.of(context).size.width - 40) / 2, minHeight: 40), // Делаем кнопки одинаковой ширины
              children: [
                Text(context.l10n.movies),
                Text(context.l10n.tvShows),
              ],
            ),
            AppSpacing.gapH20,
            Text(
              context.l10n.selectOneOrMoreGenres,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.gapH10,
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: currentGenreActions.entries.map((entry) {
                return ActionChip(
                  label: Text(entry.key),
                  backgroundColor: entry.value ? Theme.of(context).colorScheme.primaryContainer : null, // Используем цвет темы
                  side: entry.value ? BorderSide.none : BorderSide(color: Colors.grey.shade400), // Граница для невыбранных
                  onPressed: () {
                    currentToggleAction(entry.key);
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                );
              }).toList(),
            ),
            AppSpacing.gapH20,
            Text(
              context.l10n.selectMaxNumberOfItems,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            AppSpacing.gapH10,
            Slider(
              value: _sliderValue,
              onChanged: (value) {
                setState(() {
                  _sliderValue = value;
                });
              },
              label: _sliderValue.toInt().toString(),
              min: 1,
              max: 100,
              divisions: 99,
            ),
            AppSpacing.gapH20,
            SizedBox(
              height: 50,
              width: 300,
              child: ElevatedButton(
                onPressed: viewModel.isReadyToGenerate
                    ? () => context.read<AiRecommendationByGenreViewModel>().onGenerateContent(
                  context,
                  _sliderValue.toInt(),
                  isMovieSelected,
                )
                    : null,
                child: Text(context.l10n.generate),
              ),
            ),
            AppSpacing.gapH20,
          ],
        ),
      ),
    );
  }
}