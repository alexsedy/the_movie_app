import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:the_movie_app/models/models/parameterized_widget_display_model.dart';

class ParameterizedWidgetModel{
  final List<ParameterizedWidgetDisplayModel> list;
  final Function (BuildContext context, int index) action;
  final double boxHeight;
  final double aspectRatio;
  final double paddingEdgeInsets;
  final String altImagePath;
  final ScrollController? scrollController;
  final Function (int index)? preLoad;
  final String additionalText;
  final PagingController<int, ParameterizedWidgetDisplayModel>? pagingController;


  ParameterizedWidgetModel({this.boxHeight = 280,
    this.aspectRatio = 500 / 750, this.paddingEdgeInsets = 0.0,
    this.altImagePath = "", required this.list, required this.action,
    this.scrollController, this.preLoad, this.additionalText = "NULL",
    this.pagingController,
  });
}