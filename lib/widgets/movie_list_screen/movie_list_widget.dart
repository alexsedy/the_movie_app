import 'dart:core';
import 'package:flutter/material.dart';
import 'package:the_movie_app/widgets/images_const/app_images.dart';
import 'package:the_movie_app/widgets/main_screen/main_screen_widget.dart';
import 'package:the_movie_app/widgets/theme/app_colors.dart';

class Movie {
  final int id;
  final String imageName;
  final String title;
  final String time;
  final String description;

  Movie({required this.id, required this.imageName, required this.title, required this.time, required this.description});
}

class MovieListWidget extends StatefulWidget {
  MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final _movies = [
    Movie(id: 1, imageName: AppImages.poster, title: "Barbie", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 2, imageName: AppImages.poster, title: "Test", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 3, imageName: AppImages.poster, title: "Top", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 4, imageName: AppImages.poster, title: "New", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 5, imageName: AppImages.poster, title: "Ama", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 6, imageName: AppImages.poster, title: "Lama", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 7, imageName: AppImages.poster, title: "Barbie", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 8, imageName: AppImages.poster, title: "Barbie", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 9, imageName: AppImages.poster, title: "Barbie", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 10, imageName: AppImages.poster, title: "Barbie", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 11, imageName: AppImages.poster, title: "Barbie", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
    Movie(id: 12, imageName: AppImages.poster, title: "Barbie", time: "July 21, 2023", description: "Barbie and Ken are having the time of their lives in the colorful and seemingly perfect world of Barbie Land. However, when they get a chance to go to the real world, they soon discover the joys and perils of living among humans."),
  ];

  var _filteredMovies = <Movie>[];

  final _searchController = SearchFieldWidget.searchController;

  void _searchMovies(){
    if(_searchController.text.isNotEmpty) {
      _filteredMovies = _movies.where((Movie movie) {
        return movie.title.toLowerCase().contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      _filteredMovies = _movies;
    }
    setState(() {});
  }

  void _onMovieTap(int index) {
    final id = _movies[index].id;
    Navigator.of(context).pushNamed("/main_screen/movie_details", arguments: id);
  }

  @override
  void initState() {
    _filteredMovies = _movies;
    _searchController.addListener(_searchMovies);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _filteredMovies.length,
      itemExtent: 163,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (BuildContext context, int index) {
        final movie = _filteredMovies[index];
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
                    Image(image: AssetImage(movie.imageName)),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 10, bottom: 1),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15,),
                            Text(
                              movie.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 5,),
                            Text(
                            movie.time,
                            style: TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 15,),
                            Expanded(
                              child: Text(
                                movie.description,
                                overflow: TextOverflow.fade,
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
                  onTap: () => _onMovieTap(index),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
