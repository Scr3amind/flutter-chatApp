import 'package:flutter/material.dart';

class Labels extends StatelessWidget {

  final String primaryText;
  final String secondaryText;
  final String toRoute;

  const Labels({
    Key key, 
    @required this.toRoute, 
    @required this.primaryText, 
    @required this.secondaryText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [

          Text(this.primaryText, style: TextStyle(color: Colors.black87, fontSize: 15, fontWeight: FontWeight.w300)),
          SizedBox(height: 10),
          
          GestureDetector(
            child: Text(
              this.secondaryText, 
              style: TextStyle(color: Colors.blue[600], fontSize: 18, fontWeight: FontWeight.bold)
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, this.toRoute);
            },
          )


        ],
      ),
    );
  }
}