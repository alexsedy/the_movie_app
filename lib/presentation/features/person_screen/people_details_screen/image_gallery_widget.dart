import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/person_screen/viewmodel/people_details_viewmodel.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final person = context.read<PeopleDetailsViewModel>().personDetails;
    final profiles = person?.images?.profiles;

    if (profiles == null || profiles.isEmpty) {
      return AppSpacing.emptyGap;
    }

    final images = profiles.map((e) => e.filePath).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPaddingH16V10,
          child: Text(
            context.l10n.imageGallery,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _FullScreenImage(
                        currentIndex: index,
                        images: images,
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: index.toString(),
                  child: Padding(
                    padding: AppSpacing.screenPaddingAll10,
                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
                      child: AspectRatio(
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
                          ApiClient.getImageByUrl(images[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _FullScreenImage extends StatelessWidget {
  final int currentIndex;
  final List<String> images;

  const _FullScreenImage({super.key,
    required this.currentIndex,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: images.length,
        controller: PageController(initialPage: currentIndex),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Hero(
                tag: index.toString(),
                child: Image.network(
                  ApiClient.getImageByUrl(images[index]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
