import 'package:flutter/material.dart';
import 'package:the_movie_app/provider/provider.dart';
import 'package:the_movie_app/widgets/list_screens/user_lists_model.dart';
import 'package:the_movie_app/widgets/widget_elements/shimmer_skeleton_elements/list_shimmer_skeleton_widget.dart';

class UserListsWidget extends StatefulWidget {
  const UserListsWidget({super.key});

  @override
  State<UserListsWidget> createState() => _UserListsWidgetState();
}

class _UserListsWidgetState extends State<UserListsWidget> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text("User lists"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: (){},
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
                          onTap: () {},
                        ),
                        PopupMenuItem<String>(
                          child: Text('Clear'),
                          onTap: () {},
                        ),
                        PopupMenuItem<String>(
                          child: Text('Delete'),
                          onTap: () {},
                        ),
                      ],
                      onSelected: (String value) {
                        // Обработка выбранного пункта меню
                        print('Выбран пункт: $value');
                      },
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

class MyListView extends StatefulWidget {
  @override
  _MyListViewState createState() => _MyListViewState();
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
