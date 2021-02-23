import 'package:flutter/foundation.dart';

class Task {
  String title;
  String description;
  String groupId;
  final String id;
  bool isCompleted = false;

  Task(
      {@required this.title,
      @required this.description,
      @required this.groupId,
      @required this.id,
      this.isCompleted});
}
