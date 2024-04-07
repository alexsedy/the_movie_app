import 'dart:core';
import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_list_screen/movie_list_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/list_elements/vertical_list_element_widget.dart';


class MovieListWidget extends StatefulWidget {
  const MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieListModel>(context);

    if(model == null) return const SizedBox.shrink();

    return VerticalListElementWidget<MovieListModel>(
      verticalListElementType: VerticalListElementType.movie,
      model: model,
    );

    // return ListView.builder(
    //     controller: _scrollController,
    //     itemCount: model.movies.length,
    //     itemExtent: 163,
    //     keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
    //     itemBuilder: (BuildContext context, int index) {
    //       model.preLoadMovies(index);
    //       final movie = model.movies[index];
    //       final posterPath = movie.posterPath;
    //
    //       if (!model.isMovieLoadingInProgress) {
    //         return Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    //           child: Stack(
    //             children: [
    //               Container(
    //                 decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     border: Border.all(color: Colors.black.withOpacity(0.2)),
    //                     borderRadius: const BorderRadius.all(Radius.circular(10)),
    //                     boxShadow: [
    //                       BoxShadow(
    //                         color: Colors.black.withOpacity(0.1),
    //                         blurRadius: 8,
    //                         offset: const Offset(1, 2),
    //                       )
    //                     ]
    //                 ),
    //                 clipBehavior: Clip.hardEdge,
    //                 child: Row(
    //                   children: [
    //                     AspectRatio(
    //                       aspectRatio: 500 / 750,
    //                       child: posterPath != null
    //                           ? Image.network(
    //                         loadingBuilder: (context, child, loadingProgress) {
    //                           if (loadingProgress == null) return child;
    //                           return const Center(
    //                             child: SizedBox(
    //                               width: 60,
    //                               height: 60,
    //                               child: CircularProgressIndicator(),
    //                             ),
    //                           );
    //                         },
    //                         ApiClient.getImageByUrl(posterPath), width: 95,)
    //                           : Image.asset(AppImages.noPoster, width: 95,),
    //                     ),
    //                     Expanded(
    //                       child: Padding(
    //                         padding: const EdgeInsets.only(
    //                             left: 15, right: 10, bottom: 1),
    //                         child: Column(
    //                           crossAxisAlignment: CrossAxisAlignment.start,
    //                           children: [
    //                             const SizedBox(height: 15,),
    //                             Text(
    //                               movie.title ?? "",
    //                               style: const TextStyle(
    //                                   fontWeight: FontWeight.bold),
    //                               maxLines: 1,
    //                               overflow: TextOverflow.ellipsis,
    //                             ),
    //                             const SizedBox(height: 5,),
    //                             Text(
    //                               model.formatDate(movie.releaseDate),
    //                               // movie.releaseDate,
    //                               style: const TextStyle(
    //                                   color: Colors.grey),
    //                               maxLines: 1,
    //                               overflow: TextOverflow.ellipsis,
    //                             ),
    //                             const SizedBox(height: 15,),
    //                             Expanded(
    //                               child: Text(
    //                                 movie.overview,
    //                                 maxLines: 3,
    //                                 overflow: TextOverflow.ellipsis,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               Material(
    //                 color: Colors.transparent,
    //                 child: InkWell(
    //                   borderRadius: const BorderRadius.all(Radius.circular(
    //                       10)),
    //                   onTap: () => model.onMovieScreen(context, index),
    //                 ),
    //               )
    //             ],
    //           ),
    //         );
    //       } else {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //     }
    // );
  }
}