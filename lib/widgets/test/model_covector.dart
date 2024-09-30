class ModelConvector{
  final int length;
  final double boxHeight;
  final double aspectRatio;
  final String? posterPath;
  final String altPosterPath;
  final String firstLine;
  final String secondLine;
  final String thirdLine;
  final Function action;
  final double paddingEdgeInsets;

  ModelConvector({required this.length, required this.boxHeight,
    required this.aspectRatio, required this.posterPath,
    required this.altPosterPath, required this.firstLine,
    required this.secondLine, required this.thirdLine, required this.action,
    required this.paddingEdgeInsets
  });
}