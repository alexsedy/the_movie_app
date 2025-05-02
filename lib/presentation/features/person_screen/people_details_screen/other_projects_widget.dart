import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/data/models/person/credits_people/credits.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/person_screen/viewmodel/people_details_viewmodel.dart';

class OtherProjectsWidget extends StatelessWidget {
  const OtherProjectsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPaddingH10,
          child: Text(
            context.l10n.otherProjects,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        AppSpacing.gapH20,
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _MoviesButtonWidget(),
            _TvShowButtonWidget(),
          ],
        ),
        AppSpacing.gapH32,
      ],
    );
  }
}

class _MoviesButtonWidget extends StatelessWidget {
  const _MoviesButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<PeopleDetailsViewModel>();
    final movieCreditList = model.movieCreditList;
    final movieStatuses = model.movieStatuses;

    if (movieCreditList.isEmpty) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.45,
                minChildSize: 0.2,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        context.l10n.noOtherMovieProjects,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  );
                },
              );
            }
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: Padding(
          padding: AppSpacing.screenPaddingAll10,
          child: Center(
            child: Text(
              context.l10n.movies,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.45,
                minChildSize: 0.2,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GroupedListView<CreditList, String>(
                      controller: scrollController,
                      useStickyGroupSeparators: true,
                      elements: movieCreditList,
                      groupBy: (CreditList c) => c.department,
                      groupHeaderBuilder: (c) {
                        return Padding(
                          padding: AppSpacing.screenPaddingH16V10,
                          child: Text(
                            c.department,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      },
                      indexedItemBuilder: (context, _, index) {
                        final releaseDate = model.formatDateInString(movieCreditList[index].releaseDate);
                        final title = movieCreditList[index].title;
                        final department = movieCreditList[index].department;
                        final job = movieCreditList[index].job;
                        final character = movieCreditList[index].character;
                        final posterPath = movieCreditList[index].posterPath;

                        return SizedBox(
                          height: 150,
                          child: Padding(
                            padding: AppSpacing.screenPaddingAll10,
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              child: ListTile(
                                onTap: () => model.onMovieDetailsTab(context, index),
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    posterPath != null
                                        ? AspectRatio(
                                            aspectRatio: 500 / 750,
                                            child: Image.network(
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
                                        ApiClient.getImageByUrl(posterPath),
                                      ),
                                    )
                                        : Image.asset(AppImages.noPoster),
                                    Expanded(
                                      child: Padding(
                                        padding: AppSpacing.screenPaddingH10,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(releaseDate.isNotEmpty
                                                ? releaseDate : context.l10n.unknown,
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            AppSpacing.gapH10,
                                            Text(
                                              title ?? "",
                                              softWrap: true,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            Text(department != "Actor"
                                                ? job ?? ""
                                                : character ?? "",
                                              softWrap: true,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if(movieStatuses.any((e)
                                        => movieCreditList[index].id == e.movieId
                                            && e.status != 0))
                                      Positioned(
                                        top: 15,
                                        right: 15,
                                        child: Icon(
                                          Icons.bookmark,
                                          color: Colors.blueAccent.withAlpha(180),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: Padding(
          padding: AppSpacing.screenPaddingAll10,
          child: Center(
            child: Text(
              context.l10n.movies,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}

class _TvShowButtonWidget extends StatelessWidget {
  const _TvShowButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<PeopleDetailsViewModel>();
    final tvShowCreditList = model.tvShowCreditList;
    final tvShowStatuses = model.tvShowStatuses;

    if (tvShowCreditList.isEmpty) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.45,
                minChildSize: 0.2,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        context.l10n.noOtherTvShowProjects,
                        style: Theme.of(context).textTheme.displaySmall,                      ),
                    ),
                  );
                },
              );
            }
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: Padding(
          padding: AppSpacing.screenPaddingAll10,
          child: Center(
            child: Text(
              context.l10n.tvShows,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }

    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            isDismissible: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                initialChildSize: 0.45,
                minChildSize: 0.2,
                maxChildSize: 0.95,
                builder: (context, scrollController) {
                  return Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dialogBackgroundColor,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: GroupedListView<CreditList, String>(
                      sort: true,
                      controller: scrollController,
                      useStickyGroupSeparators: true,
                      elements: tvShowCreditList,
                      groupBy: (CreditList c) => c.department,
                      groupHeaderBuilder: (c) {
                        return Padding(
                          padding: AppSpacing.screenPaddingH16V10,
                          child: Text(
                            c.department,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        );
                      },
                      indexedItemBuilder: (context, _, index) {
                        final firstAirDate = model.formatDateInString(tvShowCreditList[index].firstAirDate);
                        final name = tvShowCreditList[index].name;
                        final department = tvShowCreditList[index].department;
                        final job = tvShowCreditList[index].job;
                        final character = tvShowCreditList[index].character;
                        final posterPath = tvShowCreditList[index].posterPath;

                        final episodeCount = tvShowCreditList[index].episodeCount;
                        String episodeCountText = "";
                        if(episodeCount != null) {
                          episodeCountText = context.l10n.countEpisode(episodeCount);
                        }
                        return SizedBox(
                          height: 150,
                          child: Padding(
                            padding: AppSpacing.screenPaddingAll10,
                            child: Card(
                              clipBehavior: Clip.hardEdge,
                              child: ListTile(
                                onTap: () => model.onTvShowDetailsTab(context, index),
                                minVerticalPadding: 0,
                                contentPadding: EdgeInsets.zero,
                                title: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    posterPath != null
                                        ? AspectRatio(
                                            aspectRatio: 500 / 750,
                                            child: Image.network(
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
                                        ApiClient.getImageByUrl(posterPath),
                                      ),
                                    )
                                        : Image.asset(AppImages.noPoster),
                                    Expanded(
                                      child: Padding(
                                        padding: AppSpacing.screenPaddingH10,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(firstAirDate.isNotEmpty
                                                ? firstAirDate : context.l10n.unknown,
                                              style: Theme.of(context).textTheme.titleMedium,                                            ),
                                            AppSpacing.gapH10,
                                            Text(
                                              name ?? "",
                                              softWrap: true,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            Text(department != "Actor"
                                                ? "${job ?? ""} $episodeCountText"
                                                : "${character ?? ""} $episodeCountText",
                                              softWrap: true,
                                              maxLines: 2,
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if(tvShowStatuses.any((e)
                                        => tvShowCreditList[index].id == e.tvShowId
                                            && e.status != 0))
                                      Positioned(
                                        top: 15,
                                        right: 15,
                                        child: Icon(
                                          Icons.bookmark,
                                          color: Colors.blueAccent.withAlpha(180),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(),
        ),
        child: Padding(
          padding: AppSpacing.screenPaddingAll10,
          child: Center(
            child: Text(
              context.l10n.tvShows,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        ),
      ),
    );
  }
}