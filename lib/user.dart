class User {
  String username;
  String password;
  bool moderator;

  User({this.username, this.password, this.moderator});

  //User.fromJson(Map<String, dynamic> json) :username = json['name'], password = json['password'];
  factory User.fromJson(dynamic parsedJson) {
    return User(
      username: parsedJson['name'],
      password: parsedJson['password'],
      moderator: parsedJson['moderator']
    );
  }

  Map<String, dynamic> toJson() => {
    'name': username,
    'password': password,
    'moderator': false
  };
}