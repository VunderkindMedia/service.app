import 'package:flutter/material.dart';

class ContactActionButton extends StatelessWidget {
  const ContactActionButton(
      {@required this.text, @required this.icon, @required this.function});

  final String text;
  final Icon icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              icon,
              Text(text),
            ],
          ),
          onPressed: function,
        ),
      ),
    );
  }
}
