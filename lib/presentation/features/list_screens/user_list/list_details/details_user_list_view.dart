import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/constants/images_const/app_images.dart';
import 'package:the_movie_app/core/constants/widget_size.dart';
import 'package:the_movie_app/core/helpers/date_format_helper.dart';
import 'package:the_movie_app/data/datasources/remote/api_client/api_client.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/list_details/viewmodel/details_user_list_viewmodel.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class DetailsUserListView extends StatelessWidget {
  const DetailsUserListView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DetailsUserListViewModel>();

    return Scaffold(
      appBar: AppBar(
        elevation: 6,
        title: const _ListNameWidget(),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.sort),
          ),
          if (model.selectedIndexes.isNotEmpty)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(context.l10n.deleteSelectedItems),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(context.l10n.cancel),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              await model.removeItems();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(context.l10n.yes),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
        ],
      ),
      persistentFooterButtons: const [
        _FooterInfoWidget(),
      ],
      body: const _ListBody(),
    );
  }
}

class _ListNameWidget extends StatelessWidget {
  const _ListNameWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DetailsUserListViewModel>();
    final userListDetails = model.userListDetails;

    if (userListDetails == null) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: Container(
        width: double.infinity,
        height: 30,
        color: Colors.white,
      ),
    );
  }

    final name = userListDetails.name;
    return Text(name);
  }
}

class _FooterInfoWidget extends StatelessWidget {
  const _FooterInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DetailsUserListViewModel>();
    final userListDetails = model.userListDetails;
    final username = userListDetails?.createdBy.username;
    final itemCount = userListDetails?.itemCount;

    if (userListDetails == null) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.white.withOpacity(0.5),
      child: Container(
        height: 22,
        color: Colors.white,
      ),
    );
  }

    final public = userListDetails.public;

    return SizedBox(
      height: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          public
              ? Icon(Icons.lock_open, color: Colors.greenAccent[700],)
              : Icon(Icons.lock_outline, color: Colors.redAccent[700],),
          username != null 
              ? Text(context.l10n.createdByUsername(username))
              : const Text(""),
          itemCount != null 
              ? Text(context.l10n.itemsCount(itemCount))
              : const Text(""),
        ],
      ),
    );
  }
}

class _ListBody extends StatefulWidget {
  const _ListBody({
    super.key,
  });

  @override
  State<_ListBody> createState() => _ListBodyState();
}

class _ListBodyState extends State<_ListBody> {
  late ScrollController _scrollController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final model = context.read<DetailsUserListViewModel>();
    final scrollController = model.scrollController;

    _scrollController = scrollController;
      _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      context.read<DetailsUserListViewModel>().loadContent().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DetailsUserListViewModel>();

    if (model.listOfUserListDetails.isEmpty) {
    return FutureBuilder<void>(
      future: Future.delayed(const Duration(seconds: 2)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const DefaultListsShimmerSkeletonWidget();
        } else {
          return Center(
            child: Text(
              context.l10n.theListIsEmpty,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          );
        }
      },
    );
  }

    return ListView.builder(
      itemCount: model.listOfUserListDetails.length,
      itemExtent: WidgetSize.size180,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemBuilder: (BuildContext context, int index) {
        final item = model.listOfUserListDetails[index];
        final posterPath = item.posterPath;
        final title = (item.title ?? item.name) ?? "";
        final date = DateFormatHelper.fullDate((item.releaseDate ?? item.firstAirDate) ?? "");

        final selectedIndexes = model.selectedIndexes;

        return Padding(
          padding: AppSpacing.screenPaddingH16V10,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    border: Border.all(
                        color: Colors.black.withOpacity(0.2)),
                    borderRadius: const BorderRadius.all(
                        Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(1, 2),
                      )
                    ]
                ),
                clipBehavior: Clip.hardEdge,
                child: Row(
                  children: [
                    AspectRatio(
                      aspectRatio: 500 / 750,
                      child: posterPath != null
                          ? Image.network(
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        ApiClient.getImageByUrl(posterPath), width: 95,)
                          : Image.asset(AppImages.noPoster, width: 95,),
                    ),
                    Expanded(
                      child: Padding(
                        padding: AppSpacing.screenPaddingL16R10B2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppSpacing.gapH16,
                            Text(
                              title,
                              style: Theme.of(context).textTheme.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppSpacing.gapH6,
                            Text(
                              date,
                              style: Theme.of(context).textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            AppSpacing.gapH16,
                            Expanded(
                              child: Text(
                                style: Theme.of(context).textTheme.bodyMedium,
                                item.overview,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: SizedBox(
                  height: 143,
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    onLongPress: () {
                      setState(() {
                        if (selectedIndexes.contains(index)) {
                          selectedIndexes.remove(index);
                          model.removeItemFromQueue(item);
                          model.selectedIndexes = selectedIndexes;
                        } else {
                          selectedIndexes.add(index);
                          model.addItemToQueue(item);
                          model.selectedIndexes = selectedIndexes;
                        }
                      });
                    },
                    onTap: () {
                      if(selectedIndexes.isNotEmpty) {
                        setState(() {
                          if (selectedIndexes.contains(index)) {
                            selectedIndexes.remove(index);
                            model.removeItemFromQueue(item);
                            model.selectedIndexes = selectedIndexes;
                          } else {
                            model.addItemToQueue(item);
                            selectedIndexes.add(index);
                          }
                        });
                      } else {
                        model.onMediaDetailsScreen(context, item);
                      }
                    },
                    selectedTileColor: Colors.red.withOpacity(0.2),
                    selected: selectedIndexes.contains(index),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
