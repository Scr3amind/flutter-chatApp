import 'package:chat_app/widgets/chat_message.dart';
import 'package:flutter/material.dart';


class ChatPage extends StatefulWidget {

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          
          children: <Widget>[
            CircleAvatar(
              child: Text('IC', style: TextStyle(fontSize: 12)),
              backgroundColor: Colors.blue[100],
              maxRadius: 25,
            ),

            SizedBox(width: 20),
            
            Text('Isaac Cruz', style: TextStyle(color: Colors.black87, fontSize: 20)),
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
      uid: '123', 
      text: text, 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 500))
    );

    newMessage.animationController.forward();
    _messages.insert(0, newMessage);


    setState(() {
      _hasText = false;
    });
    
    
  }


  @override
  void dispose() {
    // TODO: off socket
    for (ChatMessage message in _messages){
      message.animationController.dispose();
    }
    super.dispose();
  }
}