import 'package:flutter/material.dart';
import 'package:the_movie_app/presentation/features/navigation/main_navigation.dart';

class AiFeatureStartViewModel extends ChangeNotifier {
  void onAiListRecommendationByGenre(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.aiRecommendationByGenre);
  }

  void onAiListRecommendationByDescription(BuildContext context) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.aiRecommendationByDescription);
  }
}
