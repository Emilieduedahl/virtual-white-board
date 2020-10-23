import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:split_view/split_view.dart';
import 'package:virtual_white_board/user.dart';
import 'package:virtual_white_board/post.dart';

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
  String uid;
  bool moderator;
  List<Post> motivationalPosts = [];
  Post firstPost;
  String _selectedToDelete;

@override
void initState() {
  super.initState();
  firstPost = new Post(content: "Velkommen!", author: "admin", authorID: "3923");
  _selectedToDelete = firstPost.content;
  motivationalPosts.add(firstPost);
  username = widget.user.username;
  psw = widget.user.password;
  moderator = widget.user.moderator;
  uid = widget.user.uid;
}

//method for updating for a cooler alias
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

  //method for updating password
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

  //method for deleting a user's own post. Ensures users cannot delete other user's posts - unless they are a moderator.
  deletePost(post) {

    Widget declined = FlatButton(child: Text("Hov"),
        onPressed: () {
          Navigator.of(context).pop();
        }
    );


    for(Post p in motivationalPosts) {
      if (p.content == (post)) {
        if(p.authorID == uid) {
          setState(() {
            motivationalPosts.remove(p);
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
    }
  }

  createPost(input) {
    Post p = new Post(content: input, author: username, authorID: uid);
    setState(() {
      motivationalPosts.add(p);
    });
  }

//Widget builds the split layout with input to the left that will appear on the virtual whiteboard to the right.
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
          createPost(inputValue.text);
          setState(() {
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
              SizedBox(height: 10),
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
                    deletePost(_selectedToDelete);
                  });
                },
                items: motivationalPosts.map((post) {
                  return DropdownMenuItem(
                    child: new Text(post.content + " skrevet af: " + post.author),
                    value: post.content,
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
    if(input == true) {
      return
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
            padding: EdgeInsets.all(30),
            itemCount: motivationalPosts.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Text(motivationalPosts[index].content + " skrevet af: " + motivationalPosts[index].author),
                ],
              );
            }
          );
    } else {
      return new Text("");
    }

  }

}
