import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/person_screen/people_details_screen/people_details_model.dart';

class ImageGallery extends StatelessWidget {
  const ImageGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final person = NotifierProvider.watch<PeopleDetailsModel>(context)?.personDetails;
    final profiles = person?.images?.profiles;

    if (profiles == null || profiles.isEmpty) {
      return const SizedBox.shrink();
    }

    final images = profiles.map((e) => e.filePath).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, bottom: 10),
          child: Text(
            "Image gallery",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
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
                    padding: const EdgeInsets.all(8.0),
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