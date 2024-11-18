import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/ai_feature_screen/ai_feature_start_sreen/ai_feature_start_model.dart';
import 'package:the_movie_app/widgets/widget_elements/animation_element/running_color_border.dart';

class AiFeatureStartScreen extends StatelessWidget {
  const AiFeatureStartScreen({super.key});

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
    final model = NotifierProvider.watch<AiFeatureStartModel>(context);

    if(model == null) {
      return SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.l10n.discoverGeminiAiMessage,
            style: TextStyle(fontSize: 26),
          ),
          SizedBox(height: 40,),
          RunningColorBorder(
            radius: 50,
            child: ElevatedButton(
              onPressed: () => model.onAiListRecommendationByGenre(context),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Image.asset(AppImages.geminiIcon, height: 50,),
                    SizedBox(width: 20,),
                    Text(context.l10n.generateListByGenres),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 40,),
          RunningColorBorder(
            radius: 50,
            child: ElevatedButton(
              onPressed: () => model.onAiListRecommendationByDescription(context),
              child: SizedBox(
                height: 100,
                child: Row(
                  children: [
                    Image.asset(AppImages.geminiIcon, height: 50,),
                    SizedBox(width: 20,),
                    Text(context.l10n.generateListByDescription),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(height: 40,),
          // RunningColorBorder(
          //   radius: 50,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: SizedBox(
          //       height: 100,
          //       child: Row(
          //         children: [
          //           Image.asset(AppImages.geminiIcon, height: 50,),
          //           SizedBox(width: 20,),
          //           Text(""),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // SizedBox(height: 40,),
          // RunningColorBorder(
          //   radius: 50,
          //   child: ElevatedButton(
          //     onPressed: () {},
          //     child: SizedBox(
          //       height: 100,
          //       child: Row(
          //         children: [
          //           Image.asset(AppImages.geminiIcon, height: 50,),
          //           SizedBox(width: 20,),
          //           Text(""),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}