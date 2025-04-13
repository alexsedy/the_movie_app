import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
        itemExtent: 180,
        itemBuilder: (BuildContext context, int index) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
