import 'dart:convert';

import 'package:codex_ps_2024_1/data/user_model.dart';
import 'package:http/http.dart' as http;

const baseUrl = "url.com";

class Request {
  static Future<bool> login (String email, String password)async{
    
    Map<String,String> body = {
      "email" : email,
      "senha" : password
    };

    var response = await http.post(Uri.parse("$baseUrl/login"),body: jsonEncode(body));

    if (response.statusCode > 299){
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> singUp (UserModel user)async{

    var response = await http.post(Uri.parse("$baseUrl/singup"),body: jsonEncode(user.toJson));

    if (response.statusCode > 299){
      return false;
    } else {
      return true;
    }
  }

  
}