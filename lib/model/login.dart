class Login {
  final String email;
  final String password;

  Login(this.email, this.password);

  Login.fromJson(Map<String, dynamic> json)
      : password = json['password'],
        email = json['email'];

  Map<String, dynamic> toJson() => {
        'password': password,
        'email': email,
      };
}
