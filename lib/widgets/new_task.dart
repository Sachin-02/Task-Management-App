import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks.dart';

// widget to appear in the modal bottom sheet when adding a new task
class NewTask extends StatefulWidget {
  final String groupId;
  final String taskId;

  NewTask({this.groupId, this.taskId});
  @override
  _NewTaskState createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  var _isInit = true;
  var _isEditing = false;

  // setting the default text if the user is editing a task
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      if (widget.taskId != null) {
        _isEditing = true;
        final task =
            Provider.of<Tasks>(context, listen: false).findById(widget.taskId);
        _titleController.text = task.title;
        _descriptionController.text = task.description;
      }
    }
    super.didChangeDependencies();
  }

  void submitData() {
    final enteredTitle = _titleController.text;
    final enteredDescription = _descriptionController.text;
    // title controller must not be empty
    if (enteredTitle.isEmpty) {
      return;
    }
    if (_isEditing) {
      Provider.of<Tasks>(context, listen: false)
          .editTask(widget.taskId, enteredTitle, enteredDescription);
    } else {
      Provider.of<Tasks>(context, listen: false)
          .addTask(enteredTitle, enteredDescription, widget.groupId);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 13,
        ),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Enter the task info",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Title",
                ),
                controller: _titleController,
                onSubmitted: (_) {
                  submitData();
                },
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Description",
                ),
                controller: _descriptionController,
                onSubmitted: (_) {
                  submitData();
                },
              ),
              RaisedButton(
                child: _isEditing ? Text("Update Task") : Text("Add Task"),
                onPressed: () {
                  submitData();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
