import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/home_screen/home_search_screen/home_search_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/vertical_list_element_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class HomeSearchWidget extends StatefulWidget {
  const HomeSearchWidget({super.key});

  @override
  State<HomeSearchWidget> createState() => _HomeSearchWidgetState();
}

class _HomeSearchWidgetState extends State<HomeSearchWidget> {

  @override
  void initState() {
    NotifierProvider.read<HomeSearchModel>(context)?.firstLoadMovies();
    NotifierProvider.read<HomeSearchModel>(context)?.firstLoadTvShows();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.9,
          flexibleSpace: const _HeaderSearchBar(),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Movies"),
              Tab(text: "TV Shows"),
              Tab(text: "Persons"),
              Tab(text: "Collections"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _MovieListWidget(),
            _TvShowListWidget(),
            _PersonListWidget(),
            _MediaCollectionListWidget(),
          ],
        ),
      ),
    );
  }
}

class _HeaderSearchBar extends StatelessWidget {
  const _HeaderSearchBar({super.key});

  @override
  Widget build(BuildContext context) {

    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    }

    final searchController = model.searchController;

    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 10, top: 56),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  hintText: 'Find anything',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 2),
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}


class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.movies.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3)),
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

    return VerticalListElementWidget<HomeSearchModel>(
      verticalListElementType: VerticalListElementType.movie,
      model: model,
    );
  }
}

class _TvShowListWidget extends StatelessWidget {
  const _TvShowListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.movies.isEmpty) {
      return FutureBuilder<void>(
        future: Future.delayed(const Duration(seconds: 3)),
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

    return VerticalListElementWidget<HomeSearchModel>(
      verticalListElementType: VerticalListElementType.tv,
      model: model,
    );
  }
}

class _PersonListWidget extends StatelessWidget {
  const _PersonListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _MediaCollectionListWidget extends StatelessWidget {
  const _MediaCollectionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final belongsToCollection = model.mediaDetails?.belongsToCollection;
    // final posterPath = belongsToCollection?.posterPath;
    // final backdropPath = belongsToCollection?.backdropPath;
    // final name = belongsToCollection?.name;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 150,
        // child: Stack(
        //   children: [
        //     backdropPath != null
        //         ? Opacity(
        //       opacity: 0.3,
        //       child: Container(
        //         clipBehavior: Clip.hardEdge,
        //         decoration: BoxDecoration(
        //           border: Border.all(color: Colors.transparent),
        //           borderRadius: const BorderRadius.all(Radius.circular(10)),
        //         ),
        //         child: Image.network(
        //           fit: BoxFit.fill,
        //           width: double.infinity,
        //           loadingBuilder: (context, child, loadingProgress) {
        //             if (loadingProgress == null) return child;
        //             return const Center(
        //               child: SizedBox(
        //                 width: 60,
        //                 height: 60,
        //                 child: CircularProgressIndicator(),
        //               ),
        //             );
        //           },
        //           ApiClient.getImageByUrl(backdropPath),),
        //       ),
        //     )
        //         : Container(
        //       decoration: BoxDecoration(
        //         color: Theme.of(context).primaryColor.withOpacity(0.1),
        //         border: Border.all(color: Colors.transparent),
        //         borderRadius: const BorderRadius.all(Radius.circular(10)),
        //       ),
        //     ),
        //     ListTile(
        //       onTap: (){
        //         model.onCollectionScreen(context);
        //       },
        //       minVerticalPadding: 0,
        //       contentPadding: EdgeInsets.zero,
        //       title: Center(
        //         child: Text(
        //           name?? "",
        //           style: const TextStyle(
        //             fontSize: 20,
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}