import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app_v1/colors.dart';
import 'package:productivity_app_v1/services/auth_service.dart';
import 'package:productivity_app_v1/ui/screens/signup_screen/signup_screen.dart';
import 'package:productivity_app_v1/utils.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Image.asset(
              'assets/login_screen_background.png',
              fit: BoxFit.fitHeight,
              height: MediaQuery.of(context).size.height,
              alignment: AlignmentDirectional.bottomCenter,
            ),
            Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 25, bottom: 25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Spacer(),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text("Login",
                              style: TextStyle(
                                  fontFamily: "Lexend",
                                  fontSize: 28,
                                  color: Colors.white)),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Text("Please sign in to continue",
                              style: TextStyle(
                                  fontFamily: "Lexend",
                                  fontSize: 15,
                                  color: Colors.white)),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Container(
                            width: 330,
                            height: 45,
                            decoration: BoxDecoration(
                                gradient: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.yellow,
                                  width: 2,
                                )),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Icon(Icons.email_outlined),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _emailController,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Color of the typed text
                                      fontFamily:
                                          "Lexend", // Font for the typed text
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'enter your email',
                                      hintStyle: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontFamily: "Lexend",
                                          fontSize: 13),
                                      border: InputBorder
                                          .none, // Removes the underline
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Container(
                            width: 330,
                            height: 45,
                            decoration: BoxDecoration(
                                gradient: AppColors.buttonColor,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.yellow,
                                  width: 2,
                                )),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Icon(Icons.lock_outline),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _passwordController,
                                    textAlign: TextAlign.left,
                                    obscureText: true,
                                    style: TextStyle(
                                      color: Colors
                                          .black, // Color of the typed text
                                      fontFamily:
                                          "Lexend", // Font for the typed text
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'enter your password',
                                      hintStyle: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 0, 0, 0),
                                          fontFamily: "Lexend",
                                          fontSize: 13),
                                      border: InputBorder
                                          .none, // Removes the underline
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
                          child: GestureDetector(
                            onTap: () {
                              AuthService().logIn(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                  context: context);
                            },
                            child: Container(
                              width: 330,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: AppColors.buttonColor,
                                border: Border.all(
                                  color: AppColors.gold,
                                  width: 2,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sign in",
                                    style: TextStyle(fontFamily: "Lexend"),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Colors.white),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Register",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Navigate to SignupScreen
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignupScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                      ]),
                )),
          ],
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:productivity_app_v1/services/auth_service.dart';
// import 'package:productivity_app_v1/utils.dart';

// // ignore: must_be_immutable
// class LoginScreen extends StatelessWidget {
//   LoginScreen({super.key});
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Container(
//             width: 200,
//             child: TextField(
//               controller: _emailController,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontFamily: "Lexend"),
//             ),
//           ),
//           Container(
//             width: 200,
//             child: TextField(
//               controller: _passwordController,
//               textAlign: TextAlign.center,
//               obscureText: true,
//               style: TextStyle(fontFamily: "Lexend"),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               AuthService().logIn(
//                   email: _emailController.text,
//                   password: _passwordController.text,
//                   context: context);
//             },
//             child: Container(
//               width: 100,
//               height: 50,
//               child: Text("Log in"),
//             ),
//           )
//         ],
//       ),
//     ));
//   }
// }
