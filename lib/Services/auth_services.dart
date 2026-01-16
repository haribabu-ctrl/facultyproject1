import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_constants.dart';

class AuthServices {

  static Future<Map<String,dynamic>> register (Map<String,dynamic>data)async{
    final res = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/auth/register"),
      headers: {"Contents-Type" : "application/json"},
      body: jsonEncode(data),
    );

    return jsonDecode(res.body);

  }

  //login kosam

  static Future<Map<String ,dynamic>> login(String username , String password)async{
    final res = await http.post(
      Uri.parse("${ApiConstants.baseUrl}/auth/login"),
      headers: {"Content-Type":"application/json"},
      body: jsonEncode({
        "username" : username,
        "password" : password
      }),
    );
    final data = jsonDecode(res.body);

    if(res.statusCode == 200){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data['token']);
      await prefs.setString("role", data['user']['role']);
      await prefs.setString("userId", data['user']['_id']);
    }

    return data;
  }
}