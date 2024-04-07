import 'package:flutter/material.dart';
import 'package:the_movie_app/constants/images_const/app_images.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/media_list_model/test/test_base.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class HorizontalListElementWidget<T extends BaseList> extends StatelessWidget {
  final HorizontalListElementType horizontalListElementType;
  final T model;
  const HorizontalListElementWidget({
    super.key, required this.horizontalListElementType, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.persons.length,
          itemExtent: 125,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {

            switch(horizontalListElementType) {
              case HorizontalListElementType.homeMovie:
                // TODO: Handle this case.
              case HorizontalListElementType.homeTv:
                // TODO: Handle this case.
              case HorizontalListElementType.homePerson:
                // TODO: Handle this case.
              case HorizontalListElementType.detailsCast:
                // TODO: Handle this case.
              case HorizontalListElementType.detailsCompanies:
                // TODO: Handle this case.
              case HorizontalListElementType.detailsSeason:
                // TODO: Handle this case.
              case HorizontalListElementType.detailsNetwork:
                // TODO: Handle this case.
            }

            final person = model.persons[index];
            final profilePath = person.profilePath;
            final name = person.name;
            final department = person.knownForDepartment;

            return Padding(
              padding: const EdgeInsets.all(8),
              child: Stack(
                children: [
                  Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 500 / 750,
                          child: profilePath != null
                              ? Image.network(
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
                            ApiClient.getImageByUrl(profilePath),)
                              : Image.asset(AppImages.noPoster,),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                child: Text(
                                  name,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                child: Text(
                                  department,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontStyle: FontStyle.italic
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(
                          10)),
                      onTap: () => model.onPeopleScreen(context, index),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }
}