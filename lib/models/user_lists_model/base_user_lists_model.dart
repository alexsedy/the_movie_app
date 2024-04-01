import 'package:flutter/material.dart';

abstract class BaseUserListsModel {
  Future<void> getAllUserLists(BuildContext context);
}