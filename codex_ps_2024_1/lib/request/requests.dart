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
  static Future<UserModel?> login (String email, String password)async{
    
    Map<String,String> body = {
      "email" : email,
      "password" : password
    };

    var response = await http.post(Uri.parse("$baseUrl/login"),body: jsonEncode(body),headers: header);

    var decodedBody = jsonDecode(response.body);
    if (response.statusCode > 299){
      SnackBar(content: Text(decodedBody["message"]));
      return null;
    } else {
      return UserModel.fromJsonLogin(decodedBody["data"]);
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

  static Future<List<TaskModel>> getTasks(String userId) async {

    var response = await http.get(Uri.parse("$baseUrl/getTasks/$userId"),headers: header);

    var decodedBody = jsonDecode(response.body);
    if (response.statusCode > 299){
      SnackBar(content: Text(decodedBody["message"]));
      return [];
    } else {
      List<TaskModel> result = [];
      for (dynamic item in decodedBody["data"][0]["tasks"]){
        result.add(TaskModel.fromJson(item));
      }
      return result;
    }
  }

  static Future<bool> editProfile(String userId, String name, String age, String base64Photo) async {

    var body =  {
      "name" : name,
      "age" : age,
      "photo" : base64Photo
    };

    var response = await http.post(Uri.parse("$baseUrl/editProfile/$userId"),headers: header, body: jsonEncode(body));
    return true;
  }

  static Future<TaskModel?> addTask(TaskModel task, String userId) async {

    var body = jsonEncode(task.toJson());

    var response = await http.post(Uri.parse("$baseUrl/addTask/$userId"),headers: header, body: body);

     var decodedBody = jsonDecode(response.body);
    if (response.statusCode > 299){
      SnackBar(content: Text(decodedBody["message"]));
      return null;
    } else {
      return TaskModel.fromJson(decodedBody["data"]);
    }
  }

  static Future<bool> editTask(TaskModel task, String userId) async {

    var body = jsonEncode(task.toJsonEdit());

    var response = await http.put(Uri.parse("$baseUrl/updateStatusTask/$userId/${task.id}"),headers: header,body: body);

     var decodedBody = jsonDecode(response.body);
    if (response.statusCode > 299){
      SnackBar(content: Text(decodedBody["message"]));
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> deleteTask(TaskModel task, String userId) async {

    var response = await http.delete(Uri.parse("$baseUrl/deleteTask/$userId/${task.id}"),headers: header);

    var decodedBody = jsonDecode(response.body);
    if (response.statusCode > 299){
      SnackBar(content: Text(decodedBody["message"]));
      return false;
    } else {
       return true;
    }
  }
}