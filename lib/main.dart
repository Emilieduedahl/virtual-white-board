import 'package:flutter/material.dart';
import 'package:virtual_white_board/frontpage.dart';
import 'package:virtual_white_board/login.dart';

void main() {
  runApp(Homepage());
}

class Homepage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Virtual White Board',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: LoginPage(title: 'Login for at få lov til at poste meget vigtige ting'),
    );
  }
}


