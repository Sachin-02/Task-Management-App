import 'package:flutter/foundation.dart';
import '../helpers/db_helper.dart';
import '../models/task_group.dart';

class TaskGroups with ChangeNotifier {
  List<TaskGroup> _taskGroups = [];

  List<TaskGroup> get taskGroups {
    return [..._taskGroups];
  }

  // accessing the db to obtain the existing task groups on startup
  Future<void> fetchAndSetTaskGroups() async {
    final data = await DBHelper.db.getAllData("task_groups");
    _taskGroups = data
        .map(
          (taskGroup) => TaskGroup(
            taskGroup["id"],
            taskGroup["name"],
          ),
        )
        .toList();
    notifyListeners();
    print("fetching and setting task groups");
    _taskGroups.forEach((taskGroup) {
      print(taskGroup.name + " id is: " + taskGroup.id);
    });
  }

  void addTaskGroup(String name) {
    final newTaskGroup = TaskGroup(DateTime.now().toString(), name);
    _taskGroups.add(newTaskGroup);
    notifyListeners();
    DBHelper.db.insert("task_groups", {
      "id": newTaskGroup.id,
      "name": newTaskGroup.name,
    });
  }

  void editTaskGroup(String id, String updatedName) {
    final index = _taskGroups.indexWhere((taskGroup) => taskGroup.id == id);
    _taskGroups[index].name = updatedName;
    notifyListeners();
    DBHelper.db.update(
      table: "task_groups",
      columnId: "name",
      setArg: updatedName,
      whereColumnId: "id",
      whereArg: id,
    );
  }

  void deleteTaskGroup(String id) {
    _taskGroups.removeWhere((taskGroup) => taskGroup.id == id);
    // deleting all tasks under the task group before deleting the page to
    // meet the foreign key constraint
    DBHelper.db.delete(table: "user_tasks", columnId: "groupId", whereArg: id);
    DBHelper.db.delete(table: "task_groups", columnId: "id", whereArg: id);
    notifyListeners();
  }

  TaskGroup findById(String id) {
    return _taskGroups.firstWhere((taskGroup) => taskGroup.id == id);
  }
}
