import 'package:flutter/material.dart';
import '../helpers/db_helper.dart';
import '../models/task.dart';

class Tasks with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks {
    return [..._tasks];
  }

  int get completedTasks {
    var completed = 0;
    _tasks.forEach((task) {
      if (task.isCompleted) {
        completed += 1;
      }
    });
    return completed;
  }

  // accessing db to get the existing tasks based on the
  // task group the user has opened
  Future<void> fetchAndSetTasks(String groupId) async {
    final data = await DBHelper.db
        .getData(table: "user_tasks", columnId: "groupId", arg: groupId);
    _tasks = data
        .map((task) => Task(
              id: task["id"],
              groupId: task["groupId"],
              title: task["title"],
              description: task["description"],
              isCompleted: (task["isCompleted"] == "true"),
            ))
        .toList();
    notifyListeners();
    print("fetching and setting tasks");
    _tasks.forEach((task) {
      print(task.title +
          " id is: " +
          task.id +
          " and taskGroup id is: " +
          task.groupId);
    });
  }

  void addTask(String title, String description, String groupId) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
      description: description,
      groupId: groupId,
      isCompleted: false,
    );
    _tasks.add(newTask);
    notifyListeners();
    DBHelper.db.insert("user_tasks", {
      "id": newTask.id,
      "groupId": newTask.groupId,
      "title": newTask.title,
      "description": newTask.description,
      "isCompleted": "false",
    });
  }

  void editTask(String id, String title, String description) {
    final index = _tasks.indexWhere((task) => task.id == id);
    _tasks[index].title = title;
    _tasks[index].description = description;
    notifyListeners();
    DBHelper.db.update(
      table: "user_tasks",
      columnId: "title",
      setArg: title,
      whereColumnId: "id",
      whereArg: id,
    );
    DBHelper.db.update(
      table: "user_tasks",
      columnId: "description",
      setArg: description,
      whereColumnId: "id",
      whereArg: id,
    );
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
    DBHelper.db.delete(table: "user_tasks", columnId: "id", whereArg: id);
  }

  void changeStatus(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    _tasks[index].isCompleted = !_tasks[index].isCompleted;
    notifyListeners();
    DBHelper.db.update(
      table: "user_tasks",
      columnId: "isCompleted",
      setArg: _tasks[index].isCompleted ? "true" : "false",
      whereColumnId: "id",
      whereArg: id,
    );
  }

  void refresh() {
    // setting all completed tags to false
    for (var i = 0; i < _tasks.length; i++) {
      _tasks[i].isCompleted = false;
    }
    notifyListeners();
    DBHelper.db.updateColumn(
        table: "user_tasks", columnId: "isCompleted", arg: "false");
  }

  Task findById(String id) {
    return _tasks.firstWhere((task) => task.id == id);
  }
}
