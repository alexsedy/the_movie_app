import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/media_details_shimmer_skeleton_widget.dart';

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
    return const Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            pinned: true,
            stretchTriggerOffset: 200.0,
            expandedHeight: 183.0,
            flexibleSpace: _HeaderWidget(),
          ),
          _BodyWidget(),
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
    final movieDetails = NotifierProvider.watch<MovieDetailsModel>(context)?.mediaDetails;

    if(movieDetails == null) {
      return const MediaDetailsHeaderShimmerSkeletonWidget();
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
    final movieDetails = NotifierProvider.watch<MovieDetailsModel>(context)?.mediaDetails;

    if(movieDetails == null) {
      return const MediaDetailsBodyShimmerSkeletonWidget(
        mediaDetailsElementType: MediaDetailsElementType.movie,
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const MovieDetailsMainInfoWidget(),
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
    final backdropPath = model?.mediaDetails?.backdropPath;

    return backdropPath != null
        ? Image.network(ApiClient.getImageByUrl(backdropPath), fit: BoxFit.fitWidth,)
        : Image.asset(AppImages.noBackdropPoster, fit: BoxFit.fitWidth,);
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final releaseDate = model?.mediaDetails?.releaseDate;
    final releaseText = releaseDate != null && releaseDate.isNotEmpty
        ? " (${releaseDate.substring(0, 4)})" : "";

    return RichText(
      maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: model?.mediaDetails?.title,
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