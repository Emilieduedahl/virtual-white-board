import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_view/split_view.dart';
import 'package:virtual_white_board/user.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class FrontPage extends StatefulWidget {
  FrontPage({Key key, this.user});
  final User user;

  @override
  _FrontPageState createState() => _FrontPageState();

}

class _FrontPageState extends State<FrontPage> {
  var inputValue = TextEditingController();
  var changeNameValue = TextEditingController();
  var changePasswordValue = TextEditingController();
  bool input = false;
  String username;
  String psw;
  bool moderator;
  List<String> textPosts = [];
  String _selectedToDelete;

@override
void initState() {
  super.initState();
  username = widget.user.username;
  psw = widget.user.password;
  moderator = widget.user.moderator;
}


  updateName(newName) {
    setState(() {
      username = newName;
    });

    Widget okButton = FlatButton(
      child: Text("Takker"),
      onPressed: () {
        Navigator.of(context).pop();
      }
    );
    
    return showDialog(context: context,
        child: new AlertDialog(
        title: new Text('Info'),
          content: Text('Dit navn er nu ændret til: ' + username),
          actions: [
            okButton,
          ],
    )
    );
  }

  updatePassword(newPassword) {
    setState(() {
      psw = newPassword;
    });

    Widget okButton = FlatButton(
        child: Text("Takker"),
        onPressed: () {
          Navigator.of(context).pop();
        }
    );

    return showDialog(context: context,
        child: new AlertDialog(
          title: new Text('Info'),
          content: Text('Dit password er nu ændret'),
          actions: [
            okButton,
          ],
        )
    );
  }

  deletePost(post) {
    var author = post.contains('$username');

    Widget declined = FlatButton(child: Text("Hov"),
        onPressed: () {
          Navigator.of(context).pop();
        }
    );

    if(author) {
      setState(() {
        textPosts.remove(_selectedToDelete);
      });
    } else {
      return showDialog(context: context,
      child: new AlertDialog(
      title: new Text('Info'),
      content: Text('Du har ikke rettigheder til at slette andre posts end dine egne'),
      actions: [
        declined,
      ],
    )
      );
    }

  }

  /*_save() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/savedPosts.txt');
    final text = 'Hello World!';
    await file.writeAsString(text);
    print('saved');
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplitView(
        initialWeight: 0.5,
        view1: Container(
          child: Column(
            children: [
              Padding (
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(280),
                  ],
                  controller: inputValue,
                decoration: InputDecoration(
                    hintText: 'Skriv din yndlings motivational post'
                ),
              ),
              ),
        RaisedButton(child: Text("Post"), onPressed: () {
          String texttoadd;
          _save();
          setState(() {
            texttoadd = inputValue.text;
            textPosts.add('$texttoadd skrevet af $username');
            input = true;
            inputValue.clear();
          });
        },),
              Padding (
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: changeNameValue,
                  decoration: InputDecoration(
                      hintText: 'Ændre navn'
                  ),
                ),
              ),
              RaisedButton(child: Text("OK"), onPressed: () {
                updateName(changeNameValue.text);
                changeNameValue.clear();
              },),
              SizedBox(height: 20),
              Padding (
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: changePasswordValue,
                  decoration: InputDecoration(
                      hintText: 'Ændre password'
                  ),
                ),
              ),
              RaisedButton(child: Text("OK"), onPressed: () {
                updatePassword(changePasswordValue.text);
                changePasswordValue.clear();
              },),
              SizedBox(height: 20),
              Padding (
                padding: EdgeInsets.all(8.0),
                child: Text("Bliv moderator (jo jo, en administrator siger ok for det!)"),
              ),
              RaisedButton(child: Text("Jo tak, det vil jeg gerne"), onPressed: () {
                setState(() {
                  moderator = true;
                });
                print("$username is now a moderator: $moderator");
              },),
              SizedBox(height: 20),
              DropdownButton(
                hint: Text('Vælg et opslag at slette'),
                value: _selectedToDelete,
                onChanged: (newValue) {
                  setState(() {
                    _selectedToDelete = newValue;
                  });
                  deletePost(_selectedToDelete);
                },
                items: textPosts.map((post) {
                  return DropdownMenuItem(
                    child: new Text(post),
                    value: post,
                  );
                }).toList(),
                )

            ],
          ),
          color: Colors.blueGrey,
        ),
        view2: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/images/white-board.png"),
              fit: BoxFit.fill,
            )
          ),
          child: Column(
            children: [
              Padding (
                  padding: EdgeInsets.all(30.5),
                  child: getPost()
              ),
            ],
        ),
    ),
    viewMode: SplitViewMode.Horizontal
    )
    );
  }

  getPost() {
    if(input == true) { //check if image is also not null
      return
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            padding: EdgeInsets.all(30),
            itemCount: textPosts.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Text(textPosts[index]),
                  /*Image.network(
                  'https://picsum.photos/250?image=9')*/ //implement image posted by the user
                ],

              );//new Text(textPosts[index]);
            }
          );
    } else {
      return new Text("");
    }

  }

}
