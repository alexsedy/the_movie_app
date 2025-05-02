import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';

class OverviewWidget<T extends IBaseMediaDetailsModel> extends StatefulWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  final T model;
  const OverviewWidget({
    super.key, required this.model, required this.mediaDetailsElementType,
  });

  @override
  State<OverviewWidget> createState() => _OverviewWidgetState();
}

class _OverviewWidgetState extends State<OverviewWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {

    final mediaDetails = widget.model.mediaDetails;
    final tagline = mediaDetails?.tagline;
    final overview = mediaDetails?.overview;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppSpacing.screenPaddingH16V10,
          child: Text(
            context.l10n.overview,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        if(tagline != null && tagline != "") Padding(
          padding: AppSpacing.screenPaddingAll10,
          child: Text("\"$tagline\"",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: AppSpacing.screenPaddingAll10,
          child: InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                  firstChild: Text(
                    overview ?? "", // показываем только часть описания
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                  secondChild: Text(
                    overview ?? "", // показываем полное описание
                  ),
                ),
                overview != null && overview.length <= 190
                    ? AppSpacing.emptyGap
                    : Icon(
                  _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}