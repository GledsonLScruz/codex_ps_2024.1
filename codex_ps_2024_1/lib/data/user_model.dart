import 'dart:ui';

enum Gender { male, female, other}

class UserModel {
  String? name;
  Gender? gender;
  int? age;
  String? email;
  String? password;
  Image? profilePicture;

  UserModel.fromJson(Map<String,dynamic> json){
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

  toJsonEdit (){
    return {
      "name" : name,
      "age" : age,
    };
  }

  

  Gender genderFromString(String data){
    switch (data){
      case "male":
        return Gender.male;
      case "female":
        return Gender.female;
      default:
        return Gender.other;
    }
  }

  String stringFromGender(Gender? gender){
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