import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_vertical_list_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/season_details/season_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/color_list_shimmer_skeleton_widget.dart';

class SeasonDetailsWidget extends StatefulWidget {
  const SeasonDetailsWidget({super.key});

  @override
  State<SeasonDetailsWidget> createState() => _SeasonDetailsWidgetState();
}

class _SeasonDetailsWidgetState extends State<SeasonDetailsWidget> {
  @override
  void initState() {
    NotifierProvider.read<SeasonDetailsModel>(context)?.loadSeasonDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: const _AppBarText(),
      ),
      body: const _BodySeason(),
    );
  }
}

class _AppBarText extends StatelessWidget {
  const _AppBarText();

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SeasonDetailsModel>(context);
    final name = model?.season?.name;
    final seriesCount = model?.season?.episodes.length;
    final airDate = model?.season?.airDate;
    final date = airDate?.substring(0, 4);

    if(name == null) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.white.withOpacity(0.5),
        child: Container(
          color: Colors.white,
          height: 40,
          width: double.infinity,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name,),
        Text(
          "Episodes: $seriesCount • $date",
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _BodySeason extends StatelessWidget {
  const _BodySeason();

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SeasonDetailsModel>(context);
    final season = model?.season;

    if(model == null) {
      return const SizedBox.shrink();
    } else if (season == null) {
      return const ColorListShimmerSkeletonWidget();
    }

    return ParameterizedVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noPoster,
        list: ConverterHelper.convertEpisodes(season),
        action: model.onSeriesDetailsScreen,
      ),
    );
  }
}
