class User {
  String password;
  String username;
  String email;
  String token;
  List stories;
  int id;

  User({
    required this.username,
    required this.password,
    required this.email,
    required this.stories,
    required this.token,
    required this.id,
  });

  User.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        stories = json['Stories'],
        id = json['id'],
        token = json['token'],
        email = json['email'];
}
