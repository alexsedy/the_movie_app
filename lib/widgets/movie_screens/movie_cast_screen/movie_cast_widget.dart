import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_cast_screen/movie_cast_model.dart';

class MovieCastWidget extends StatelessWidget {
  const MovieCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movie Cast"),
      ),
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieCastModel>(context);
    final cast = model?.cast;

    if(cast == null) {
      return const SizedBox.shrink();
    } else if (cast.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: cast.length,
      itemExtent: 180,
      itemBuilder: (BuildContext context, int index) {
        final profilePath = cast[index].profilePath;
        final character = cast[index].character;
        final name = cast[index].name;
        final popularity = cast[index].popularity;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: SizedBox(
            child: Card(
              clipBehavior: Clip.hardEdge,
              child: ListTile(
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero,
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    profilePath != null
                      ? Image.network(ApiClient.getImageByUrl(profilePath))
                      : Image.asset(AppImages.noProfile),
                    const SizedBox(width: 14,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6,),
                          Text(name,
                            softWrap: true,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(character,
                            softWrap: true,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 20,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 6,),
                          Text("Popularity $popularity",
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}