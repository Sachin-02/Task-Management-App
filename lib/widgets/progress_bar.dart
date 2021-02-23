import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tasks.dart';

class ProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<Tasks>(context).tasks;
    final completedTasks = Provider.of<Tasks>(context).completedTasks;
    return tasks.isEmpty
        ? Container()
        : Container(
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: const EdgeInsets.all(13),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    completedTasks == tasks.length
                        ? "You have completed all your tasks! Way to go!"
                        : "You have completed $completedTasks out of ${tasks.length} tasks",
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 20,
                  width: 200,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1.0),
                          // light grey background for progress bar
                          color: Color.fromRGBO(220, 220, 220, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        curve: Curves.linear,
                        width: tasks.isEmpty
                            ? 0
                            // sizing based on number of tasks completed
                            : 200 * completedTasks / tasks.length,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
