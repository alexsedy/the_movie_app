import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_vertical_list_widget.dart';

import 'seasons_list_model.dart';

class SeasonsListWidget extends StatelessWidget {
  const SeasonsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seasons"),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<SeasonsListModel>(context);
    final seasons = model?.seasons;

    if(model == null) {
      return const SizedBox.shrink();
    }

    if (seasons == null) {
      return const SizedBox.shrink();
    } else if (seasons.isEmpty) {
      return const SizedBox.shrink();
    }

    return ParameterizedVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noPoster,
        action: model.onSeasonDetailsScreen,
        list: ConverterHelper.convertSeason(seasons),
      ),
    );
  }
}