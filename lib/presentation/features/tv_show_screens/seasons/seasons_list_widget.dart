import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/seasons/viewmodel/seasons_list_view_model.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_vertical_list_widget.dart';

class SeasonsListWidget extends StatelessWidget {
  const SeasonsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.seasons),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SeasonsListViewModel>();
    final seasons = model.seasons;

    if (seasons.isEmpty) {
    return const SizedBox.shrink();
  }

    return ParameterizedVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noPoster,
        action: model.onSeasonDetailsScreen,
        list: ConverterHelper.convertSeason(seasons),
        statuses: ConverterHelper.convertSeasonStatuses(model.seasonsStatuses),
        additionAction: model.updateStatus,
      ),
    );
  }
}