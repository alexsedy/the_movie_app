import 'package:flutter/material.dart';
import 'package:the_movie_app/models/media_details_model/base_media_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class MovieCrewWidget<T extends BaseMediaDetailsModel> extends StatelessWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  final T model;
  const MovieCrewWidget({super.key, required this.model, required this.mediaDetailsElementType});

  @override
  Widget build(BuildContext context) {
    String tabName = "";

    switch(mediaDetailsElementType) {
      case MediaDetailsElementType.movie:
        tabName = "Movie Crew";
      case MediaDetailsElementType.tv:
        tabName = "";
    }

    final crew = model.mediaDetails?.credits.crew;

    const styleOfName = TextStyle(fontSize: 16,);
    const styleOfRole = TextStyle(fontSize: 16, fontStyle: FontStyle.italic);

    if (crew == null) {
      return const SizedBox.shrink();
    } else if(crew.isEmpty) {
      return const SizedBox.shrink();
    } else if (crew.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => model.onCrewListScreen(context, crew),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  tabName,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 55,
            child: Padding (
              padding: const EdgeInsets.only(left: 56),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 130,
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(crew[0].name ?? "", style: styleOfName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                        Text(crew[0].job, style: styleOfRole,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => model.onCrewListScreen(context, crew),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                tabName,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 135,
          child: ListView.builder(
            itemCount: crew.length ~/ 2,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 56),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 130,
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(crew[index * 2].name ?? "", style: styleOfName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(crew[index * 2].job, style: styleOfRole,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                          Text(crew[index * 2 + 1].name ?? "", style: styleOfName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(crew[index * 2 + 1].job, style: styleOfRole,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}