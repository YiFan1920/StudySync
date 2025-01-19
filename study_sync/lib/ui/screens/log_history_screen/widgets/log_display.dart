import 'package:flutter/material.dart';

class LogDisplay {
  final String name;
  final String activity;
  final String time;
  const LogDisplay(
      {required this.name, required this.activity, required this.time});

  // @override
  // Widget build(BuildContext context) {
  //   return Placeholder();
  // }
}

// class LogInfo {
//   final String name;
//   final String activity;
//   final String time;

//   LogInfo(this.name, this.activity, this.time);
// }

class AddLog with ChangeNotifier {
  static List<LogDisplay> logList = [];

  static void addToList(LogDisplay log) {
    logList.add(log);
  }

  static String formatTime(DateTime now) {
    int hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    String period = now.hour >= 12 ? "PM" : "AM";
    return "$hour:${now.minute.toString().padLeft(2, '0')} $period";
  }
}
