import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/models/interfaces/i_base_media_details_model.dart';

class FbWatchlistButtonWidget<T extends IBaseMediaDetailsModel> extends StatelessWidget {
  final T model;
  const FbWatchlistButtonWidget({
    super.key, required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isWatched = model.isWatched;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () => _showOptions(context),
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isWatched
                ? const Icon(Icons.bookmark, color: Colors.lightBlue,)
                : const Icon(Icons.bookmark_outline),
            Text(context.l10n.watch,),
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
                title: Text("Status undefined"),
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
                onTap: () {
                  if(value == currentStatus) {
                    return;
                  } else if (value == 1) {
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
                                onPressed: () {
                                  model.toggleWatchlist(context, value);
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
                    // showDialog(
                    //   context: context,
                    //   barrierDismissible: false,
                    //   builder: (context) {
                    //     return const Center(
                    //       child: CircularProgressIndicator(),
                    //     );
                    //   },
                    // );
                    model.toggleWatchlist(context, value);
                    // Navigator.pop(context);
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