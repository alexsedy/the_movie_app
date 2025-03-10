import 'package:flutter/material.dart';
import 'package:the_movie_app/models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedMediaCrewWidget extends StatelessWidget {
  final ParameterizedWidgetModel paramsModel;
  final Function secondAction;
  const ParameterizedMediaCrewWidget({super.key, required this.paramsModel,
    required this.secondAction});

  @override
  Widget build(BuildContext context) {
    const styleOfName = TextStyle(fontSize: 16,);
    const styleOfRole = TextStyle(fontSize: 16, fontStyle: FontStyle.italic);

    if (paramsModel.list.isEmpty) {
      return const SizedBox.shrink();
    } else if (paramsModel.list.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => secondAction(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  paramsModel.additionalText,
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
                        Text(paramsModel.list[0].firstLine ?? "", style: styleOfName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                        Text(paramsModel.list[0].secondLine ?? "", style: styleOfRole,
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
            onTap: () => secondAction(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                paramsModel.additionalText,
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
            itemCount: paramsModel.list.length ~/ 2,
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
                          Text(paramsModel.list[index * 2].firstLine ?? "",
                            style: styleOfName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(paramsModel.list[index * 2].secondLine ?? "",
                            style: styleOfRole,
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
                          Text(paramsModel.list[index * 2 + 1].firstLine ?? "",
                            style: styleOfName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(paramsModel.list[index * 2 + 1].secondLine ?? "",
                            style: styleOfRole,
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