import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/widget_size.dart';

class ColorListShimmerSkeletonWidget extends StatelessWidget {
  const ColorListShimmerSkeletonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: ListView.builder(
        itemCount: 5,
        physics: const NeverScrollableScrollPhysics(),
        itemExtent: WidgetSize.size180,
        itemBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: AppSpacing.screenPaddingAll10,
            child: Card(
              color: Colors.white,
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                title: SizedBox(),
              ),
            ),
          );
        },
      ),
    );
  }
}
