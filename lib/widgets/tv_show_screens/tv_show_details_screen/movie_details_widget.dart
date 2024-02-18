import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_model.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_shimmer_skeleton_widget.dart';

import 'movie_details_main_info_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({super.key});

  @override
  State<MovieDetailsWidget> createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {

  @override
  void initState() {
    NotifierProvider.read<MovieDetailsModel>(context)?.loadMovieDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            pinned: true,
            onStretchTrigger: () async {
              NotifierProvider.read<MovieDetailsModel>(context)?.loadMovieDetails();
            },
            stretchTriggerOffset: 200.0,
            expandedHeight: 183.0,
            flexibleSpace: const _HeaderWidget(),
          ),
          const _BodyWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movieDetails = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;

    if(movieDetails == null) {
      return const ShimmerHeaderSkeletonWidget();
    }

    return const FlexibleSpaceBar(
      title: _MovieNameWidget(),
      background: _TopPosterWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final movieDetails = NotifierProvider.watch<MovieDetailsModel>(context)?.movieDetails;

    if(movieDetails == null) {
      return const ShimmerBodySkeletonWidget();
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const MovieDetailsMainInfoWidget(),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final backdropPath = model?.movieDetails?.backdropPath;
    // final posterPath = model?.movieDetails?.posterPath;

    return Stack(
      children: [
        backdropPath != null
            ? Image.network(ApiClient.getImageByUrl(backdropPath))
            : Image.asset(AppImages.noBackdropPoster),
        // Positioned(
        //   top: 20,
        //   left: 15,
        //   bottom: 20,
        //   child: SizedBox(
        //     height: 140, width: 90,
        //     child: posterPath != null
        //         ? Image.network(ApiClient.imageUrl(posterPath))
        //         : Image.asset("images/no_backdrop_poster.jpg"),
        //   ),
        // ),
      ],
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final releaseDate = model?.movieDetails?.releaseDate;
    final releaseText = releaseDate != null && releaseDate.isNotEmpty
        ? " (${releaseDate.substring(0, 4)})" : "";

    return RichText(
      maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: model?.movieDetails?.title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 21,
            ),
          ),
          TextSpan(
            text: releaseText,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              )
          ),
        ]
      ),
    );
  }
}