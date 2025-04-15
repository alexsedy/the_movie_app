import 'package:flutter/material.dart';
import 'package:the_movie_app/presentation/presentation_models/models/parameterized_widget_display_model.dart';
import 'package:the_movie_app/presentation/presentation_models/models/statuses_model.dart';

class ParameterizedWidgetModel{
  final List<ParameterizedWidgetDisplayModel> list;
  final List<StatusesModel>? statuses;
  final Function (BuildContext context, int index) action;
  final Function (BuildContext context, int index, [int? number])? additionAction;
  final double boxHeight;
  final double aspectRatio;
  final double paddingEdgeInsets;
  final String altImagePath;
  final ScrollController? scrollController;
  final String additionalText;


  ParameterizedWidgetModel({this.boxHeight = 280, this.statuses,
    this.aspectRatio = 500 / 750, this.paddingEdgeInsets = 0.0,
    this.altImagePath = "", required this.list, required this.action,
    this.scrollController, this.additionalText = "NULL",
    this.additionAction
  });
}