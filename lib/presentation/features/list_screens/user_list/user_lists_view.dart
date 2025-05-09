import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/helpers/date_format_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/features/list_screens/user_list/viewmodel/user_lists_viewmodel.dart';
import 'package:the_movie_app/presentation/widgets/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';
import 'package:the_movie_app/presentation/widgets/widget_elements/create_list_widget.dart';

class UserListsView extends StatelessWidget {
  const UserListsView({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserListsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.userLists),
        actions: [
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  elevation: 0.2,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                  ),
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                      reverse: true,
                      child: Container(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: CreateListWidget(model: model,)
                      ),
                    );
                  }
              );
            },
            child: Text(context.l10n.newList),
          ),
          AppSpacing.gapW16,
        ],
      ),
      body: const _UserListBody(),
    );
  }
}

class _UserListBody extends StatelessWidget {
  const _UserListBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserListsViewModel>();

    return FutureBuilder<void>(
        future: model.getAllUserLists(context),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const UserListsShimmerSkeletonWidget();
          } else {
            return ListView.builder(
              itemCount: model.lists.length,
              itemBuilder: (BuildContext context, int index) {
                final lists = model.lists[index];
                final name = lists.name;
                final description = lists.description;
                final numberOfItems = lists.numberOfItems;
                final public = lists.public == 1;
                final createdAt = DateFormatHelper.fullDate(lists.createdAt.substring(0, lists.createdAt.length - 4));

                return Padding(
                  padding: AppSpacing.screenPaddingAll10,
                  child: ListTile(
                    onTap: () => model.onUserListDetails(context, index),
                    minLeadingWidth: 10,
                    titleAlignment: ListTileTitleAlignment.center,
                    contentPadding: AppSpacing.screenPaddingAll10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    // tileColor: Colors.grey[200],
                    tileColor: Theme.of(context).colorScheme.inversePrimary,
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          child: Text(context.l10n.edit),
                          onTap: () {
                            model.listIndex = index;
                            showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                isScrollControlled: true,
                                elevation: 0.2,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                                ),
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    reverse: true,
                                    child: Container(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).viewInsets.bottom,
                                        ),
                                        child: _UpdateListWidget(model: model,),
                                    ),
                                  );
                                }
                            );
                          },
                        ),
                        PopupMenuItem<String>(
                          child: Text(context.l10n.clear),
                          onTap: () {},
                        ),
                        PopupMenuItem<String>(
                          child: Text(context.l10n.delete),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(context.l10n.deleteTheNameList(name)),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(context.l10n.cancel),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          model.removeList(
                                            context: context,
                                            index: index,
                                          );
                                        },
                                        child: Text(context.l10n.yes),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    leading: public
                        ? Icon(Icons.lock_open, color: Colors.greenAccent[700],)
                        : Icon(Icons.lock_outline, color: Colors.redAccent[700],),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text(
                          context.l10n.itemNumberOfItems(numberOfItems),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const Padding(
                          padding: AppSpacing.screenPaddingH10,
                          child: Text("|"),
                        ),
                        Text(
                          createdAt,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
    );
  }
}

class _UpdateListWidget extends StatefulWidget {
  final UserListsViewModel model;
  const _UpdateListWidget({
    super.key, required this.model,
  });

  @override
  State<_UpdateListWidget> createState() => _UpdateListWidgetState();
}

class _UpdateListWidgetState extends State<_UpdateListWidget> {
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  final _createButtonController = WidgetStatesController();
  bool _isPublic = false;

  @override
  void initState() {
    super.initState();
    final index = widget.model.listIndex;
    final name = widget.model.lists[index].name;
    final description = widget.model.lists[index].description;
    _isPublic = widget.model.lists[index].public == 1;
    _nameController.text = name;
    _descriptionController.text = description;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    widget.model.listIndex = -1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = widget.model.listIndex;
    final name = widget.model.lists[index].name;

    return Padding(
      padding: AppSpacing.screenPaddingH16V10,
      child: Column(
        children: [
          Text(
            context.l10n.updateTheNameList(name),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          AppSpacing.gapH32,
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: context.l10n.name,
              border: const OutlineInputBorder(),
              contentPadding: AppSpacing.screenPaddingH10V20,
              isCollapsed: true,
            ),
          ),
          AppSpacing.gapH32,
          TextField(
            controller: _descriptionController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              setState(() {});
            },
            decoration: InputDecoration(
              hintText: context.l10n.description,
              border: const OutlineInputBorder(),
              contentPadding: AppSpacing.screenPaddingH10V20,
              isCollapsed: true,
            ),
          ),
          AppSpacing.gapH20,
          Padding(
            padding: AppSpacing.screenPaddingH10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.public,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch(
                  value: _isPublic,
                  onChanged: (bool value) {
                    setState(() {
                      _isPublic = value;
                    });
                  },
                ),
              ],
            ),
          ),
          AppSpacing.gapH32,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.cancel),
              ),
              ElevatedButton(
                statesController: _createButtonController,
                onPressed: _nameController.text.isNotEmpty
                    ? () => widget.model.updateList(
                    context: context,
                    description: _descriptionController.text.trimRight(),
                    name: _nameController.text.trimRight(),
                    public: _isPublic,
                    index: widget.model.listIndex,
                )
                    : null,
                child: Text(context.l10n.update),
              ),
            ],
          ),
          AppSpacing.gapH20,
        ],
      ),
    );
  }
}