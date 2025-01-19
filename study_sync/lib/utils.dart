import 'dart:async';

import 'package:flutter/material.dart';

// Gradient Text
class GradientText extends StatelessWidget {
  const GradientText(
      {super.key,
      required this.gradientColor,
      required this.text,
      required this.fontSize});

  final Gradient gradientColor;
  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradientColor.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text,
          style: TextStyle(fontFamily: "Lexend", fontSize: fontSize, shadows: [
            Shadow(
                offset: Offset(0, 4.0),
                blurRadius: 5.0,
                color: Colors.black.withValues(alpha: 0.5))
          ])),
    );
  }
}

class UserNotifier extends ChangeNotifier {
  String _username;

  UserNotifier(this._username);

  String get username => _username;

  set username(String newUsername) {
    _username = newUsername;
    notifyListeners(); // Notify widgets to rebuild
  }
}
