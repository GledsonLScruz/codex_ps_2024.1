import 'dart:convert';

import 'package:codex_ps_2024_1/data/task_model.dart';
import 'package:codex_ps_2024_1/data/user_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const baseUrl = "https://codex-challenge-2024-to-do-back-end-i1hd.onrender.com/app";
Map<String,String> header = {
      "Content-Type" : "application/json"
    };

class Request {
  static Future<bool> login (String email, String password)async{
    
    Map<String,String> body = {
      "email" : email,
      "password" : password
    };

    var response = await http.post(Uri.parse("$baseUrl/login"),body: jsonEncode(body),headers: header);

    if (response.statusCode > 299){
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> singUp (UserModel user)async{

    var body = jsonEncode(user.toJson());

    var response = await http.post(Uri.parse("$baseUrl/singup"),body: body, headers: header);

    var decodedBody = jsonDecode(response.body);
    if (response.statusCode > 299){
      SnackBar(content: Text(decodedBody["message"]));
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> getTasks(String userId) async {

    var response = await http.post(Uri.parse("$baseUrl/getTasks/$userId"));

    return true;
  }

  static Future<bool> editProfile(UserModel user) async {

    var response = await http.post(Uri.parse("$baseUrl/editProfile/${user.id}"));
    return true;
  }

  static Future<bool> addTask(TaskModel task, String userId) async {

    var response = await http.post(Uri.parse("$baseUrl/addTask/$userId"));
    return true;
  }

  static Future<bool> editTask(TaskModel task, String userId) async {

    var response = await http.post(Uri.parse("$baseUrl/editTask/$userId/${task.id}"));

    return true;
  }

  static Future<bool> deleteTask(TaskModel task, String userId) async {

    var response = await http.post(Uri.parse("$baseUrl/deleteTask/$userId/${task.id}"));
    return true;
  }

  
}