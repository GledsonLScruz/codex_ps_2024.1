import 'dart:ui';
import 'dart:convert';
import 'dart:io';


enum Gender { male, female, other}

class UserModel {
  String? id;
  String? name;
  Gender? gender;
  int? age;
  String? email;
  String? password;
  Image? profilePicture;

  UserModel(this.name,this.gender,this.age,this.email,this.password);

  UserModel.fromJsonLogin(Map<String,dynamic> json){
    id = json["_id"];
    name = json["name"];
    gender = genderFromString(json["gender"]);
    age = json["age"];
    email = json["email"];
    password = json["password"];
  }

  Map<String,dynamic> toJson () {
    return {
      "name" : name,
      "gender" : stringFromGender(gender),
      "age" : age,
      "email" : email,
      "password" : password
    };
  }

  static Gender genderFromString(String data){
    switch (data){
      case "male":
        return Gender.male;
      case "female":
        return Gender.female;
      default:
        return Gender.other;
    }
  }

  static String stringFromGender(Gender? gender){
    switch (gender){
      case Gender.male:
        return "male";
      case Gender.female:
        return "female";
      default:
        return "other";
    }
  }
}