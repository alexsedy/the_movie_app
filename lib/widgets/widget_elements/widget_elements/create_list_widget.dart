import 'package:flutter/material.dart';
import 'package:the_movie_app/models/interfaces/i_base_user_lists_model.dart';

class CreateListWidget extends StatefulWidget {
  final IBaseUserListsModel model;
  const CreateListWidget({
    super.key, required this.model,
  });

  @override
  State<CreateListWidget> createState() => _CreateListWidgetState();
}

class _CreateListWidgetState extends State<CreateListWidget> {
  final _descriptionController = TextEditingController();
  final _nameController = TextEditingController();
  final _createButtonController = WidgetStatesController();
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