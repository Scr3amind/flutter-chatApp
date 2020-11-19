import 'package:chat_app/global/environment.dart';
import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class ChatService with ChangeNotifier{

  User userTo;

  Future<List<Message>> getChat(String userID) async {

    final resp = await http.get('${Environment.apiUrl}/messages/$userID',
    headers: {
      'Content-Type': 'application/json',
      'x-token'     : await AuthService.getToken()
      }
    );

    final messagesResp = messagesResponseFromJson(resp.body);
    return messagesResp.messages;
    
  }
  


}