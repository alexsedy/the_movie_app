import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/ai_feature_screen/by_genre/ai_recommendation_by_genre/ai_recommendation_by_genre_model.dart';
import 'package:the_movie_app/widgets/widget_elements/animation_element/running_color_border.dart';

class AiRecommendationByGenreScreenWidget extends StatelessWidget {
  const AiRecommendationByGenreScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
       return Scaffold(
      appBar: AppBar(
        title: Text("AI Recommendation"),
      ),
      body: _GenerateMovieByGenreWidget(),
    );
  }
}

class _GenerateMovieByGenreWidget extends StatefulWidget {
  const _GenerateMovieByGenreWidget({
    super.key,
  });

  @override
  State<_GenerateMovieByGenreWidget> createState() => _GenerateMovieByGenreWidgetState();
}

class _GenerateMovieByGenreWidgetState extends State<_GenerateMovieByGenreWidget> {
  var _sliderValue = 10.0;
  final List<bool> _isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<AiRecommendationByGenreModel>(context);

    if(model == null) {
      return SizedBox.shrink();
    }
    final movieGenreActions = model.movieGenreActions;
    final tvGenreActions = model.tvGenreActions;
    final isReadyToGenerate = model.isReadyToGenerate;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        children: [
          Text(
            "Select Movie or TV",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10,),
          ToggleButtons(
            onPressed: (int index) {
              model.resetGenre(_isSelected.first);
              setState(() {
                for (int i = 0; i < _isSelected.length; i++) {
                  _isSelected[i] = i == index;
                }
              });
            },
            borderRadius: BorderRadius.circular(10.0),
            isSelected: _isSelected,
            children: [
              SizedBox(width: 80, child: Center(child: Text("Movie"),),),
              SizedBox(width: 80, child: Center(child: Text("TV Show",),),),
            ],
          ),
          SizedBox(height: 20,),
          Text(
            "Select one or more genres",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10,),
          if(_isSelected.first)
            Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: movieGenreActions.entries.map((entry) {
              return ActionChip(
                label: Text(entry.key),
                backgroundColor: entry.value ? Colors.blueAccent : Colors.transparent,
                onPressed: () {
                  setState(() {
                    movieGenreActions[entry.key] = !entry.value;
                    if(movieGenreActions.values.any((element) => element == true)) {
                      model.isReadyToGenerate = true;
                    } else {
                      model.isReadyToGenerate = false;
                    }
                  });
                },
              );
            }).toList(),
          ),
          if(_isSelected.last)
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: tvGenreActions.entries.map((entry) {
                return ActionChip(
                  label: Text(entry.key),
                  backgroundColor: entry.value ? Colors.blueAccent : Colors.transparent,
                  onPressed: () {
                    setState(() {
                      tvGenreActions[entry.key] = !entry.value;
                      if(tvGenreActions.values.any((element) => element == true)) {
                        model.isReadyToGenerate = true;
                      } else {
                        model.isReadyToGenerate = false;
                      }
                    });
                  },
                );
              }).toList(),
            ),
          SizedBox(height: 20,),
          Text(
            "Select max number of items",
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10,),
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
          SizedBox(height: 20,),
          SizedBox(
            height: 50,
            width: 300,
            child: ElevatedButton(
              onPressed: isReadyToGenerate ? () =>
                model.onGenerateContent(context, _sliderValue.toInt(), _isSelected.first)
                : null,
              child: Text("Generate"),
            ),
          ),
        ],
      ),
    );
  }
}
