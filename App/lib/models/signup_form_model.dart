class SignupForm {
  String? email;
  String? username;
  String? password;

  SignupForm({
    required this.email,
    required this.username,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
    };
  }
}
