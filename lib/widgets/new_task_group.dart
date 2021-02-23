import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_groups.dart';

// widget to appear in the modal bottom sheet when adding a new task group
class NewTaskGroup extends StatefulWidget {
  final String id;
  NewTaskGroup({this.id});
  @override
  _NewTaskGroupState createState() => _NewTaskGroupState();
}

class _NewTaskGroupState extends State<NewTaskGroup> {
  final _titleController = TextEditingController();
  var _isInit = true;
  var _isEditing = false;

  // setting default text in textcontroller if user is editing the task group
  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      if (widget.id != null) {
        _isEditing = true;
        _titleController.text = Provider.of<TaskGroups>(context, listen: false)
            .findById(widget.id)
            .name;
      }
    }
    super.didChangeDependencies();
  }

  void submitData() {
    final enteredTitle = _titleController.text;
    // title controller can not be empty
    if (enteredTitle.isEmpty) {
      return;
    }
    if (_isEditing) {
      Provider.of<TaskGroups>(context, listen: false)
          .editTaskGroup(widget.id, enteredTitle);
    } else {
      Provider.of<TaskGroups>(context, listen: false)
          .addTaskGroup(enteredTitle);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: 13,
      ),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Enter the task group title",
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
            RaisedButton(
              child: _isEditing
                  ? Text("Update Task Group")
                  : Text("Add Task Group"),
              onPressed: submitData,
            )
          ],
        ),
      ),
    );
  }
}
