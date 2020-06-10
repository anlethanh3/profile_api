class Token {
  final String token;
  final bool auth;

  Token(this.token, this.auth);

  Token.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        auth = json['auth'];

  Map<String, dynamic> toJson() => {
        'auth': auth,
        'token': token,
      };

  String accessToken() {
    return "$token";
  }
}
