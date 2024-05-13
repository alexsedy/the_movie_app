import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/home_screen/home_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/horizontal_list_element_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            _SearchWidget(),
            SizedBox(height: 20,),
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.movie),
            SizedBox(height: 20,),
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.tv,),
            SizedBox(height: 20,),
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.trendingPerson,),
            // ToggleWidgets(),
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
    final model = NotifierProvider.watch<HomeModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    }

    final searchController = model.searchController;

    return Stack(
      children: [
        Center(
          child: Container(
            clipBehavior: Clip.hardEdge,
            height: 220,
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: const _BackgroundSearch(),
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 40),
            const Text(
              "Find anything",
              style: textStyle,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: TextField(
                        dragStartBehavior: DragStartBehavior.start,
                        onChanged: (value) {
                          if(value.isNotEmpty) {
                            model.onHomeSearchScreen(context);
                          }
                        },
                        controller: searchController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          hintText: 'Search movie, TV, person',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 2),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(),
                  //     borderRadius: BorderRadius.circular(8.0),
                  //   ),
                  //   child: IconButton(
                  //     onPressed: () {
                  //       if(searchController.text.isNotEmpty) {
                  //         model.onHomeSearchScreen(context);
                  //       }
                  //     },
                  //     icon: const Icon(Icons.search),
                  //   ),
                  // ),
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
  const _BackgroundSearch({super.key,});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeModel>(context);
    final backdropPath = model?.randomPoster;


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

class _TrendingToggleWidget extends StatefulWidget {
  final HorizontalListElementType horizontalListElementType;
  const _TrendingToggleWidget({super.key, required this.horizontalListElementType});

  @override
  State<_TrendingToggleWidget> createState() => _TrendingToggleWidgetState();
}

class _TrendingToggleWidgetState extends State<_TrendingToggleWidget> {
  final List<bool> _isSelected = [true, false];

  @override
  void initState() {
    super.initState();
    NotifierProvider.read<HomeModel>(context)?.loadMovies();
    NotifierProvider.read<HomeModel>(context)?.loadTvShows();
    NotifierProvider.read<HomeModel>(context)?.loadTrendingPerson();
  }

  String _getName() {
    switch(widget.horizontalListElementType){
      case HorizontalListElementType.movie:
        return "Trending movies";
      case HorizontalListElementType.tv:
        return "Trending TVs";
      case HorizontalListElementType.trendingPerson:
        return "Trending persons";
      default:
        return "";
    }
  }



  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getName(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 30,
                child: ToggleButtons(
                  borderRadius: BorderRadius.circular(10.0), // Rou
                  isSelected: _isSelected,
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < _isSelected.length; i++) {
                        _isSelected[i] = i == index;

                        switch(widget.horizontalListElementType){
                          case HorizontalListElementType.movie:
                            model.isSwitch = _isSelected.first;
                            NotifierProvider.read<HomeModel>(context)?.loadMovies();
                          case HorizontalListElementType.tv:
                            model.isSwitch = _isSelected.first;
                            NotifierProvider.read<HomeModel>(context)?.loadTvShows();
                          case HorizontalListElementType.trendingPerson:
                            model.isSwitch = _isSelected.first;
                            NotifierProvider.read<HomeModel>(context)?.loadTrendingPerson();
                          default:

                        }
                      }
                    });
                  },
                  children: const [
                    SizedBox(width: 80, child: Center(child: Text('Day',),),),
                    SizedBox(width: 80, child: Center(child: Text('Week',),),),
                  ],
                ),
              ),
            ],
          ),
        ),
        switch(widget.horizontalListElementType){
          HorizontalListElementType.movie => model.movies.isNotEmpty
            ? HorizontalListElementWidget<HomeModel>(
                horizontalListElementType: HorizontalListElementType.movie,
                model: model,
              )
            : const HorizontalListShimmerSkeletonWidget(horizontalListElementType: HorizontalListElementType.movie,),
          HorizontalListElementType.tv => model.tvs.isNotEmpty
              ? HorizontalListElementWidget<HomeModel>(
                  horizontalListElementType: HorizontalListElementType.tv,
                  model: model,
                )
              : const HorizontalListShimmerSkeletonWidget(horizontalListElementType: HorizontalListElementType.tv,),
          HorizontalListElementType.trendingPerson => model.persons.isNotEmpty
              ? HorizontalListElementWidget<HomeModel>(
                  horizontalListElementType: HorizontalListElementType.trendingPerson,
                  model: model,
                )
              : const HorizontalListShimmerSkeletonWidget(horizontalListElementType: HorizontalListElementType.trendingPerson,),
          _ => const SizedBox.shrink(),
        }
      ],
    );
  }
}