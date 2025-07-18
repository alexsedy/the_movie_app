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
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (_, __, ___) => _FullScreenImage(
                        initIndex: index,
                        images: images,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(
                          opacity: animation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                child: Hero(
                  tag: "fullscreen_image_${images[index]}_$index",
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

class _FullScreenImage extends StatefulWidget {
  final int initIndex;
  final List<String> images;

  const _FullScreenImage({super.key,
    required this.initIndex,
    required this.images,
  });

  @override
  State<_FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<_FullScreenImage> {
  Offset _dragOffset = Offset.zero;
  String _imageCountText = "";

  @override
  void initState() {
    super.initState();
    _imageCountText = "${widget.initIndex + 1} / ${widget.images.length}";
  }

  @override
  Widget build(BuildContext context) {
    double totalOffset = _dragOffset.distance;
    double opacity = (1 - (totalOffset / 150).clamp(0, 1));
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor.withValues(alpha: opacity);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            child: Text(
              _imageCountText,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            top: 90.0,
          ),
          PageView.builder(
            onPageChanged: (int value) {
              setState(() {
                _imageCountText = "${value + 1} / ${widget.images.length}";
              });
            },
            itemCount: widget.images.length,
            controller: PageController(initialPage: widget.initIndex),
            itemBuilder: (context, index) {
              return GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    _dragOffset += details.delta;
                  });
                },
                onPanEnd: (details) {
                  if (totalOffset > 150) {
                    Navigator.pop(context);
                  } else {
                    setState(() {
                      _dragOffset = Offset.zero;
                    });
                  }
                },
                child: Transform.translate(
                  offset: _dragOffset,
                  child: Center(
                    child: Hero(
                      tag: "fullscreen_image_${widget.images[index]}_$index",
                      child: Image.network(
                        ApiClient.getImageByUrl(widget.images[index]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
