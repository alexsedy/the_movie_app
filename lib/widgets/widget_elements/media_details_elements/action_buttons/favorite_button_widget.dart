import 'package:flutter/material.dart';
import 'package:the_movie_app/models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class FavoriteButtonWidget<T extends IBaseMediaDetailsModel> extends StatelessWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  final T model;
  const FavoriteButtonWidget({
    super.key, required this.mediaDetailsElementType, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final favorite = model.isFavorite;
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => model.toggleFavorite(context),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            favorite
                ? const Icon(Icons.favorite, color: Colors.red,)
                : const Icon(Icons.favorite_border),
            const Text("Favorite"),
          ],
        ),
      ),
    );
  }
}