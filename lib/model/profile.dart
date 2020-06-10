class Profile {
  final String email;
  final String password;
  final String name;
  final int gender;
  final int age;

  Profile(this.name, this.email, this.password, this.gender, this.age);

  Profile.fromJson(Map<String, dynamic> json)
      : password = json['password'],
        email = json['email'],
        name = json['name'],
        gender = json['gender'],
        age = json['age'];

  Map<String, dynamic> toJson() => {
        'password': password,
        'email': email,
        'gender': gender,
        'age': age,
        'name': name,
      };
}
