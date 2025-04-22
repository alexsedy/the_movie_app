import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_list_screen/viewmodel/tv_show_list_viewmodel.dart' show TvShowListViewModel;
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_pagination_vertical_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class TvShowListView extends StatefulWidget {
  const TvShowListView({super.key});

  @override
  State<TvShowListView> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<TvShowListView> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<TvShowListViewModel>();

    if (model.tvs.isEmpty && model.isLoadingInProgress) {
      return const DefaultListsShimmerSkeletonWidget();
    }

    if (model.tvs.isEmpty && !model.isLoadingInProgress) {
      return Center(
        child: Text(
          context.l10n.noResults,
          style: const TextStyle(
            fontSize: 36,
          ),
        ),
      );
    }

    // if(model.tvs.isEmpty) {
    //   return FutureBuilder<void>(
    //     future: Future.delayed(const Duration(milliseconds: 500)),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const DefaultListsShimmerSkeletonWidget();
    //       } else {
    //         return Center(
    //           child: Text(
    //             context.l10n.noResults,
    //             style: TextStyle(
    //               fontSize: 36,
    //             ),
    //           ),
    //         );
    //       }
    //     },
    //   );
    // }

    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        action: (context, index) => context.read<TvShowListViewModel>().onTvShowScreen(context, index),
        altImagePath: AppImages.noPoster,
        scrollController: model.scrollController,
        list: ConverterHelper.convertTVShowsForVerticalWidget(model.tvs),
        statuses: ConverterHelper.convertTvShowStatuses(model.tvShowStatuses)
      ), loadMoreItems: context.read<TvShowListViewModel>().loadContent,
    );
  }
}
