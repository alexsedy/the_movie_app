import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';

class HorizontalListShimmerSkeletonWidget extends StatelessWidget {
  final HorizontalListElementType horizontalListElementType;
  const HorizontalListShimmerSkeletonWidget({super.key, required this.horizontalListElementType});

  @override
  Widget build(BuildContext context) {
    double boxHeight = 0;

    switch(horizontalListElementType) {
      case HorizontalListElementType.movie:
        boxHeight = 280;
      case HorizontalListElementType.tv:
        boxHeight = 280;
      case HorizontalListElementType.trendingPerson:
        boxHeight = 280;
      case HorizontalListElementType.cast:
      case HorizontalListElementType.companies:
      case HorizontalListElementType.seasons:
      case HorizontalListElementType.networks:
      case HorizontalListElementType.guestStars:
        // TODO: Handle this case.
      case HorizontalListElementType.recommendations:
        // TODO: Handle this case.
    }

    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: SizedBox(
        height: boxHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemExtent: AppSpacing.p160,
          itemBuilder: (BuildContext context, _) {
            return Padding(
              padding: AppSpacing.screenPaddingAll10,
              child: Container(
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
              ),
            );
          }
        ),
      ),
    );
  }
}

class DefaultListsShimmerSkeletonWidget extends StatelessWidget {
  const DefaultListsShimmerSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: ListView.builder(
          itemCount: 6,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, _) {
            return Padding(
              padding: AppSpacing.screenPaddingH16V10,
              child: Container(
                height: 143,
                width: 391.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(1, 2),
                      )]
                ),
              ),
            );
          }
      ),
    );
  }
}

class AiListsShimmerSkeletonWidget extends StatelessWidget {
  const AiListsShimmerSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blueAccent.withOpacity(0.5),
      highlightColor: Colors.green.withOpacity(0.5),
      child: ListView.builder(
          itemCount: 6,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, _) {
            return Padding(
              padding: AppSpacing.screenPaddingH16V10,
              child: Container(
                height: 143,
                width: 391.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(1, 2),
                      )]
                ),
              ),
            );
          }
      ),
    );
  }
}

class UserListsShimmerSkeletonWidget extends StatelessWidget {
  const UserListsShimmerSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: ListView.builder(
          itemCount: 9,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, _) {
            return Padding(
              padding: AppSpacing.screenPaddingAll10,
              child: Container(
                height: 140,
                width: 411.5,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black.withOpacity(0.2)),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(1, 2),
                      )]
                ),
              ),
            );
          }
      ),
    );
  }
}