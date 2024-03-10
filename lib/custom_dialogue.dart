import 'package:flutter/material.dart';

class CustomDialogue extends StatelessWidget {
  final title;
  final content;
  final VoidCallback callback;
  final actionText;

  CustomDialogue(this.title, this.content, this.callback,
      [this.actionText = "Reset"]);

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: new Text(title),
      content: new Text(content),
      actions: <Widget>[
        new TextButton(
          onPressed: callback,
          child: new Text(actionText),
          style: TextButton.styleFrom(foregroundColor: Colors.black),
        )
      ],
    );
  }
}
