import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks.dart';
import '../widgets/app_drawer.dart';
import '../widgets/new_task.dart';
import '../widgets/progress_bar.dart';
import '../widgets/task_list.dart';

class TaskListScreen extends StatefulWidget {
  static const routeName = "/task-list";
  final String taskGroupId;
  final String taskGroupName;

  TaskListScreen(this.taskGroupId, this.taskGroupName);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  Future<void> fetchAndSet;

  @override
  void initState() {
    super.initState();
    // Intializing the future inside init state to prevent any unnecessary
    // reruns of the future when opening and closing the drawer. This can
    // happen when using the future builder without init state.
    fetchAndSet = Provider.of<Tasks>(context, listen: false)
        .fetchAndSetTasks(widget.taskGroupId);
  }

  // function to show bottom sheet for adding a new task
  void startAddNewTask(BuildContext ctx, String groupId) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTask(groupId: groupId),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text("${widget.taskGroupName} Tasks"),
      actions: [
        Consumer<Tasks>(
          builder: (ctx, tasks, ch) => tasks.tasks.isEmpty
              ? Container()
              : IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    tasks.refresh();
                  },
                ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            startAddNewTask(context, widget.taskGroupId);
          },
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: fetchAndSet,
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        ProgressBar(),
                        // using a preset height for the scrollable tasklist widget to exist in
                        Container(
                          child: TaskList(),
                          height: MediaQuery.of(context).size.height -
                              100 -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top,
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
