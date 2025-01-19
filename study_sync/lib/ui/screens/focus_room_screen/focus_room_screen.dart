import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productivity_app_v1/actors/player.dart';
import 'package:productivity_app_v1/colors.dart';
import 'package:productivity_app_v1/services/db_service.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/widgets/my_game.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/widgets/timer.dart';
import 'package:productivity_app_v1/ui/screens/landing_screen/landing_screen.dart';
import 'package:productivity_app_v1/ui/screens/log_history_screen/log_history_screen.dart';
import 'package:productivity_app_v1/ui/screens/log_history_screen/widgets/log_display.dart';
import 'package:productivity_app_v1/ui/screens/to_do_list_screen/to_do_list_screen.dart';
import 'package:productivity_app_v1/utils.dart';
import 'package:provider/provider.dart';

class FocusRoomScreen extends StatefulWidget {
  const FocusRoomScreen({super.key});

  static final GlobalKey<_FocusRoomScreenState> globalKey =
      GlobalKey<_FocusRoomScreenState>();

  @override
  State<FocusRoomScreen> createState() => _FocusRoomScreenState();
}

class _FocusRoomScreenState extends State<FocusRoomScreen> {
  late MyGame game;

  @override
  void initState() {
    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    game = MyGame(userNotifier);
    DbService.listenForNudges(userNotifier.username, '123abc');
    timerController.listenToFirestoreTimer('123abc');
    super.initState();
  }

  final TimerController timerController = Get.put(TimerController());

  bool timerStarted = false;
  bool _exitFlag = false;
  double _currentSliderValue = 60;
  bool isSliderEnabled = true;

  bool getTimerStarted() => timerStarted;

  // Setter to modify the value
  void setTimerStarted(bool value) {
    setState(() {
      timerStarted = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Image.asset(
          'assets/room_page_background.png',
          fit: BoxFit.fitHeight,
          height: MediaQuery.sizeOf(context).height,
          alignment: AlignmentDirectional.bottomCenter,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 25, bottom: 25),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Room 758847",
                      style: TextStyle(
                          fontFamily: "Lexend",
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _exitFlag = true;
                        });
                      },
                      child: Icon(
                        Icons.exit_to_app_rounded,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
                Spacer(
                  flex: 4,
                ),
                Slider(
                  value: _currentSliderValue,
                  max: 120,
                  divisions: 12,
                  activeColor: AppColors.sliderActiveColor,
                  inactiveColor: Colors.grey,
                  onChanged: (double value) {
                    if (isSliderEnabled) {
                      setState(() {
                        _currentSliderValue = value;
                        timerController.updateTime(value.toInt());
                      });
                    }
                  },
                ),
                Obx(
                  () => GradientText(
                      gradientColor: AppColors.timerColor,
                      text: timerController.time.value,
                      fontSize: 76),
                ),
                Spacer(
                  flex: 1,
                ),
                // Image.asset(
                //   fit: BoxFit.cover,
                //   "assets/room1.png",
                //   width: 400,
                //   height: 300,
                // ),
                Stack(children: [
                  Container(
                    width: 400,
                    height: 300,
                    child: GameWidget(game: game),
                  ),
                  // BED
                  Positioned(
                    left: 165,
                    top: 70,
                    child: GestureDetector(
                      onTap: () async {
                        final userNotifier =
                            Provider.of<UserNotifier>(context, listen: false);
                        // to change the animation here
                        bool noNudge = await DbService.moveUserToArea(
                            "123abc", userNotifier.username, 'bed');
                        if (await noNudge == true) {
                          game.changePlayerAnimation(
                              PlayerState.sleeping, userNotifier.username);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                        width: 45,
                        height: 45,
                      ),
                    ),
                  ),
                  // COUCH
                  Positioned(
                    left: 107,
                    top: 155,
                    child: GestureDetector(
                      onTap: () async {
                        final userNotifier =
                            Provider.of<UserNotifier>(context, listen: false);
                        // to change the animation here
                        bool noNudge = await DbService.moveUserToArea(
                            "123abc", userNotifier.username, 'couch');
                        if (noNudge == true) {
                          game.changePlayerAnimation(
                              PlayerState.relax, userNotifier.username);
                        }
                      },
                      child: Transform.rotate(
                        angle: -30 / 180 * 3.14159,
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.transparent),
                          width: 45,
                          height: 20,
                        ),
                      ),
                    ),
                  ),
                  // TABLE 1
                  Positioned(
                    left: 155,
                    top: 185,
                    child: GestureDetector(
                      onTap: () async {
                        final userNotifier =
                            Provider.of<UserNotifier>(context, listen: false);
                        // to change the animation here
                        bool noNudge = await DbService.moveUserToArea(
                            "123abc", userNotifier.username, 'table1');
                        if (noNudge == true) {
                          game.changePlayerAnimation(
                              PlayerState.studying, userNotifier.username);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  // TABLE 2
                  Positioned(
                    left: 205,
                    top: 160,
                    child: GestureDetector(
                      onTap: () {
                        final userNotifier =
                            Provider.of<UserNotifier>(context, listen: false);
                        AddLog.addToList(LogDisplay(
                            name: userNotifier.username,
                            activity: "nudged npc1!",
                            time: AddLog.formatTime(DateTime.now())));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  // // NOTIFICATION
                  // Positioned(
                  //   left: 0,
                  //   top: 0,
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       triggerNofication();
                  //     },
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //           shape: BoxShape.circle, color: Colors.transparent),
                  //       width: 40,
                  //       height: 40,
                  //     ),
                  //   ),
                  // ),
                  // TABLE 3
                  Positioned(
                    left: 255,
                    top: 135,
                    child: GestureDetector(
                      onTap: () {
                        final userNotifier =
                            Provider.of<UserNotifier>(context, listen: false);
                        AddLog.addToList(LogDisplay(
                            name: userNotifier.username,
                            activity: "nudged npc2!",
                            time: AddLog.formatTime(DateTime.now())));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                  // Idle position for player to stand back up
                  Positioned(
                    left: 165,
                    top: 130,
                    child: GestureDetector(
                      onTap: () async {
                        final userNotifier =
                            Provider.of<UserNotifier>(context, listen: false);
                        // to change the animation here
                        bool noNudge = await DbService.moveUserToArea(
                            "123abc", userNotifier.username, 'idle');
                        if (noNudge == true) {
                          game.changePlayerAnimation(
                              PlayerState.idle, userNotifier.username);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                        width: 40,
                        height: 40,
                      ),
                    ),
                  ),
                ]),

                Spacer(
                  flex: 2,
                ),
                if (timerStarted == false)
                  GestureDetector(
                    onTap: () {
                      startTimer(_currentSliderValue.toInt());
                      disableSlider();
                      final userNotifier =
                          Provider.of<UserNotifier>(context, listen: false);
                      AddLog.addToList(LogDisplay(
                          name: userNotifier.username,
                          activity: "Started the session.",
                          time: AddLog.formatTime(DateTime.now())));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Colors.red),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      child: Text(
                        "Start",
                        style: TextStyle(fontFamily: "Lexend", fontSize: 22),
                      ),
                    ),
                  ),
                if (timerStarted == true)
                  Text(
                    "Session started",
                    style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 16,
                        color: Colors.black),
                  ),
                Spacer(
                  flex: 1,
                ),
                if (timerStarted == false)
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ToDoListScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 15, right: 15),
                      decoration: BoxDecoration(
                          gradient: AppColors.buttonColor,
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                              color: AppColors.buttonBorder, width: 3)),
                      child: Icon(
                        Icons.add_task_sharp,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                if (timerStarted == true)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.buttonBorder, width: 3),
                            shape: BoxShape.rectangle,
                            gradient: AppColors.buttonColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ToDoListScreen()));
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Tasks",
                                  style: TextStyle(
                                      fontFamily: "Lexend",
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.check_box_outlined,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          )),
                      Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.buttonBorder, width: 3),
                            shape: BoxShape.rectangle,
                            gradient: AppColors.buttonColor,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 20, right: 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LogHistoryScreen()));
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Logs",
                                  style: TextStyle(
                                      fontFamily: "Lexend",
                                      color: Colors.black),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.manage_search_rounded,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                Spacer(
                  flex: 3,
                )
              ],
            ),
          ),
        ),
        if (_exitFlag)
          Opacity(
            opacity: 0.7,
            child: Container(
              color: Colors.black, // Black overlay with 70% opacity
            ),
          ),
        if (_exitFlag)
          Center(
            child: Container(
              width: 300,
              height: 150,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  gradient: AppColors.buttonColor),
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    "Are you sure to leave?",
                    style: TextStyle(fontFamily: "Lexend", fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _exitFlag = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              border:
                                  Border.all(color: AppColors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text("No",
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              style: TextStyle(
                                  fontFamily: "Lexend", fontSize: 20)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final userNotifier =
                              Provider.of<UserNotifier>(context, listen: false);
                          await game.removePlayer(
                              '123abc', userNotifier.username);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 100,
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              border:
                                  Border.all(color: AppColors.black, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Text("Yes",
                              textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false),
                              style: TextStyle(
                                  fontFamily: "Lexend", fontSize: 20)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
      ]),
    ));
  }

  // To start the timer
  void startTimer(int minutes) {
    timerController.startTimer(minutes);
    setState(() {
      timerStarted = true;
    });
  }

  // To cancel the timer
  void cancelTimer() {
    timerController.cancelTimer();
  }

  // Method to disable the slider
  void disableSlider() {
    isSliderEnabled = false;
  }
}
