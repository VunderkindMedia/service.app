import 'package:flutter/material.dart';

class IconedText extends StatelessWidget {
  final Icon icon;
  final Widget child;

  IconedText({@required this.child, this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(width: 30.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
