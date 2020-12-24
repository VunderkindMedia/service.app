import 'package:flutter/material.dart';

class ColoredText extends StatelessWidget {
  final Widget child;
  final Color color;

  ColoredText(this.child, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
          child: Center(child: child),
        ));
  }
}