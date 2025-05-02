import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/ai_feature_screen/ai_feature_start_sreen/viewmodel/ai_feature_start_viewmodel.dart';
import 'package:the_movie_app/presentation/widgets/animation_element/running_color_border.dart';

class AiFeatureStartView extends StatelessWidget {
  const AiFeatureStartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.aiRecommendation,),
      ),
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<AiFeatureStartViewModel>();

    return Padding(
      padding: AppSpacing.screenPaddingAll10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.l10n.discoverGeminiAiMessage,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          AppSpacing.gapH40,
          RunningColorBorder(
            radius: 50,
            child: ElevatedButton(
              onPressed: () => model.onAiListRecommendationByGenre(context),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Image.asset(AppImages.geminiIcon, height: 50,),
                    AppSpacing.gapW20,
                    Text(context.l10n.generateListByGenres),
                  ],
                ),
              ),
            ),
          ),
          AppSpacing.gapH40,
          RunningColorBorder(
            radius: 50,
            child: ElevatedButton(
              onPressed: () => model.onAiListRecommendationByDescription(context),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Image.asset(AppImages.geminiIcon, height: 50,),
                    AppSpacing.gapW20,
                    Text(context.l10n.generateListByDescription),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}