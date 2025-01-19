import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app_v1/colors.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/focus_room_screen.dart';
import 'package:productivity_app_v1/utils.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  final String? username;

  const LandingScreen({super.key, this.username});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  TextEditingController _roomNumberController = TextEditingController();
  bool _joinRoom = false;
  String _roomNumber = "123abc";

  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    final userNotifier = Provider.of<UserNotifier>(context, listen: false);
    userNotifier.username = widget.username!; // Updates the value globally

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: [
        Image.asset(
          'assets/landing_page_background.png',
          fit: BoxFit.fitHeight,
          height: MediaQuery.sizeOf(context).height,
          alignment: AlignmentDirectional.bottomCenter,
        ),
        Container(
          // decoration: BoxDecoration(gradient: AppColors.backgroundColor),
          padding: EdgeInsets.only(top: 15, bottom: 15, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerLeft,
                    children: [
                      Positioned(
                        left: 15,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: AppColors.buttonColor,
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                  color: AppColors.buttonBorder, width: 3)),
                          width: 130,
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, right: 5, left: 20),
                          child: Text(
                            "1,000,000",
                            style: TextStyle(
                                fontFamily: "Lexend",
                                fontSize: 14,
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Image.asset(
                        'assets/chronos.png',
                        width: 45,
                        height: 45,
                        fit: BoxFit.contain,
                      )
                    ],
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border:
                            Border.all(color: AppColors.buttonBorder, width: 3),
                        gradient: AppColors.buttonColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(3),
                    child: Icon(
                      size: 32,
                      Icons.people_alt,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        "assets/avatar_face/face 2.jpeg",
                        width: 40,
                        height: 40,
                      ))
                ],
              ),
              if (widget.username != null) Spacer(),
              if (widget.username != null)
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      gradient: AppColors.backgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  padding: EdgeInsets.all(13),
                  child: Text(
                    "Welcome back, ${widget.username}!",
                    style: TextStyle(
                        fontFamily: "Lexend",
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              if (widget.username != null) Spacer(),
              if (widget.username == null) Expanded(child: SizedBox()),
              Image.asset(
                'assets/adam.png',
                fit: BoxFit.cover,
                height: 520,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _joinRoom = true;
                  });
                },
                child: Container(
                  width: 230,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      gradient: AppColors.buttonColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      border:
                          Border.all(color: AppColors.buttonBorder, width: 4)),
                  padding: EdgeInsets.only(top: 6, bottom: 6),
                  child: Center(
                    child: Text(
                      'Join Room',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontFamily: "Lexend",
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 230,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    gradient: AppColors.buttonColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border:
                        Border.all(color: AppColors.buttonBorder, width: 4)),
                padding: EdgeInsets.only(top: 6, bottom: 6),
                child: Center(
                  child: Text(
                    'Create Room',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontFamily: "Lexend",
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
        if (_joinRoom)
          GestureDetector(
            onTap: () {
              setState(() {
                _joinRoom = false;
              });
            },
            child: Opacity(
              opacity: 0.7,
              child: Container(
                color: Colors.black, // Black overlay with 70% opacity
              ),
            ),
          ),
        if (_joinRoom)
          Center(
            child: Container(
              decoration: BoxDecoration(
                  gradient: AppColors.buttonColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: 300,
              height: 180,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 20),
                child: Column(
                  children: [
                    Text(
                      "Enter Room Number:",
                      style: TextStyle(fontFamily: "Lexend", fontSize: 18),
                    ),
                    Container(
                        width: 150,
                        child: TextField(
                          controller: _roomNumberController,
                          textAlign: TextAlign.center,
                          textAlignVertical: TextAlignVertical(y: 1),
                          style: TextStyle(fontFamily: "Lexend"),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (_roomNumberController.text == "") {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  alignment: Alignment.bottomCenter,
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    "Please enter a room number!",
                                    style: TextStyle(
                                        fontFamily: "Lexend", fontSize: 14),
                                  ),
                                );
                              });
                        } else if (_roomNumberController.text != _roomNumber) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    "No such room exist!",
                                    style: TextStyle(
                                        fontFamily: "Lexend", fontSize: 14),
                                  ),
                                );
                              });
                        }
                        if (_roomNumberController.text == _roomNumber) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FocusRoomScreen()));
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.red),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Join Room",
                          style: TextStyle(fontFamily: "Lexend", fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      ]),
    ));
  }
}
