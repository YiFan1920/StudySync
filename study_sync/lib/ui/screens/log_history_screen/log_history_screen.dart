import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productivity_app_v1/colors.dart';
import 'package:productivity_app_v1/ui/screens/log_history_screen/log_history_screen.dart';
import 'package:productivity_app_v1/ui/screens/log_history_screen/widgets/log_display.dart';
import 'package:productivity_app_v1/utils.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/focus_room_screen.dart';
import 'package:provider/provider.dart';

class LogHistoryScreen extends StatefulWidget {
  const LogHistoryScreen({super.key});

  @override
  State<LogHistoryScreen> createState() => _LogHistoryScreenState();
}

class _LogHistoryScreenState extends State<LogHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              "assets/todolist_page_background.png",
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height,
              alignment: AlignmentDirectional.bottomCenter,
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => {Navigator.of(context).pop()},
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Log History",
                            style: TextStyle(
                                fontFamily: "Lexend",
                                fontSize: 18,
                                color: Colors.black),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          Consumer<AddLog>(builder: (context, addLog, child) {
                        return ListView.builder(
                          itemCount: AddLog.logList.length,
                          itemBuilder: (context, index) {
                            final log = AddLog
                                .logList[AddLog.logList.length - index - 1];
                            return Container(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromARGB(146, 0, 0, 0),
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                leading: Text(
                                  log.name,
                                  style: const TextStyle(
                                    fontFamily: "Lexend",
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                title: Text(
                                  log.activity,
                                  style: const TextStyle(
                                    fontFamily: "Lexend",
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Text(
                                  log.time,
                                  style: const TextStyle(
                                    fontFamily: "Lexend",
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
