import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/media/media_details/media_details.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_details_screen/tv_show_details_main_info_widget.dart';
import 'package:the_movie_app/presentation/features/tv_show_screens/tv_show_details_screen/viewmodel/tv_show_details_viewmodel.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/media_details_shimmer_skeleton_widget.dart';

class TvShowDetailsView extends StatelessWidget {
  const TvShowDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            pinned: true,
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
  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    final tvShowDetails =  context.select<TvShowDetailsViewModel, MediaDetails?>(
            (model) => model.mediaDetails);

    if(tvShowDetails == null) {
      return const MediaDetailsHeaderShimmerSkeletonWidget();
    }

    return const FlexibleSpaceBar(
      title: _MovieNameWidget(),
      background: _TopPosterWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final tvShowDetails =  context.select<TvShowDetailsViewModel, MediaDetails?>(
            (model) => model.mediaDetails);

    if(tvShowDetails == null) {
      return const MediaDetailsBodyShimmerSkeletonWidget(
        mediaDetailsElementType: MediaDetailsElementType.tv,
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const TvShowDetailsMainInfoWidget(),
          AppSpacing.gapH20,
        ],
      ),
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget();

  @override
  Widget build(BuildContext context) {
    final backdropPath =  context.select<TvShowDetailsViewModel, String?>(
            (model) => model.mediaDetails?.backdropPath);

    return backdropPath != null
        ? Image.network(ApiClient.getImageByUrl(backdropPath), fit: BoxFit.fill,)
        : Image.asset(AppImages.noBackdropPoster, fit: BoxFit.fill,);
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget();

  @override
  Widget build(BuildContext context) {
    final model = context.read<TvShowDetailsViewModel>();
    final firstAirDate = model.mediaDetails?.firstAirDate;
    final name = model.mediaDetails?.name;
    final originalName = model.mediaDetails?.originalName;
    final releaseText = firstAirDate != null && firstAirDate.isNotEmpty
        ? " (${firstAirDate.substring(0, 4)})" : "";
    final locale = Localizations.localeOf(context);

    return RichText(
      maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          if(locale.languageCode != "en" && name != originalName)
            TextSpan(
              text: "\n$originalName",
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ]
      ),
    );
  }
}