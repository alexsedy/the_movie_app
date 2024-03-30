import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
              padding: const EdgeInsets.all(8),
              child: Container(
                height: 97,
                width: 407.5,
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
