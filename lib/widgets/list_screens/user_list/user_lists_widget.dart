import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/list_screens/user_list/user_lists_model.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';
import 'package:the_movie_app/widgets/widget_elements/widget_elements/create_list_widget.dart';

class UserListsWidget extends StatefulWidget {
  const UserListsWidget({super.key});

  @override
  State<UserListsWidget> createState() => _UserListsWidgetState();
}

class _UserListsWidgetState extends State<UserListsWidget> {
  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<UserListsModel>(context);

    if(model == null) {
      return SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("User lists"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
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
              child: const Text("New list"),
            ),
          ),
        ],
      ),
      body: const _UserListBody(),
      // body: MyListView(),
    );
  }
}

class _UserListBody extends StatelessWidget {
  const _UserListBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<UserListsModel>(context);

    if(model == null) {
      return const SizedBox.shrink();
    }

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
                final numberOfItems = lists.numberOfItems;
                final public = lists.public == 1;
                final createdAt = model.formatDate(lists.createdAt.substring(0, lists.createdAt.length - 4));

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () => model.onUserListDetails(context, index),
                    minLeadingWidth: 10,
                    titleAlignment: ListTileTitleAlignment.center,
                    contentPadding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    tileColor: Colors.grey[200],
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          child: Text('Edit'),
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
                          child: Text('Clear'),
                          onTap: () {},
                        ),
                        PopupMenuItem<String>(
                          child: Text('Delete'),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Delete the \"$name\" list?"),
                                  content: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("Cancel"),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          model.removeList(
                                            context: context,
                                            index: index,
                                          );
                                        },
                                        child: const Text("Yes"),
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
                    title: Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        // public
                        //     ? Icon(Icons.lock_open, color: Colors.greenAccent[700],)
                        //     : Icon(Icons.lock_outline, color: Colors.redAccent[700],),
                        // const Padding(
                        //   padding: EdgeInsets.symmetric(horizontal: 10),
                        //   child: Text("|"),
                        // ),
                        Text(
                          "Item: $numberOfItems",
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("|"),
                        ),
                        Text(
                          createdAt,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
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
  final UserListsModel model;
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Text(
            "Update the \"$name\" list",
            style: TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 30,),
          TextField(
            controller: _nameController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: "Name",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              isCollapsed: true,
            ),
          ),
          const SizedBox(height: 30,),
          TextField(
            controller: _descriptionController,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            onChanged: (_) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: "Description",
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              isCollapsed: true,
            ),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Public",
                  style: TextStyle(
                    fontSize: 16,
                  ),
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
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
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
                child: const Text("Update"),
              ),
            ],
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}

class MyListView extends StatefulWidget {
  const MyListView({super.key});

  @override
  State<MyListView> createState() => _MyListViewState();
}

class _MyListViewState extends State<MyListView> {
  List<String> _items = List.generate(20, (index) => 'Item $index');
  List<bool> _selected = List.generate(20, (index) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List View with Selection'),
        actions: [
          if(_selected.firstWhere((e) => e == true,) == true)
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteSelectedItems,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              selectedTileColor: Colors.red[200],
              tileColor: Colors.grey[200],
              title: Text(_items[index]),
              selected: _selected[index],
              selectedColor: Colors.blue,
              onLongPress: () {
                setState(() {
                  _selected[index] = !_selected[index];
                });
              },
            ),
          );
        },
      ),
    );
  }

  void _deleteSelectedItems() {
    setState(() {
      for (int i = _items.length - 1; i >= 0; i--) {
        if (_selected[i]) {
          _items.removeAt(i);
          _selected.removeAt(i);
        }
      }
    });
  }
}
