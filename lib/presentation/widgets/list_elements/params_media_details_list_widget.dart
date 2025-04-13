import 'package:flutter/material.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_horizontal_widget_model.dart';
import 'package:the_movie_app/presentation/widgets/list_elements/params_horizontal_list_widget.dart';

class ParameterizedMediaDetailsListWidget extends StatelessWidget {
  final ParameterizedWidgetModel paramsModel;
  final Function secondAction;
  const ParameterizedMediaDetailsListWidget({super.key, required this.paramsModel, required this.secondAction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {
              secondAction();
            },
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
        ParameterizedHorizontalListWidget(
          paramModel: paramsModel,
        ),
      ],
    );
  }
}