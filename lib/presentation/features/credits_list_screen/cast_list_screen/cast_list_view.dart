import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/credits_list_screen/cast_list_screen/viewmodel/cast_list_viewmodel.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_vertical_list_widget.dart';

class CastListView extends StatelessWidget {
  const CastListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.cast),
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
    final model = context.read<CastListViewModel>();
    final cast = model.cast;

    if (cast.isEmpty) {
    return AppSpacing.emptyGap;
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