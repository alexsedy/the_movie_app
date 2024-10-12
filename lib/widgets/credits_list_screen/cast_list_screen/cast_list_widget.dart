import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/credits_list_screen/cast_list_screen/cast_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_vertical_list_widget.dart';

class CastListWidget extends StatelessWidget {
  const CastListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cast"),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<CastListModel>(context);
    final cast = model?.cast;

    if(model == null) {
      return const SizedBox.shrink();
    }

    if (cast == null) {
      return const SizedBox.shrink();
    } else if (cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return ParameterizedVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noProfile,
        action: model.onPeopleScreen,
        list: ConverterHelper.convertCasts(cast),
      ),
    );
  }
}