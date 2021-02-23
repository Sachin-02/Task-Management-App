import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/tasks.dart';
import '../widgets/new_task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;

  TaskListItem(this.task);

  void changeCompletedStatus(BuildContext context, String id) {
    Provider.of<Tasks>(context, listen: false).changeStatus(id);
  }

  // show bottow sheet to edit a task
  void startAddNewTask(BuildContext ctx, String groupId) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTask(groupId: groupId, taskId: task.id),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // dismissible widget to enable swipe to delete
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text("Removed task."),
        ));
        Provider.of<Tasks>(context, listen: false).deleteTask(task.id);
      },
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete, color: Colors.white),
        color: Theme.of(context).errorColor,
      ),
      child: Container(
        width: double.infinity,
        child: Card(
          color: task.isCompleted ? Colors.grey[100] : Colors.white,
          margin: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 5,
          ),
          elevation: 8,
          child: ListTile(
            title: Text(
              task.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(fontSize: 16),
            ),
            trailing: Container(
              width: 100,
              child: Row(
                children: [
                  IconButton(
                    icon: task.isCompleted
                        ? Icon(
                            Icons.check_box,
                            color: Colors.black54,
                          )
                        : Icon(Icons.check_box_outline_blank,
                            color: Colors.black),
                    onPressed: () {
                      changeCompletedStatus(context, task.id);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.black),
                    onPressed: () {
                      startAddNewTask(context, task.groupId);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
