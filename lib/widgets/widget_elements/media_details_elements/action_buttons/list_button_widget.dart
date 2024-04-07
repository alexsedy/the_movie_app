import 'package:flutter/material.dart';
import 'package:the_movie_app/models/media_details_model/base_media_details_model.dart';
import 'package:the_movie_app/widgets/widget_elements/enum_collection.dart';

class ListButtonWidget<T extends BaseMediaDetailsModel> extends StatelessWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  final T model;
  const ListButtonWidget({Key? key, required this.mediaDetailsElementType, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: () async {
        showModalBottomSheet(
            context: context,
            showDragHandle: true,
            isScrollControlled: true,
            elevation: 0.2,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
            ),
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.75,
                child: FutureBuilder<void>(
                    future: model.getAllUserLists(context),
                    builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Add to the list",
                                    style: TextStyle(fontSize: 22),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);

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
                                ],
                              ),
                            ),
                            const SizedBox(height: 10,),
                            Container(height: 1, width: double.infinity, color: Colors.grey,),
                            Flexible(
                              child: ListView.builder(
                                itemCount: model.lists.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final lists = model.lists[index];
                                  final name = lists.name;
                                  final numberOfItems = lists.numberOfItems;
                                  final public = lists.public == 1;
                                  final createdAt = model.formatDate(lists.createdAt.substring(0, lists.createdAt.length - 4));
                                  final listId = lists.id;

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      onTap: () => model.addItemListToList(context: context, listId: listId, name: name),
                                      minLeadingWidth: 20,
                                      titleAlignment: ListTileTitleAlignment.center,
                                      leading: public
                                          ? Icon(Icons.lock_open, color: Colors.greenAccent[700],)
                                          : Icon(Icons.lock_outline, color: Colors.redAccent[700],),
                                      title: Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 22,
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
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
                              ),
                            ),
                          ],
                        );
                      }
                    }
                ),
              );
            }
        );
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

class CreateListWidget extends StatefulWidget {
  final BaseMediaDetailsModel model;
  const CreateListWidget({
    super.key, required this.model,
  });

  @override
  State<CreateListWidget> createState() => _CreateListWidgetState();
}

class _CreateListWidgetState extends State<CreateListWidget> {
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  final _createButtonController = MaterialStatesController();
  bool _isPublic = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          const Text(
            "Create a new list",
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
          ElevatedButton(
            statesController: _createButtonController,
            onPressed: _nameController.text.isNotEmpty
                ? () => widget.model.createNewList(
                context: context,
                description: _descriptionController.text.trimRight(),
                name: _nameController.text.trimRight(),
                public: _isPublic
            )
                : null,
            child: const Text("Create"),
          ),
          const SizedBox(height: 20,),
        ],
      ),
    );
  }
}