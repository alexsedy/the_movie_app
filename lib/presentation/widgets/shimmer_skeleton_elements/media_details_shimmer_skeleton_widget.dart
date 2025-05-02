import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';

class MediaDetailsHeaderShimmerSkeletonWidget extends StatelessWidget {
  const MediaDetailsHeaderShimmerSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: Container(
        color: Colors.greenAccent,
      ),
    );
  }
}

class MediaDetailsBodyShimmerSkeletonWidget extends StatelessWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  const MediaDetailsBodyShimmerSkeletonWidget({super.key, required this.mediaDetailsElementType});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Shimmer.fromColors(
            baseColor: Colors.grey.withOpacity(0.5),
            highlightColor: Colors.white.withOpacity(0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.screenPaddingH60V16,
                  child: Container(
                    color: Colors.white,
                    height: 40,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 62,
                      child: TextButton(
                          onPressed: (){},
                          child: Row(
                            children: [
                              const SizedBox(
                                  width: 45,
                                  height: 45,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                  )
                              ),
                              AppSpacing.gapW10,
                              Text(
                                context.l10n.userScore, 
                                style: const TextStyle(
                                    color: Colors.black,
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                    Container(width: 1, height: 15,color: Colors.grey,),
                    SizedBox(
                      height: 62,
                      child: TextButton(
                          onPressed: (){},
                          child: Row(
                            children: [
                              const Icon(Icons.play_arrow, color: Colors.black),
                              Text(
                                context.l10n.playTrailer, 
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH6,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.list),
                          Text(context.l10n.list),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite_outline),
                          Text(context.l10n.favorite),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.bookmark_outline),
                          Text(context.l10n.watch),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star_outline),
                          Text(context.l10n.rate),
                        ],
                      ),
                    ),
                  ],
                ),
                // AppSpacing.gapH6,
                Padding(
                  padding: AppSpacing.screenPaddingH16V10,
                  child: Text(
                    context.l10n.overview, 
                    style: const TextStyle(
                      fontSize: 21, 
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: AppSpacing.screenPaddingAll10,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 30,
                  ),
                ),
                Padding(
                  padding: AppSpacing.screenPaddingAll10,
                  child: Container(
                    color: Colors.white,
                    width: double.infinity,
                    height: 80,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppSpacing.screenPaddingAll6,
                      child: Padding(
                        padding: AppSpacing.screenPaddingH10V4,
                        child: Text(
                          mediaDetailsElementType == MediaDetailsElementType.movie
                           ? context.l10n.movieCrew : context.l10n.tvShowCrew,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                          height: 135,
                          child: Padding(
                            padding: AppSpacing.screenPaddingL56,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 130,
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: 120,
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: 120,
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 135,
                          child: Padding(
                            padding: AppSpacing.screenPaddingL56,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 130,
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: 120,
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 130,
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        color: Colors.white,
                                        width: 120,
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: AppSpacing.screenPaddingAll6,
                      child: Padding(
                        padding: AppSpacing.screenPaddingH10V4,
                        child: Text(
                          mediaDetailsElementType == MediaDetailsElementType.movie
                              ? context.l10n.movieCast : context.l10n.tvShowCast,
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
