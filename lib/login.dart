import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_white_board/frontpage.dart';
import 'package:virtual_white_board/user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.grey[200],
        body: Center(
          child: SizedBox(
            width: 400,
            child: Card(
              child: LoginForm(),
            ),
          ),
        ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _passwordTextController = TextEditingController();
  final _usernameTextController = TextEditingController();
  User user;
  bool foundUser = false;

  double _formProgress = 0;

  List<User> parseUsers(String responseBody) {
    var parsedJson = jsonDecode(responseBody)['users'] as List;
    List<User> users = parsedJson.map((e) => User.fromJson(e)).toList();

    return users;
  }

  Future<String> loadUsers() async {
    return await rootBundle.loadString('lib/assets/cuteAD.json');
  }

  //method checks the credentials by loading the list of current valid users. Then nagivates to the frontpage.
  Future checkUser(name, password) async {
    String response = await loadUsers();
    List<User> users = parseUsers(response);
    for(User u in users) {
      if(u.username == name && u.password == password) {
        setState(() {
          user = u;
          foundUser = true;
        });
      }
    }
    if(foundUser) {
      Navigator.push((context), MaterialPageRoute(builder: (context) => FrontPage(user: user)));
    } else {
      print("Wrong login credentials");
    }
  }

  //Form widget for entering login credentials. Calls to validate the credentials before navigating to the whiteboard.
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _formProgress),
          Text('Velkommen', style: Theme
              .of(context)
              .textTheme
              .headline4),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _usernameTextController,
              decoration: InputDecoration(hintText: 'Brugernavn'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              obscureText: true,
              controller: _passwordTextController,
              decoration: InputDecoration(hintText: 'Password'),
            ),
          ),
          RaisedButton(child: Text("Login"), onPressed: () {
            checkUser(_usernameTextController.text, _passwordTextController.text);
          }
          ),
        ],
      ),
    );
  }
}