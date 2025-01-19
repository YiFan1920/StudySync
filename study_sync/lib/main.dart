import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productivity_app_v1/firebase_options.dart';
import 'package:productivity_app_v1/services/db_service.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/focus_room_screen.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/widgets/timer.dart';
import 'package:productivity_app_v1/ui/screens/landing_screen/landing_screen.dart';
import 'package:productivity_app_v1/ui/screens/log_history_screen/log_history_screen.dart';
import 'package:productivity_app_v1/ui/screens/log_history_screen/widgets/log_display.dart';
import 'package:productivity_app_v1/ui/screens/login_screen/login_screen.dart';
import 'package:productivity_app_v1/ui/screens/signup_screen/signup_screen.dart';
import 'package:productivity_app_v1/ui/screens/to_do_list_screen/to_do_list_screen.dart';
import 'package:productivity_app_v1/utils.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel',
        soundSource: 'resource://raw/res_notification',
        importance: NotificationImportance.Max,
        playSound: true,
        enableVibration: true)
  ]);
  Get.put(TimerController());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AddTask()),
        ChangeNotifierProvider(create: (context) => AddLog()),
        ChangeNotifierProvider(create: (context) => UserNotifier('')),
      ],
      child: const MainApp(),
    ),
  );
}

// TODO
// add provider for room number
// finish the room state management for firestore

// try to add multiple users
// add the nudge feature

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: LoginScreen());
  }
}
