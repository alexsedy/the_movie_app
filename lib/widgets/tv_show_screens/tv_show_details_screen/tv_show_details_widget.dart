import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_main_info_widget.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_model.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_shimmer_skeleton_widget.dart';

class TvShowDetailsWidget extends StatefulWidget {
  const TvShowDetailsWidget({super.key});

  @override
  State<TvShowDetailsWidget> createState() => _TvShowDetailsWidgetState();
}

class _TvShowDetailsWidgetState extends State<TvShowDetailsWidget> {

  @override
  void initState() {
    NotifierProvider.read<TvShowDetailsModel>(context)?.loadTvShowDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            stretch: true,
            pinned: true,
            onStretchTrigger: () async {
              NotifierProvider.read<TvShowDetailsModel>(context)?.loadTvShowDetails();
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
    final tvShowDetails = NotifierProvider.watch<TvShowDetailsModel>(context)?.tvShowDetails;

    if(tvShowDetails == null) {
      return const TvShowShimmerHeaderSkeletonWidget();
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
    final tvShowDetails = NotifierProvider.watch<TvShowDetailsModel>(context)?.tvShowDetails;

    if(tvShowDetails == null) {
      return const TvShowShimmerBodySkeletonWidget();
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const TvShowDetailsMainInfoWidget(),
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
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);
    final backdropPath = model?.tvShowDetails?.backdropPath;
    // final posterPath = model?.movieDetails?.posterPath;

    return backdropPath != null
        ? Image.network(ApiClient.getImageByUrl(backdropPath), fit: BoxFit.fitWidth,)
        : Image.asset(AppImages.noBackdropPoster);
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);
    final firstAirDate = model?.tvShowDetails?.firstAirDate;
    final releaseText = firstAirDate != null && firstAirDate.isNotEmpty
        ? " (${firstAirDate.substring(0, 4)})" : "";

    return RichText(
      maxLines: 3,
      text: TextSpan(
        children: [
          TextSpan(
            text: model?.tvShowDetails?.name,
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