import 'package:flutter/material.dart';
import 'package:todo/addtask_screen.dart';
import 'package:todo/home.dart';

class Routes {
  static const String home = '/';
  static const String addTask = '/add-task';

  static Map<String, WidgetBuilder> get routes {
    return {
      home: (context) => const HomeScreen(),
      addTask: (context) => const AddTaskScreen(),
    };
  }
}
