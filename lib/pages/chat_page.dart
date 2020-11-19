import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  bool _hasText = false;
  List<ChatMessage> _messages = [
    // ChatMessage(text: 'Hola mundo', uid: '123'),
    // ChatMessage(text: 'Hola mundo', uid: '123'),
    // ChatMessage(text: 'Hola mundo', uid: '1234'),
    // ChatMessage(text: 'Hola mundo', uid: '1234'),
    // ChatMessage(text: 'Hola mundo', uid: '123'),
    // ChatMessage(text: 'Hola mundo', uid: '1234'),
    // ChatMessage(text: 'Hola mundo', uid: '123'),
  ];

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('personal-message', _listenMessage);

    _loadChatHistory(this.chatService.userTo.uid);
  }

  void _loadChatHistory(String userID) async {
    List<Message> chat = await this.chatService.getChat(userID);
    final history = chat.map((m) => new ChatMessage(
      text: m.message, 
      uid: m.from, 
      animationController: new AnimationController(
        vsync: this, 
        duration: Duration(milliseconds: 500)
        )..forward()
      )
    );
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    ChatMessage message = new ChatMessage(
      text: payload['message'], 
      uid: payload['from'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 500))
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {

    final userTo = this.chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          
          children: <Widget>[
            CircleAvatar(
              child: Text(userTo.name.substring(0,2), style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 25,
            ),

            SizedBox(width: 20),
            
            Text(userTo.name, style: TextStyle(color: Colors.black87, fontSize: 20)),
          ],
        ),
        centerTitle: true,
        elevation: 2,
      ),

      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, i) => _messages[i],
                reverse: true,
              )
            ),

            Divider(height: 1),
            
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
            
          ],
        ),
      ),
   );
  }

  Widget _inputChat() {

    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: <Widget>[

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text){
                  if(text.trim().length > 0) {
                    _hasText = true;
                  }
                  else{
                    _hasText = false;
                  }
                  setState(() {});
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar Mensaje'
                ),
                focusNode: _focusNode,
              ),
            ),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconTheme(
                data: IconThemeData(color: Colors.blue[400]),
                child: IconButton(
                  icon: Icon(Icons.send), 
                  onPressed: (_hasText) 
                            ? () => _handleSubmit(_textController.text)
                            : null,
                  //splashRadius: 0.0,
                ),
              ),
            ),

          ],
        ),
      ),
    );

  }

  _handleSubmit(String text) {

    if (text.length == 0) return;

    print(text);
    _textController.clear();
    _focusNode.requestFocus();


    final newMessage = new ChatMessage(
      uid: authService.user.uid,
      text: text, 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 500))
    );

    newMessage.animationController.forward();
    _messages.insert(0, newMessage);


    setState(() {
      _hasText = false;
    });

    this.socketService.emit('personal-message', {
      'from'    : this.authService.user.uid,
      'to'      : this.chatService.userTo.uid,
      'message' : text
    });
    
    
  }


  @override
  void dispose() {
    // TODO: off socket
    for (ChatMessage message in _messages){
      message.animationController.dispose();
    }
    this.socketService.socket.off('personal-message');
    super.dispose();
  }
}