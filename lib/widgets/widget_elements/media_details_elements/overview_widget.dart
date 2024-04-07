import 'package:flutter/material.dart';
import 'package:the_movie_app/models/media_details_model/base_media_details_model.dart';

class OverviewWidget<T extends BaseMediaDetailsModel> extends StatefulWidget {
  final T model;
  const OverviewWidget({
    super.key, required this.model,
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
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text("Overview", style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),),
        ),
        if(tagline != "") Padding(
          padding: const EdgeInsets.all(10),
          child: Text("\"$tagline\"",
            style: const TextStyle(fontSize: 21, fontStyle: FontStyle.italic),),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
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
                    ? const SizedBox.shrink()
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