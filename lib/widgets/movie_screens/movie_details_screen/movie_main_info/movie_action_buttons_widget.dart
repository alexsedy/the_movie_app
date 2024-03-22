import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/movie_screens/movie_details_screen/movie_details_model.dart';

class MovieActionButtonsWidget extends StatelessWidget {
  const MovieActionButtonsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ListButtonWidget(),
          _FavoriteButtonWidget(),
          _WatchlistButtonWidget(),
          _RateButtonWidget(),
        ],
      ),
    );
  }
}

class _ListButtonWidget extends StatelessWidget {
  const _ListButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);

    if(model == null) {
      return const SizedBox(
        width: 60,
        height: 60,
        child: Opacity(
          opacity: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.list),
              Text("List"),
            ],
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          backgroundColor: Colors.transparent,
          builder: (BuildContext context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.2,
            maxChildSize: 0.95,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Theme.of(context).dialogBackgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        "Add to the list",
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
      },
      child: const SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list),
            Text("List"),
          ],
        ),
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
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
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

class _WatchlistButtonWidget extends StatelessWidget {
  const _WatchlistButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final favorite = model?.isWatched;

    if(favorite == null) {
      return const SizedBox(
        width: 60,
        height: 60,
        child: Opacity(
          opacity: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bookmark_outline),
              Text("Watch"),
            ],
          ),
        ),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => model?.toggleWatchlist(context),
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            favorite
                ? const Icon(Icons.bookmark, color: Colors.lightBlue,)
                : const Icon(Icons.bookmark_outline),
            const Text("Favorite"),
          ],
        ),
      ),
    );
  }
}

class _RateButtonWidget extends StatelessWidget {
  const _RateButtonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsModel>(context);
    final isRated = model?.isRated;

    if(model == null || isRated == null ) {
      return const SizedBox(
        width: 60,
        height: 60,
        child: Opacity(
          opacity: 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_outline),
              Text("Rate"),
            ],
          ),
        ),
      );
    }
    var rate = 0.0;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onLongPress: () => model.toggleDeleteRating(context),
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return _RateDialogWidget(model: model,);
          },
        );
      },
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isRated
                ? const Icon(Icons.star, color: Colors.amber,)
                : const Icon(Icons.star_outline),
            const Text("Rate"),
          ],
        ),
      ),
    );
  }
}

class _RateDialogWidget extends StatefulWidget {
  final MovieDetailsModel model;
  const _RateDialogWidget({super.key, required this.model});

  @override
  State<_RateDialogWidget> createState() => _RateDialogWidgetState();
}

class _RateDialogWidgetState extends State<_RateDialogWidget> {
  double rate = 0.0;

  @override
  void initState() {
    final currentRate = widget.model.rate;
    rate = currentRate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Rate movie"),
      children: [
        Center(
          child: Text(
            "Rate: ${rate.round()}",
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Slider(
          min: 0,
          max: 10,
          // label: "Rate: ${rate.round()}",
          divisions: 10,
          value: rate,
          onChanged: (value) {
            setState(() {
              rate = value;
              widget.model.rate = value;
            },);
          },
          // onChangeEnd: (value) =>  widget.model.toggleAddRating(context, value),
        ),
        TextButton(
          onPressed: () {
            widget.model.toggleAddRating(context, rate);
            Navigator.pop(context);
          },
          child: const Text("Ok"),),
      ],
    );
  }
}
