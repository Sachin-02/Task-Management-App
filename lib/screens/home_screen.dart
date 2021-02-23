import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_groups.dart';
import '../screens/task_list_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/new_task_group.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> fetchAndSet;

  @override
  void initState() {
    super.initState();
    // Intializing the future inside init state to prevent any unnecessary
    // reruns of the future when opening and closing the drawer. This can
    // happen when using the future builder without init state.
    fetchAndSet =
        Provider.of<TaskGroups>(context, listen: false).fetchAndSetTaskGroups();
  }

  // function to show bottom sheet used to add a task group
  void startAddNewTaskGroup(BuildContext ctx, {String id}) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTaskGroup(id: id),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  // managing name edits or the deletions for a task group
  void onLongPress(BuildContext ctx, String id, String name) {
    showDialog(
      context: ctx,
      child: SimpleDialog(
        title: Text(
          name,
          textAlign: TextAlign.center,
        ),
        children: [
          TextButton(
            child: Text(
              "Edit Name",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              startAddNewTaskGroup(ctx, id: id);
            },
          ),
          TextButton(
            child: Text(
              "Delete",
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
            onPressed: () {
              showDialog(
                context: ctx,
                child: AlertDialog(
                  title: Text("Delete Task Group?"),
                  content: Text(
                      "Warning: Deleting a task group will delete of it's related tasks."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<TaskGroups>(ctx, listen: false)
                            .deleteTaskGroup(id);
                        Navigator.of(ctx).pop();
                        Navigator.of(ctx).pop();
                      },
                      child: Text("Delete"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Task Groups"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              startAddNewTaskGroup(context);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: fetchAndSet,
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : Consumer<TaskGroups>(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 40, bottom: 20, left: 10, right: 10),
                  child: Text(
                    "Choose the task group you would like to view.",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                builder: (ctx, taskGroups, ch) => taskGroups
                            .taskGroups.length <=
                        0
                    ? const Center(
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            "You have no task groups. All tasks are managed under a heading that you create such as \"Daily\" or \"Weekly\". Add a new task group using the button in the top right.",
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    // using a single child scroll view with a column and listview builder to
                    // obtain scrolling across both while having static objects on the page
                    : SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ch,
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, i) => Container(
                                width: double.infinity,
                                height: 80,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Theme.of(context).primaryColor,
                                  child: InkWell(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        taskGroups.taskGroups[i].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              TaskListScreen.routeName,
                                              arguments:
                                                  taskGroups.taskGroups[i]);
                                    },
                                    onLongPress: () {
                                      onLongPress(
                                          context,
                                          taskGroups.taskGroups[i].id,
                                          taskGroups.taskGroups[i].name);
                                    },
                                  ),
                                ),
                              ),
                              itemCount: taskGroups.taskGroups.length,
                            ),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
