import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  
  final String text;
  final Function callback;

  const BlueButton({
    @required this.text, 
    @required this.callback
  });

  
  
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      elevation: 2,
      highlightElevation: 5,
      color: Colors.blue,
      shape: StadiumBorder(),
      onPressed: this.callback,
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(this.text, style: TextStyle(color: Colors.white, fontSize: 17)),
        ),
      ),
    );
  }
}
