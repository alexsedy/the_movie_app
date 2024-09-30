import 'package:flutter/material.dart';
import 'package:the_movie_app/domain/api_client/api_client.dart';
import 'package:the_movie_app/widgets/test/model_covector.dart';

class TestWidget extends StatelessWidget {
  final ModelConvector model;

  const TestWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: model.boxHeight,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: model.length,
          itemExtent: 125,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {

            String? posterPath = model.posterPath;

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
                          aspectRatio: model.aspectRatio,
                          child: posterPath != null
                              ? Padding(
                            padding: EdgeInsets.all(model.paddingEdgeInsets),
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
                              : Image.asset(model.altPosterPath,),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 4, right: 2, top: 5),
                                child: Text(
                                  model.firstLine,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              if(model.secondLine.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5, bottom: 5),
                                  child: Text(
                                    model.secondLine,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic
                                    ),
                                  ),
                                ),
                              if(model.thirdLine.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4, right: 2, top: 5, bottom: 5),
                                  child: Text(
                                    model.thirdLine,
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      onTap: () {
                        model.action;
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