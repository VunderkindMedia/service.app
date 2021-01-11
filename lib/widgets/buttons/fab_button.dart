import 'package:flutter/material.dart';

class FloatingButton extends StatelessWidget {
  final String label;
  final String heroTag;
  final Alignment alignment;
  final Function onPressed;
  final IconData iconData;
  final bool extended;

  const FloatingButton(
      {this.label,
      this.heroTag,
      this.alignment,
      this.onPressed,
      this.iconData,
      this.extended = false});

  @override
  Widget build(BuildContext context) {
    if (!extended) {
      return Align(
        alignment: alignment,
        child: FloatingActionButton(
          onPressed: onPressed,
          heroTag: heroTag,
          tooltip: label,
          child: Icon(
            iconData,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return Align(
        alignment: alignment,
        child: FloatingActionButton.extended(
          onPressed: onPressed,
          icon: Icon(
            iconData,
            color: Colors.white,
          ),
          label: label.length > 0 ? Text(label) : SizedBox(),
          heroTag: heroTag,
        ),
      );
    }
  }
}
