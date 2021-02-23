import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_groups.dart';
import '../screens/task_list_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskGroups = Provider.of<TaskGroups>(context).taskGroups;
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("Task Manager"),
            automaticallyImplyLeading: false,
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                // home drawer
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (ctx, index) => ListTile(
                            leading: const Icon(
                              Icons.home,
                              size: 28,
                            ),
                            title: const Text(
                              "Home",
                              style: TextStyle(fontSize: 20),
                            ),
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pushReplacementNamed("/");
                            },
                          ),
                      childCount: 1),
                ),
                // task group drawers
                SliverList(
                  delegate: SliverChildBuilderDelegate((ctx, index) {
                    return ListTile(
                      leading: Icon(Icons.list_alt_outlined),
                      title: Text(
                        taskGroups[index].name,
                        style: TextStyle(fontSize: 20),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed(
                            TaskListScreen.routeName,
                            arguments: taskGroups[index]);
                      },
                    );
                  }, childCount: taskGroups.length),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
