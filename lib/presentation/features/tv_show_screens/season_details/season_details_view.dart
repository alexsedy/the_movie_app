import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/season_details/viewmodel/season_details_viewmodel.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_vertical_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/color_list_shimmer_skeleton_widget.dart';

class SeasonDetailsView extends StatelessWidget {
  const SeasonDetailsView({super.key});

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
    final model = context.watch<SeasonDetailsViewModel>();
    final name = model.season?.name;
    final seriesCount = model.season?.episodes.length;
    final airDate = model.season?.airDate;
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
        if(seriesCount != null && date != null)
        Text(
          context.l10n.episodesSeriesCountDate(seriesCount, date),
        ),
      ],
    );
  }
}

class _BodySeason extends StatelessWidget {
  const _BodySeason();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SeasonDetailsViewModel>();
    final season = model.season;

    if (season == null) {
    return const ColorListShimmerSkeletonWidget();
  }

    return ParameterizedVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noPoster,
        list: ConverterHelper.convertEpisodes(season),
        action: model.onSeriesDetailsScreen,
        statuses: ConverterHelper.convertEpisodeStatuses(model.episodesStatuses),
        additionAction: model.updateStatus
      ),
    );
  }
}
