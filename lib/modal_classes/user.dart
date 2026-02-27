class User {
  String? name;
  String? email;
  String? password;
  String? token;
  String? id;

  User({this.name, this.email, this.password, this.token, this.id});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    password = json['password'];
    token = json['token'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['token'] = this.token;
    data['id'] = this.id;
    return data;
  }
}