import 'package:flutter/material.dart';
import 'package:productivity_app_v1/colors.dart';
import 'package:productivity_app_v1/ui/screens/landing_screen/landing_screen.dart';
import 'package:productivity_app_v1/ui/screens/to_do_list_screen/to_do_list_screen.dart';
import 'package:productivity_app_v1/ui/screens/to_do_list_screen/widgets/to_do.dart';
import 'package:productivity_app_v1/utils.dart';
import 'package:productivity_app_v1/ui/screens/focus_room_screen/focus_room_screen.dart';
import 'package:provider/provider.dart';

class ToDoListScreen extends StatefulWidget {
  ToDoListScreen({super.key});

  @override
  State<ToDoListScreen> createState() => _ToDoListScreenState();
}

TextEditingController _todoListController = TextEditingController();

class AddTask with ChangeNotifier {
  static List<Task> todoList = [];

  static void addToList(String title) {
    Task task = Task(title, false);
    todoList.add(task);
    _todoListController.clear();
  }
}

class Task {
  final String title;
  bool completed;

  Task(this.title, this.completed);
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  bool _addtask = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Image.asset(
              'assets/todolist_page_background.png',
              fit: BoxFit.fitHeight,
              height: MediaQuery.sizeOf(context).height,
              alignment: AlignmentDirectional.bottomCenter,
            ),
            Container(
              decoration: BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 15, 20, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => {Navigator.of(context).pop()},
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            "To-Do-List",
                            style: TextStyle(
                                fontFamily: "Lexend",
                                fontSize: 18,
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          Consumer<AddTask>(builder: (context, addTask, child) {
                        return ListView(
                          children: AddTask.todoList.map((task) {
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 8.0), // Adds margin between tiles
                              decoration: BoxDecoration(
                                gradient: AppColors.buttonColor.withOpacity(
                                    0.85), // Background color based on completion
                                borderRadius: BorderRadius.circular(
                                    12.0), // Rounded corners
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(20, 0, 0, 0),
                                    offset: Offset(0, 2),
                                    blurRadius: 4.0,
                                  ),
                                ],
                              ),
                              child: ListTile(
                                trailing: IconButton(
                                  icon: Icon(Icons.delete,
                                      color:
                                          const Color.fromARGB(140, 81, 5, 0)),
                                  onPressed: () {
                                    setState(() {
                                      AddTask.todoList.remove(task);
                                    });
                                  },
                                ),
                                title: Text(
                                  task.title,
                                  style: TextStyle(fontFamily: "Lexend"),
                                ),
                                leading: IconButton(
                                  icon: Icon(
                                    task.completed
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: AppColors.gold,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      task.completed = !task.completed;
                                    });
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                    Container(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _addtask = true;
                            });
                          },
                          child: Opacity(
                            opacity: 0.9,
                            child: Container(
                              child: Image.asset(
                                'assets/plus_icon.png', // Replace with your image path
                                width:
                                    90, // Set the width (similar to icon size)
                                height: 90, // Set the height
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (_addtask)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _addtask = false;
                  });
                },
                child: Opacity(
                  opacity: 0.7,
                  child: Container(
                    color: Colors.black, // Black overlay with 70% opacity
                  ),
                ),
              ),
            if (_addtask)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(206, 255, 255, 255),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  width: 300,
                  height: 180,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 10, right: 10, bottom: 20),
                    child: Column(children: [
                      Text(
                        "Task:",
                        style: TextStyle(fontFamily: "Lexend", fontSize: 18),
                      ),
                      Container(
                          width: 150,
                          child: TextField(
                            controller: _todoListController,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical(y: 1),
                            style: TextStyle(fontFamily: "Lexend"),
                          )),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          if (_todoListController.text == "") {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    alignment: Alignment.bottomCenter,
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      "Please enter a task!",
                                      style: TextStyle(
                                          fontFamily: "Lexend", fontSize: 14),
                                    ),
                                  );
                                });
                          } else {
                            AddTask.addToList(_todoListController.text);
                            setState(() {
                              _addtask = false;
                            });
                          }
                          ;
                        },
                        child: Container(
                            width: 80,
                            height: 40,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                gradient: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                                textAlign: TextAlign.center,
                                "Add",
                                style: TextStyle(
                                  fontFamily: "Lexend",
                                  fontSize: 18,
                                  color: Colors.black,
                                ))),
                      ),
                    ]),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
