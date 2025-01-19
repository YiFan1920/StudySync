import 'package:flutter/material.dart';
import 'package:productivity_app_v1/colors.dart';

class ToDo extends StatefulWidget {
  final String todoText;
  const ToDo({super.key, required this.todoText});

  @override
  State<ToDo> createState() => _ToDoState();
}

// class Completed with ChangeNotifier {
//   static List<bool> statusList = [];

//   static void changeStatus() {
//     statusList.();

//     }
// }

class _ToDoState extends State<ToDo> {
  bool _completed = false;
  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        height: 50,
        width: 340,
        decoration: BoxDecoration(
          gradient: AppColors.todoColor1,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spacing between items
          children: [
            Text(widget.todoText, style: TextStyle(color: Colors.white, fontFamily: "Lexend"),),
            GestureDetector(
              onTap: () => {
                  setState(() {
                    _completed = !_completed;
                  }) 
                },
              child: 
                _completed ?
                  Icon(Icons.check_box, color: Colors.white)
                : Icon(Icons.check_box_outline_blank, color: Colors.white)
                ),
                
          ],
        ),
      ),
    );
  }
}
