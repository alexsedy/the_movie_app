import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/presentation/features/movie_screens/movie_details_screen/viewmodel/movie_details_viewmodel.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/media_details_shimmer_skeleton_widget.dart';

import 'movie_details_main_info_widget.dart';

class MovieDetailsView extends StatelessWidget {
  const MovieDetailsView({super.key});

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
    final movieDetails =  context.select<MovieDetailsViewModel, MediaDetails?>(
            (model) => model.mediaDetails);

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
    final movieDetails =  context.select<MovieDetailsViewModel, MediaDetails?>(
            (model) => model.mediaDetails);

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
    final backdropPath =  context.select<MovieDetailsViewModel, String?>(
            (model) => model.mediaDetails?.backdropPath);

    return backdropPath != null
        ? Image.network(ApiClient.getImageByUrl(backdropPath), fit: BoxFit.fill,)
        : Image.asset(AppImages.noBackdropPoster, fit: BoxFit.fill,);
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsViewModel>();
    final releaseDate = model.mediaDetails?.releaseDate;
    final title = model.mediaDetails?.title;
    final originalTitle = model.mediaDetails?.originalTitle;
    final releaseText = releaseDate != null && releaseDate.isNotEmpty
        ? " (${releaseDate.substring(0, 4)})" : "";
    final locale = Localizations.localeOf(context);

    return RichText(
      maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 21,
            ),
          ),
          // TextSpan(
          //   text: releaseText,
          //     style: const TextStyle(
          //       fontWeight: FontWeight.w400,
          //       fontSize: 16,
          //     )
          // ),
          if(locale.languageCode != "en" && title != originalTitle)
          TextSpan(
            text: "\n$originalTitle",
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
            )
          ),
        ]
      ),
    );
  }
}
