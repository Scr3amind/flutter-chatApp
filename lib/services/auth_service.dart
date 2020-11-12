import 'dart:convert';

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AuthService with ChangeNotifier {

  User user;
  bool _onProcessing = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get onProcessing => this._onProcessing;

  String get userName => this.user.name;
  String get userEmail => this.user.email;

  set onProcessing(bool value){
    this._onProcessing = value;
    notifyListeners();
  }

  //Getters Estaticos
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }
  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');

  }

  Future<bool> login(String email, String password) async {

    this.onProcessing = true;

    final data = {
      'email': email,
      'password': password
    };


    final resp = await http.post('${Environment.apiUrl}/login',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );


    print(resp.body);
    this.onProcessing = false;
    
    if(resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._saveToken(loginResponse.token);
      
      return true;
    }
    else {
      return false;
    }

  }

  Future<String> register(String name, String email, String password) async {

    this.onProcessing = true;

    final data = {
      'name'    : name,
      'email'   : email,
      'password': password
    };


    final resp = await http.post('${Environment.apiUrl}/login/new',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json'
      }
    );

    this.onProcessing = false;
    
    if(resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._saveToken(loginResponse.token);
      
      return 'ok';
    }
    else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }

  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    final resp = await http.get('${Environment.apiUrl}/login/renew',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token
      } 
    );

    if(resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;
      
      await this._saveToken(loginResponse.token);
      return true;
    }
    else {
      this.logout();
      return false;
    }
  }



  Future _saveToken(String token) async {

    return await _storage.write(key: 'token', value: token);

  }

  Future logout() async {

    await _storage.delete(key: 'token');

  }

  
}