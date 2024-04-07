import 'package:flutter/material.dart';

abstract class BaseUserListsModel{
  Future<void> getAllUserLists(BuildContext context);

  Future<void> createNewList({required BuildContext context, required String? description, required String name, required bool public});

  Future<void> addItemListToList({required BuildContext context, required int listId, required String name});
}