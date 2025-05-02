import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';

class ParameterizedMediaCrewWidget extends StatelessWidget {
  final ParameterizedWidgetModel paramsModel;
  final Function secondAction;
  const ParameterizedMediaCrewWidget({super.key, required this.paramsModel,
    required this.secondAction});

  @override
  Widget build(BuildContext context) {
    if (paramsModel.list.isEmpty) {
      return AppSpacing.emptyGap;
    } else if (paramsModel.list.length == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.screenPaddingAll6,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => secondAction(),
              child: Padding(
                padding: AppSpacing.screenPaddingH10V4,
                child: Text(
                  paramsModel.additionalText,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 55,
            child: Padding (
              padding: AppSpacing.screenPaddingL56,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 130,
                    height: 50,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(paramsModel.list[0].firstLine ?? "",
                          style: Theme.of(context).textTheme.bodyLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,),
                        Text(paramsModel.list[0].secondLine ?? "",
                          style: Theme.of(context).textTheme.bodySmall,
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
          padding: AppSpacing.screenPaddingAll6,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => secondAction(),
            child: Padding(
              padding: AppSpacing.screenPaddingH10V4,
              child: Text(
                paramsModel.additionalText,
                style: Theme.of(context).textTheme.titleLarge,
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
                padding: AppSpacing.screenPaddingL56,
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
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(paramsModel.list[index * 2].secondLine ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
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
                            style: Theme.of(context).textTheme.bodyLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(paramsModel.list[index * 2 + 1].secondLine ?? "",
                            style: Theme.of(context).textTheme.bodyMedium,
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