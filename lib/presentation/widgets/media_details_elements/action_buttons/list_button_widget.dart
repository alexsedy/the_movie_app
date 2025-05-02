import 'package:flutter/material.dart';
import 'package:the_movie_app/core/constants/app_spacing.dart';
import 'package:the_movie_app/core/helpers/date_format_helper.dart';
import 'package:the_movie_app/l10n/localization_extension.dart';
import 'package:the_movie_app/presentation/presentation_models/interfaces/i_base_media_details_model.dart';
import 'package:the_movie_app/presentation/widgets/enum_collection.dart';
import 'package:the_movie_app/presentation/widgets/widget_elements/create_list_widget.dart';

class ListButtonWidget<T extends IBaseMediaDetailsModel> extends StatelessWidget {
  final MediaDetailsElementType mediaDetailsElementType;
  final T model;
  const ListButtonWidget({super.key, required this.mediaDetailsElementType, required this.model});

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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  context.l10n.addToTheList,
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                AppSpacing.gapH20,
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
                                  child: Text(context.l10n.newList),
                                ),
                              ],
                            ),
                            AppSpacing.gapH10,
                            Container(height: 1, width: double.infinity, color: Colors.grey,),
                            Flexible(
                              child: ListView.builder(
                                itemCount: model.lists.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final lists = model.lists[index];
                                  final name = lists.name;
                                  final numberOfItems = lists.numberOfItems;
                                  final public = lists.public == 1;
                                  final createdAt = DateFormatHelper.fullShortDate(lists.createdAt.substring(0, lists.createdAt.length - 4));
                                  final listId = lists.id;

                                  return Padding(
                                    padding: AppSpacing.screenPaddingAll10,
                                    child: ListTile(
                                      onTap: () => model.addItemListToList(context: context, listId: listId, name: name),
                                      minLeadingWidth: 20,
                                      titleAlignment: ListTileTitleAlignment.center,
                                      leading: public
                                          ? Icon(Icons.lock_open, color: Colors.greenAccent[700],)
                                          : Icon(Icons.lock_outline, color: Colors.redAccent[700],),
                                      title: Text(
                                        name,
                                        style: Theme.of(context).textTheme.titleLarge,
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Text(
                                            context.l10n.itemNumberOfItems(numberOfItems),
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                          const Padding(
                                            padding: AppSpacing.screenPaddingH10,
                                            child: Text("|"),
                                          ),
                                          Text(
                                            createdAt,
                                            style: Theme.of(context).textTheme.bodyMedium,
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
      child: SizedBox(
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.list),
            Text(context.l10n.list,),
          ],
        ),
      ),
    );
  }
}