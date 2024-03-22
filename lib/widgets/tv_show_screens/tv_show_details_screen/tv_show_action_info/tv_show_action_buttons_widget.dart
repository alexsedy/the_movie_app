import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/tv_show_screens/tv_show_details_screen/tv_show_details_model.dart';

class TvShowActionButtonsWidget extends StatelessWidget {
  const TvShowActionButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: (){},
            child: SizedBox(
              width: 60,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.list),
                  const Text("List"),
                ],
              ),
            ),
          ),
          _FavoriteButtonWidget(),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: (){},
            child: Container(
              width: 60,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark),
                  const Text("Watch"),
                ],
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: (){},
            child: SizedBox(
              width: 60,
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star),
                  const Text("Rate"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteButtonWidget extends StatelessWidget {
  const _FavoriteButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<TvShowDetailsModel>(context);
    final favorite = model?.isFavorite;

    if(favorite == null) {
      return const SizedBox(
        width: 60,
        height: 60,
        child: Opacity(
          opacity: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border),
              Text("Favorite"),
            ],
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => model?.toggleFavorite(context),
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