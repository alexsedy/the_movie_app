import 'package:flutter/material.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class WatchlistButtonWidget<T extends IBaseMediaDetailsModel> extends StatelessWidget {
  final T model;
  final MediaDetailsElementType mediaDetailsElementType;
  const WatchlistButtonWidget({
    super.key, required this.model, required this.mediaDetailsElementType
  });

  @override
  Widget build(BuildContext context) {
    final isWatched = model.isWatched;
    final currentStatus = model.currentStatus;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => _showOptions(context),
      onLongPress: () => model.toggleWatchlist(context, -1),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isWatched
                ? const Icon(Icons.bookmark, color: Colors.lightBlue,)
                : const Icon(Icons.bookmark_outline),
            currentStatus == null
                ? Text(context.l10n.watch,)
                : Text(
                    context.l10n.mediaStatus("status_$currentStatus"),
                    textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final currentStatus = model.currentStatus;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return ListView(
          shrinkWrap: true,
          children: [
            if (currentStatus == null || currentStatus == 0)
              ListTile(
                title: Text("Status not selected"),
                textColor: Colors.red,
                trailing: Icon(Icons.done),
                selected: true,
              ),
            ...model.statuses.map((value) {
              if (value == 99) {
                return ListTile(
                  title: Center(child: Text("Cancel")),
                  onTap: () => Navigator.pop(context),
                  textColor: Colors.red,
                );
              }

              return ListTile(
                title: Text(
                  context.l10n.mediaStatus("status_$value"),
                ),
                onTap: () async {
                  if(value == currentStatus) {
                    return;
                  } else if (value == 1
                      && mediaDetailsElementType == MediaDetailsElementType.tv) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "This action will mark all episodes as \"Watched\".\n\nDo you want to do this?",
                            textAlign: TextAlign.center,
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(context.l10n.cancel)
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  showDialog (
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                  await model.toggleWatchlist(context, value);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text(context.l10n.yes),
                              ),
                            ],
                          ),
                        );
                      }
                    );
                  } else {
                    showDialog (
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    await model.toggleWatchlist(context, value);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                },
                trailing: currentStatus == value
                    ? Icon(Icons.done)
                    : null,
                selected: currentStatus == value,
              );
            }).toList(),
          ],
        );
      },
    );
  }
}