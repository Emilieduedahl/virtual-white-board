class User {
  String uid;
  String username;
  String password;
  bool moderator;

  User({this.uid, this.username, this.password, this.moderator});

  factory User.fromJson(dynamic parsedJson) {
    return User(
      uid: parsedJson['uid'],
      username: parsedJson['name'],
      password: parsedJson['password'],
      moderator: parsedJson['moderator']
    );
  }

  /*Map<String, dynamic> toJson() => {
    'name': username,
    'password': password,
    'moderator': false
  };*/
}