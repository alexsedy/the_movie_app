import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/home_screen/home_search_screen/home_search_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/vertical_list_with_pagination_element_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class HomeSearchWidget extends StatefulWidget {
  const HomeSearchWidget({super.key});

  @override
  State<HomeSearchWidget> createState() => _HomeSearchWidgetState();
}

class _HomeSearchWidgetState extends State<HomeSearchWidget> {

  @override
  void initState() {
    super.initState();
    NotifierProvider.read<HomeSearchModel>(context)?.firstLoadAll();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.9,
          flexibleSpace: const _HeaderSearchBar(),
          leading: BackButton(
            onPressed: () {
              final model = NotifierProvider.read<HomeSearchModel>(context);
              model?.searchController.clear();
              Navigator.of(context).pop();
            },
          ),
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

class _HeaderSearchBar extends StatefulWidget {
  const _HeaderSearchBar({super.key});

  @override
  State<_HeaderSearchBar> createState() => _HeaderSearchBarState();
}

class _HeaderSearchBarState extends State<_HeaderSearchBar> {
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    }

    final searchController = model.searchController;

    return Padding(
      padding: const EdgeInsets.only(left: 60, right: 16, top: 56),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: TextField(
          controller: searchController,
          focusNode: _searchFocusNode,
          onChanged: (value) {
            searchController.text = value;
            model.loadAll();
            if(value.isEmpty) {
              model.backOnHomePage(context);
            }
          },
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            // hintText: 'Find anything',
            border: InputBorder.none,
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

    return VerticalListWithPaginationElementWidget<HomeSearchModel>(
      verticalListWithPaginationElementType: VerticalListWithPaginationElementType.movie,
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

    return VerticalListWithPaginationElementWidget<HomeSearchModel>(
      verticalListWithPaginationElementType: VerticalListWithPaginationElementType.tv,
      model: model,
    );
  }
}

class _PersonListWidget extends StatelessWidget {
  const _PersonListWidget({super.key});

  @override
  Widget build(BuildContext context) {

    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.persons.isEmpty) {
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

    return ListView.builder(
        itemCount: model.persons.length,
        controller: model.scrollController,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          model.preLoadPersons(index);
          final persons = model.persons;
          final firstLine = persons[index].name;
          final secondLine = persons[index].knownForDepartment;
          final titles = <String>[];
          persons[index].knownFor.forEach((element) {
            final title = element.title;
            if (title != null) {
              titles.add(title);
            }
          });

          String? thirdLine;
          if(titles.isNotEmpty) {
            thirdLine = "Know for: ${titles.join(", ").toString()}";
          }
          final profilePath = persons[index].profilePath;

          if (!model.isPersonLoadingInProgress) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Card(
                clipBehavior: Clip.hardEdge,
                child: ListTile(
                  onTap: () {
                    model.onPeopleDetailsScreen(context, index);
                  },
                  minVerticalPadding: 0,
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 500 / 750,
                        child: profilePath != null
                            ? Image.network(
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
                          ApiClient.getImageByUrl(profilePath), fit: BoxFit.fitHeight,)
                            : Image.asset(AppImages.noProfile,),
                      ),
                      const SizedBox(width: 14,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6,),
                            Text(firstLine,
                              softWrap: true,
                              maxLines: 3,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if(secondLine != null)
                              Text(secondLine,
                                softWrap: true,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            const SizedBox(height: 6,),
                            if(thirdLine != null)
                              Text(thirdLine,
                                maxLines: 3,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w200,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}

class _MediaCollectionListWidget extends StatelessWidget {
  const _MediaCollectionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeSearchModel>(context);

    if(model == null) return const SizedBox.shrink();

    if(model.collections.isEmpty) {
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


    return ListView.builder(
      itemCount: model.collections.length,
      controller: model.scrollController,
      itemExtent: 163,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (BuildContext context, int index) {
        model.preLoadCollections(index);
        final collections = model.collections;
        final backdropPath = collections[index].backdropPath;
        final name = collections[index].name;

        if (!model.isCollectionLoadingInProgress) {
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
                      model.onCollectionScreen(context, index);
                    },
                    minVerticalPadding: 0,
                    contentPadding: EdgeInsets.zero,
                    title: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}