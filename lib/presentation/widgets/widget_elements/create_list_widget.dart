import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_user_lists_model.dart';

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
      padding: AppSpacing.screenPaddingH16V10,
      child: Column(
        children: [
          Text(
            context.l10n.createANewList,
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
            child: Text(context.l10n.create),
          ),
          AppSpacing.gapH20,
        ],
      ),
    );
  }
}