import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/task_list_screen.dart';
import '../models/task_group.dart';

// using my own route generator to handle passing more than one argument to
// a new screen

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return CustomRoute(builder: (_) => HomeScreen());
      case TaskListScreen.routeName:
        return CustomRoute(
          builder: (_) {
            // arguments are task group id and name
            TaskGroup argument = args;
            return TaskListScreen(argument.id, argument.name);
          },
        );
      default:
        return _errorRoute();
    }
  }

  // error route in case there is an error. Shouldn't normally ever
  // be called
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
                body: Center(
              child: Text("ERROR"),
            )));
  }
}

// custom route class to create fade transitions as the default
// animation when navigating between pages
class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(
          builder: builder,
          settings: settings,
        );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (settings.name) {
      case "/":
        return child;
      default:
        return FadeTransition(
          opacity: animation,
          child: child,
        );
    }
  }
}
