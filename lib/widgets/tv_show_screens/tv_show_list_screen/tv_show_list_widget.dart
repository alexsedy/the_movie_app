import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/helpers/converter_helper.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_list_screen/tv_show_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/params_pagination_vertical_list_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class TvShowListWidget extends StatefulWidget {
  const TvShowListWidget({super.key});

  @override
  State<TvShowListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<TvShowListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = NotifierProvider.read<TvShowListModel>(context)?.scrollController ?? ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowListModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.tvs.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(milliseconds: 500)),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const DefaultListsShimmerSkeletonWidget();
          } else {
            return const Center(
              child: Text(
                "No results.",
                style: TextStyle(
                  fontSize: 36,
                ),
              ),
            );
          }
        },
      );
    }

    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        action: model.onTvShowScreen,
        altImagePath: AppImages.noPoster,
        scrollController: model.scrollController,
        list: ConverterHelper.convertTVShowsForVerticalWidget(model.tvs),
      ), loadMoreItems: model.loadTvShows,
    );
  }
}