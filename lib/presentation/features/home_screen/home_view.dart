import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/media/list/list.dart';
import 'package:the_movie_app/data/models/person/trending_person/trending_person.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/home_screen/viewmodel/home_viewmodel.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_widget_display_model.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_horizontal_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.screenPaddingAll10,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            _SearchWidget(),
            AppSpacing.gapH20,
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.movie),
            AppSpacing.gapH20,
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.tv,),
            AppSpacing.gapH20,
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.trendingPerson,),
          ],
        ),
      ),
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 36,);
    final viewModel = context.read<HomeViewModel>();

    return Stack(
      alignment: Alignment.center,
      children: [
        Center(
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: 220,
            margin: AppSpacing.screenPaddingAll10,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const _BackgroundSearch(),
          ),
        ),
        Column(
          children: [
            AppSpacing.gapH40,
            Text(
              context.l10n.findAnythingWelcome,
              style: textStyle,
            ),
            AppSpacing.gapH20,
            Padding(
              padding: AppSpacing.screenPaddingH10,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        onTap: () => viewModel.onHomeSearchScreen(context: context),
                        readOnly: true,
                        dragStartBehavior: DragStartBehavior.start,
                        decoration: InputDecoration(
                          contentPadding: AppSpacing.screenPaddingH10,
                          hintText: context.l10n.searchGlobalSearchHint,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class _BackgroundSearch extends StatelessWidget {
  const _BackgroundSearch();
  @override
  Widget build(BuildContext context) {
    final backdropPath = context.select<HomeViewModel, String?>((v) => v.randomPoster);

    if(backdropPath == null || backdropPath.isEmpty) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(0.5),
        highlightColor: Colors.white.withOpacity(0.5),
        child: Container(
          color: Colors.greenAccent,
        ),
      );
    }

    return Opacity(
      opacity: 0.3,
      child: Image.network(ApiClient.getImageByUrl(backdropPath), fit: BoxFit.fitWidth,),
    );
  }
}

class _TrendingToggleWidget extends StatefulWidget { // <-- Делаем StatefulWidget
  final HorizontalListElementType horizontalListElementType;
  const _TrendingToggleWidget({required this.horizontalListElementType});

  @override
  State<_TrendingToggleWidget> createState() => _TrendingToggleWidgetState();
}

class _TrendingToggleWidgetState extends State<_TrendingToggleWidget> {
  bool _isDaySelected = true; // <-- Локальное состояние для переключателя

  String _getName(BuildContext context) {
    switch (widget.horizontalListElementType) {
      case HorizontalListElementType.movie: return context.l10n.trendingMovies;
      case HorizontalListElementType.tv: return context.l10n.trendingTvs;
      case HorizontalListElementType.trendingPerson: return context.l10n.trendingPersons;
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeViewModel>();

    final List dataList;
    final bool isLoading;
    final Function(BuildContext, int) onItemTap;
    final String altImagePath;
    final List<ParameterizedWidgetDisplayModel> displayList;

    switch (widget.horizontalListElementType) {
      case HorizontalListElementType.movie:
        dataList = viewModel.movies;
        isLoading = viewModel.isLoadingMovies;
        onItemTap = viewModel.onMovieScreen;
        altImagePath = AppImages.noPoster;
        displayList = ConverterHelper.convertMovieForHorizontalWidget(dataList as List<MediaList>);
        break;
      case HorizontalListElementType.tv:
        dataList = viewModel.tvs;
        isLoading = viewModel.isLoadingTvs;
        onItemTap = viewModel.onTvShowScreen;
        altImagePath = AppImages.noPoster;
        displayList = ConverterHelper.convertTVShowForHorizontalWidget(dataList as List<MediaList>);
        break;
      case HorizontalListElementType.trendingPerson:
        dataList = viewModel.persons;
        isLoading = viewModel.isLoadingPersons;
        onItemTap = viewModel.onPeopleDetailsScreen;
        altImagePath = AppImages.noProfile;
        displayList = ConverterHelper.convertTrendingPeopleForHorizontalWidget(dataList as List<TrendingPersonList>);
        break;
      default:
        return AppSpacing.emptyGap;
    }

    return Column(
      children: [
        Padding(
          padding: AppSpacing.screenPaddingH10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(_getName(context), maxLines: 2, style: const TextStyle(fontSize: 20)),
              ),
              AppSpacing.gapW10,
              SizedBox(
                height: 30,
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(10.0),
                  isSelected: [_isDaySelected, !_isDaySelected],
                  onPressed: (int index) {
                    final newIsDaySelected = index == 0;
                    if (_isDaySelected == newIsDaySelected) return;
                    setState(() {
                      _isDaySelected = newIsDaySelected;
                    });

                    final timeToggle = _isDaySelected ? "day" : "week";
                    final vm = context.read<HomeViewModel>();

                    switch (widget.horizontalListElementType) {
                      case HorizontalListElementType.movie:
                        vm.loadMovies(timeToggle: timeToggle);
                        break;
                      case HorizontalListElementType.tv:
                        vm.loadTvShows(timeToggle: timeToggle);
                        break;
                      case HorizontalListElementType.trendingPerson:
                        vm.loadTrendingPerson(timeToggle: timeToggle);
                        break;
                      default: break;
                    }
                  },
                  children: [
                    SizedBox(width: 80, child: Center(child: Text(context.l10n.day))),
                    SizedBox(width: 80, child: Center(child: Text(context.l10n.week))),
                  ],
                ),
              ),
            ],
          ),
        ),
        AppSpacing.gapH10,
        isLoading
            ? HorizontalListShimmerSkeletonWidget(horizontalListElementType: widget.horizontalListElementType)
            : dataList.isNotEmpty
            ? ParameterizedHorizontalListWidget(
            paramModel: ParameterizedWidgetModel(
              altImagePath: altImagePath,
              action: (ctx, index) => onItemTap(context, index),
              list: displayList,
            ))
            : Center(child: Text(context.l10n.noResults)),
      ],
    );
  }
}