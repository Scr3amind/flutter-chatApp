import 'package:flutter/material.dart';

showAlert(BuildContext context , String title, String subtitle) {

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(subtitle),

      actions: [
        MaterialButton(
          child: Text('Ok'),
          textColor: Colors.blue,
          onPressed: () => Navigator.pop(context),

        )
      ],
    )
  );

}