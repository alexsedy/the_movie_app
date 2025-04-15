import 'package:flutter/material.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedVerticalListWidget extends StatelessWidget {
  final ParameterizedWidgetModel paramModel;
  const ParameterizedVerticalListWidget({super.key, required this.paramModel});

  @override
  Widget build(BuildContext context) {
    final statuses = paramModel.statuses;

    return ListView.builder(
        itemCount: paramModel.list.length,
        itemExtent: 163,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (BuildContext context, int index) {
          String? posterPath = paramModel.list[index].imagePath;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                  child: Row(
                    children: [
                      AspectRatio(
                        aspectRatio: 500 / 750,
                        child: posterPath != null
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
                          ApiClient.getImageByUrl(posterPath), width: 95, fit: BoxFit.fitHeight,)
                            : Image.asset(paramModel.altImagePath, width: 95, fit: BoxFit.fill,),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 10, bottom: 1),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 15,),
                              if(paramModel.list[index].firstLine != null)
                                Text(
                                  paramModel.list[index].firstLine ?? "",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if(paramModel.list[index].secondLine != null)
                              const SizedBox(height: 5,),
                              if(paramModel.list[index].secondLine != null)
                              Text(
                                paramModel.list[index].secondLine ?? "",
                                style: const TextStyle(
                                    color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if(paramModel.list[index].thirdLine != null)
                                // const SizedBox(height: 15,),
                                const SizedBox(height: 10,),
                              if(paramModel.list[index].thirdLine != null)
                                Expanded(
                                  child: Text(
                                    paramModel.list[index].thirdLine ?? "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                            ],
                          ),
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
                if(statuses != null)
                  Positioned(
                    right: 3,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        if(paramModel.additionAction != null) {
                          paramModel.additionAction!(context, index, statuses[index].number);
                        }
                      },
                      icon: Icon(statuses[index].status == 1
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined
                      ),
                      color: statuses[index].status == 1
                          ? Colors.green
                          : Colors.red
                    ),
                  ),
              ],
            ),
          );
        }
    );
  }
}