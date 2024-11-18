import 'package:flutter/material.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/models/interfaces/i_base_media_details_model.dart';

import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class WatchlistButtonWidget<T extends IBaseMediaDetailsModel> extends StatelessWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  final T model;
  const WatchlistButtonWidget({
    super.key, required this.mediaDetailsElementType, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final favorite = model.isWatched;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => model.toggleWatchlist(context),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            favorite
                ? const Icon(Icons.bookmark, color: Colors.lightBlue,)
                : const Icon(Icons.bookmark_outline),
            Text(context.l10n.watch,),
          ],
        ),
      ),
    );
  }
}