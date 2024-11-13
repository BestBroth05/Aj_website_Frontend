import 'dart:convert';
import 'package:guadalajarav2/administration/user/userPermissions.dart';
import 'package:guadalajarav2/administration/user/userType.dart';

class User {
  int id = 0;
  late UserType type;
  late String name;
  late String lastName;
  late String email;
  late String username;
  late String password;
  late String registerDate;
  late List<dynamic>? projectsId;

  String? number;
  String? company;
  String? birthday;

  bool isActive = true;

  List<UserPermission> permissions = [];

  User({
    required this.type,
    required this.name,
    required this.lastName,
    required this.email,
    required this.username,
    required this.password,
    required this.registerDate,
    this.birthday,
    this.number,
    this.company,
  });

  User.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.lastName = json['lastName'];
    this.email = json['email'];
    this.username = json['username'];
    this.password = json['password'];
    this.registerDate = json['registerDate'];
    this.type = UserType.values[json['type']];
    this.isActive = json['isActive'] == 1;
    this.birthday = json['birthday'];
    this.number = json['number'];
    this.company = json['company'];
    this.id = json['id'];
    this.projectsId = jsonDecode(json['projects'].toString() == 'null'
        ? '[]'
        : json['projects'].toString());
  }
  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'lastName': this.lastName,
      'email': this.email,
      'username': this.username,
      'password': this.password,
      'registerDate': this.registerDate,
      'isActive': this.isActive ? 1 : 0,
      'type': UserType.values.indexOf(this.type),
      'birthday': this.birthday,
      'number': this.number,
      'company': this.company,
      'id': this.id,
    };
  }

  @override
  String toString() {
    return '${toJson()}';
  }

  String get fullName {
    return '$name $lastName';
  }
}
