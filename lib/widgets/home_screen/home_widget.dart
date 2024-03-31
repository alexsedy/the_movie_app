import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/home_screen/home_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

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
        child: Column(
          children: [
            _SearchWidget(),
            SizedBox(height: 20,),
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.movie),
            SizedBox(height: 20,),
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.tv,),
            SizedBox(height: 20,),
            _TrendingToggleWidget(horizontalListElementType: HorizontalListElementType.person,),
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
    const textStyle = TextStyle(
      fontSize: 36,
    );

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
                      child: const TextField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                          hintText: 'Search movie, TV, person',
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
                      onPressed: () {},
                      icon: const Icon(Icons.search),
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
    NotifierProvider.read<HomeModel>(context)?.loadMovies(true);
    NotifierProvider.read<HomeModel>(context)?.loadTv(true);
    NotifierProvider.read<HomeModel>(context)?.loadPerson(true);
  }

  String _getName() {
    switch(widget.horizontalListElementType){
      case HorizontalListElementType.movie:
        return "Trending movies";
      case HorizontalListElementType.tv:
        return "Trending TVs";
      case HorizontalListElementType.person:
        return "Trending persons";
    }
  }



  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeModel>(context);

    if(model == null) return const SizedBox.shrink();

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
                            NotifierProvider.read<HomeModel>(context)?.loadMovies(_isSelected.first);
                          case HorizontalListElementType.tv:
                            NotifierProvider.read<HomeModel>(context)?.loadTv(_isSelected.first);
                          case HorizontalListElementType.person:
                            NotifierProvider.read<HomeModel>(context)?.loadPerson(_isSelected.first);
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
          HorizontalListElementType.movie =>  const _TrendingMovieWidget(),
          HorizontalListElementType.tv => const _TrendingTvWidget(),
          HorizontalListElementType.person => const _TrendingPersonWidget(),
        }
      ],
    );
  }
}



class _TrendingMovieWidget extends StatelessWidget {
  const _TrendingMovieWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    } else if(model.movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemExtent: 125,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {
            // model.preLoadMovies(index);
            final movie = model.movies[index];
            final posterPath = movie.posterPath;
            final title = movie.title;
            final date = model.formatDate(movie.releaseDate);

            if (true) {
              // if (!model.isLoadingInProgress) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black.withOpacity(0.2)),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(1, 2),
                            )
                          ]
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 500 / 750,
                            child: posterPath != null
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
                              ApiClient.getImageByUrl(posterPath),)
                                : Image.asset(AppImages.noPoster,),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                  child: Text(
                                    title ?? "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                  child: Text(
                                    date,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(
                            10)),
                        onTap: () => model.onMovieTab(context, index),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }
}

class _TrendingTvWidget extends StatelessWidget {
  const _TrendingTvWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    } else if(model.tvs.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemExtent: 125,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {
            // model.preLoadMovies(index);
            final tv = model.tvs[index];
            final posterPath = tv.posterPath;
            final title = tv.name;
            final date = model.formatDate(tv.firstAirDate);

            if (true) {
              // if (!model.isLoadingInProgress) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black.withOpacity(0.2)),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(1, 2),
                            )
                          ]
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 500 / 750,
                            child: posterPath != null
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
                              ApiClient.getImageByUrl(posterPath),)
                                : Image.asset(AppImages.noPoster,),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                  child: Text(
                                    title ?? "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                  child: Text(
                                    date,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(
                            10)),
                        onTap: () => model.onTvShowTab(context, index),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }
}

class _TrendingPersonWidget extends StatelessWidget {
  const _TrendingPersonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<HomeModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    } else if(model.persons.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 280,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 12,
          itemExtent: 125,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {
            // model.preLoadMovies(index);
            final person = model.persons[index];
            final profilePath = person.profilePath;
            final name = person.name;
            final department = person.knownForDepartment;

            if (true) {
              // if (!model.isLoadingInProgress) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black.withOpacity(0.2)),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(1, 2),
                            )
                          ]
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
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
                              ApiClient.getImageByUrl(profilePath),)
                                : Image.asset(AppImages.noPoster,),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                  child: Text(
                                    name,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                  child: Text(
                                    department,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: const BorderRadius.all(Radius.circular(
                            10)),
                        onTap: () => model.onPeopleTab(context, index),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }
}