import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedHorizontalListWidget extends StatelessWidget {
  final ParameterizedWidgetModel paramModel;

  const ParameterizedHorizontalListWidget({super.key, required this.paramModel});

  @override
  Widget build(BuildContext context) {
    final statuses = paramModel.statuses;

    return SizedBox(
      height: paramModel.boxHeight,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: paramModel.list.length,
          itemExtent: AppSpacing.p130,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemBuilder: (BuildContext context, int index) {

            final posterPath = paramModel.list[index].imagePath;
            final firstLine = paramModel.list[index].firstLine;
            final secondLine = paramModel.list[index].secondLine;
            final thirdLine = paramModel.list[index].thirdLine;

            var firstMaxLine = 3;
            var thirdMaxLine = 2;

            if(firstLine != null && firstLine.length > 20) {
              thirdMaxLine = 1;
            }

            if(secondLine != null && thirdLine != null) {
              firstMaxLine = 1;
              thirdMaxLine = 1;
            }

            return Padding(
              padding: AppSpacing.screenPaddingAll10,
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
                                padding: AppSpacing.screenPaddingAll6,
                                child: Text(
                                  firstLine,
                                  maxLines: firstMaxLine,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                              ),
                              if(secondLine != null && secondLine.isNotEmpty)
                                Padding(
                                  padding: AppSpacing.screenPaddingAll6,
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
                                  padding: AppSpacing.screenPaddingAll6,
                                  child: Text(
                                    thirdLine,
                                    maxLines: thirdMaxLine,
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
                  ),
                  //TODO: fix this issue with statuses
                  // if(statuses != null && statuses[index].id == paramModel.list[index].id)
                  if(statuses != null &&
                      index < statuses.length &&
                      index < paramModel.list.length &&
                      statuses[index].id == paramModel.list[index].id)
                  Container(
                    height: 24,
                    child: Center(
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          color: statuses[index].status == 1
                              ? Colors.green.withValues(alpha: 0.9)
                              : statuses[index].status == 2
                                ? Colors.blue.withValues(alpha: 0.9)
                                : Colors.black.withValues(alpha: 0.9),
                        ),
                        child: Padding(
                          padding: AppSpacing.screenPaddingH10,
                          child: Text(
                            textAlign: TextAlign.center,
                            context.l10n.mediaStatus("status_${statuses[index].status}"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}