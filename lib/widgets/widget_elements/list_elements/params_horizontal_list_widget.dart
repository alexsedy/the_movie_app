import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedHorizontalListWidget extends StatelessWidget {
  final ParameterizedWidgetModel paramModel;

  const ParameterizedHorizontalListWidget({super.key, required this.paramModel});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: paramModel.boxHeight,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: paramModel.list.length,
          itemExtent: 125,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {

            var posterPath = paramModel.list[index].imagePath;
            var firstLine = paramModel.list[index].firstLine;
            var secondLine = paramModel.list[index].secondLine;
            var thirdLine = paramModel.list[index].thirdLine;

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
                          aspectRatio: paramModel.aspectRatio,
                          child: posterPath != null
                              ? Padding(
                            padding: EdgeInsets.all(paramModel.paddingEdgeInsets),
                            child: Image.network(
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(),
                                  ),);},
                              ApiClient.getImageByUrl(posterPath),),
                          )
                              : Image.asset(paramModel.altImagePath,),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              if(firstLine != null && firstLine.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                child: Text(
                                  firstLine,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              if(secondLine != null && secondLine.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5, bottom: 5),
                                  child: Text(
                                    secondLine,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                              if(thirdLine != null && thirdLine.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5, bottom: 5),
                                  child: Text(
                                    thirdLine,
                                    maxLines: 2,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        paramModel.action(context, index);
                      },
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