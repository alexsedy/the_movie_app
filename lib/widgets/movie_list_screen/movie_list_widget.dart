import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_list_screen/movie_list_model.dart';
import 'package:the_movie_app/widgets/theme/app_colors.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = NotifierProvider.read<MovieListModel>(context)?.scrollController ?? ScrollController();
    super.initState();
  }

  // void _onScroll() {
  //   if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
  //     final model = NotifierProvider.read<MovieListModel>(context);
  //     if (model != null && model.isLoadingInProgress) {
  //       model.loadMovies();
  //     }
  //   }
  // }
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController.addListener(_onScroll);
  // }
  //
  // @override
  // void dispose() {
  //   _scrollController.removeListener(_onScroll);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieListModel>(context);

    if(model == null) return const SizedBox.shrink();

    return Column(
      children:[
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: model.movies.length,
            itemExtent: 163,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (BuildContext context, int index) {
              if(!model.isLoadingInProgress) {
                model.preLoadMovies(index);
                final movie = model.movies[index];
                final posterPath = movie.posterPath;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 500 / 750,
                              child: posterPath != null
                                  ? Image.network(
                                ApiClient.imageUrl(posterPath), width: 95,)
                                  : Image.asset("images/no_poster.png"),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 15, right: 10, bottom: 1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 15,),
                                    Text(
                                      movie.title,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5,),
                                    Text(
                                      model.formatDate(movie.releaseDate),
                                      // movie.releaseDate,
                                      style: const TextStyle(color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 15,),
                                    Expanded(
                                      child: Text(
                                        movie.overview,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          splashColor: AppColors.mainBlue.withOpacity(0.1),
                          onTap: () => model.onMovieTab(context, index),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }
          ),
        ),
      ],
    );
  }
}