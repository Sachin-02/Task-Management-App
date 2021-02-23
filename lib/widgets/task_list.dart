import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks.dart';
import '../widgets/task_list_item.dart';

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 5,
        ),
        width: double.infinity,
        child: Consumer<Tasks>(
          child: Center(
            child: const Padding(
              padding: const EdgeInsets.all(10),
              child: const Text(
                "You have no tasks. Click the button in the top right to add a task.",
                style: const TextStyle(
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          builder: (ctx, tasks, ch) => tasks.tasks.isEmpty
              ? ch
              : ListView.builder(
                  itemBuilder: (ctx, index) {
                    return TaskListItem(tasks.tasks[index]);
                  },
                  itemCount: tasks.tasks.length,
                ),
        ));
  }
}
