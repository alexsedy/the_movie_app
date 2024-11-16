import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/navigation/main_navigation.dart';

class AiFeatureStartModel extends ChangeNotifier {
  void onAiListRecommendationByGenre(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.aiRecommendationByGenre);
  }

  void onAiListRecommendationByDescription(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.aiRecommendationByDescription);
  }
}