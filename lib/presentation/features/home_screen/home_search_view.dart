import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/helpers/converter_helper.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/home_screen/viewmodel/home_search_viewmodel.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_pagination_vertical_list_widget.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class HomeSearchView extends StatefulWidget {
  const HomeSearchView({super.key});

  @override
  State<HomeSearchView> createState() => _HomeSearchViewState();
}

class _HomeSearchViewState extends State<HomeSearchView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final initialIndex = context.read<HomeSearchViewModel>().initialIndex;
    _tabController = TabController(length: 4, vsync: this, initialIndex: initialIndex);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(context.read<HomeSearchViewModel>().searchFocusNode);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.9,
        title: const _HeaderSearchBar(),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: context.l10n.movies),
            Tab(text: context.l10n.tvShows),
            Tab(text: context.l10n.persons),
            Tab(text: context.l10n.collections),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _MovieListWidget(),
          _TvShowListWidget(),
          _PersonListWidget(),
          _MediaCollectionListWidget(),
        ],
      ),
    );
  }
}

class _HeaderSearchBar extends StatelessWidget {
  const _HeaderSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<HomeSearchViewModel>();

    return Container(
      height: 45.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: viewModel.searchController,
        focusNode: viewModel.searchFocusNode,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          border: InputBorder.none,
          hintText: context.l10n.search,
          suffixIcon: IconButton(
            icon: Icon(Icons.clear, color: Colors.grey[600]),
            onPressed: () => viewModel.searchController.clear(),
          ),
        ),
      ),
    );
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeSearchViewModel>();

    if (viewModel.movies.isEmpty && viewModel.isMovieLoadingInProgress && viewModel.searchController.text.isNotEmpty) {
      return const DefaultListsShimmerSkeletonWidget();
    }
    if (viewModel.movies.isEmpty && !viewModel.isMovieLoadingInProgress && viewModel.searchController.text.isNotEmpty) {
      return Center(child: Text(context.l10n.noResults));
    }
    if (viewModel.searchController.text.isEmpty) {
      return Center(child: Text("Enter search query")); // TODO: Localize
    }


    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noPoster,
        action: (ctx, index) => ctx.read<HomeSearchViewModel>().onMovieScreen(context, index),
        scrollController: viewModel.movieScrollController,
        list: ConverterHelper.convertMoviesForVerticalWidget(viewModel.movies),
        statuses: ConverterHelper.convertMovieStatuses(viewModel.movieStatuses),
      ),
      loadMoreItems: context.read<HomeSearchViewModel>().loadMovies,
    );
  }
}

class _TvShowListWidget extends StatelessWidget {
  const _TvShowListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeSearchViewModel>();
    if (viewModel.tvs.isEmpty && viewModel.isTvsLoadingInProgress && viewModel.searchController.text.isNotEmpty) return const DefaultListsShimmerSkeletonWidget();
    if (viewModel.tvs.isEmpty && !viewModel.isTvsLoadingInProgress && viewModel.searchController.text.isNotEmpty) return Center(child: Text(context.l10n.noResults));
    if (viewModel.searchController.text.isEmpty) return Center(child: Text("Enter search query"));

    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noPoster,
        action: (ctx, index) => ctx.read<HomeSearchViewModel>().onTvShowScreen(context, index),
        scrollController: viewModel.tvScrollController,
        list: ConverterHelper.convertTVShowsForVerticalWidget(viewModel.tvs),
        statuses: ConverterHelper.convertTvShowStatuses(viewModel.tvShowStatuses),
      ),
      loadMoreItems: context.read<HomeSearchViewModel>().loadTvShows,
    );
  }
}

class _PersonListWidget extends StatelessWidget {
  const _PersonListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeSearchViewModel>();
    if (viewModel.persons.isEmpty && viewModel.isPersonLoadingInProgress && viewModel.searchController.text.isNotEmpty) return const DefaultListsShimmerSkeletonWidget();
    if (viewModel.persons.isEmpty && !viewModel.isPersonLoadingInProgress && viewModel.searchController.text.isNotEmpty) return Center(child: Text(context.l10n.noResults));
    if (viewModel.searchController.text.isEmpty) return Center(child: Text("Enter search query"));


    return ParameterizedPaginationVerticalListWidget(
      paramModel: ParameterizedWidgetModel(
        altImagePath: AppImages.noProfile,
        action: (ctx, index) => ctx.read<HomeSearchViewModel>().onPeopleDetailsScreen(context, index),
        scrollController: viewModel.personScrollController,
        list: ConverterHelper.convertTrendingPeopleForHorizontalWidget(viewModel.persons), // Используем этот конвертер
      ),
      loadMoreItems: context.read<HomeSearchViewModel>().loadPersons,
    );
  }
}

class _MediaCollectionListWidget extends StatelessWidget {
  const _MediaCollectionListWidget({super.key});
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<HomeSearchViewModel>();
    if (viewModel.collections.isEmpty && viewModel.isCollectionLoadingInProgress && viewModel.searchController.text.isNotEmpty) return const DefaultListsShimmerSkeletonWidget(); // Используем другой шиммер?
    if (viewModel.collections.isEmpty && !viewModel.isCollectionLoadingInProgress && viewModel.searchController.text.isNotEmpty) return Center(child: Text(context.l10n.noResults));
    if (viewModel.searchController.text.isEmpty) return Center(child: Text("Enter search query"));


    return ListView.builder(
      itemCount: viewModel.collections.length + (viewModel.isCollectionLoadingInProgress ? 1 : 0), // +1 для индикатора загрузки
      controller: viewModel.collectionScrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (BuildContext context, int index) {
        if (index >= viewModel.collections.length) {
          if(viewModel.isCollectionLoadingInProgress) {
            context.read<HomeSearchViewModel>().loadCollections();
            return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
          } else {
            return const SizedBox.shrink();
          }
        }

        final collection = viewModel.collections[index];
        final backdropPath = collection.backdropPath;
        final name = collection.name;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 150,
            child: Stack(
              children: [
                backdropPath != null
                    ? Opacity(
                  opacity: 0.3,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.network(
                      fit: BoxFit.fill,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      ApiClient.getImageByUrl(backdropPath),),
                  ),
                )
                    : Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    border: Border.all(color: Colors.transparent),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                ListTile(
                  onTap: (){
                    viewModel.onCollectionScreen(context, index);
                  },
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  title: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(name, /*...*/),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
