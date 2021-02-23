import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/tasks.dart';
import './providers/task_groups.dart';
import './helpers/route_generator.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Tasks>(
          create: (_) => Tasks(),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskGroups(),
        ),
      ],
      child: MaterialApp(
        initialRoute: "/",
        onGenerateRoute: RouteGenerator.generateRoute,
        title: 'Daily Tasks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
      ),
    );
  }
}
