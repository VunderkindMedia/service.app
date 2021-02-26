import 'package:flutter/material.dart';
import 'package:service_app/constants/app_colors.dart';

class FloatingButton extends StatelessWidget {
  final String label;
  final String heroTag;
  final Alignment alignment;
  final Function onPressed;
  final IconData iconData;
  final Color color;
  final bool isSecondary;
  final bool extended;

  const FloatingButton(
      {this.label,
      this.heroTag,
      this.alignment,
      this.onPressed,
      this.iconData,
      this.color = kMainSecondColor,
      this.isSecondary = false,
      this.extended = false});

  @override
  Widget build(BuildContext context) {
    if (!extended) {
      return Align(
        alignment: alignment,
        child: FloatingActionButton(
          elevation: isSecondary ? 0.0 : 2.0,
          backgroundColor: isSecondary ? Colors.white.withOpacity(0.8) : color,
          onPressed: onPressed,
          heroTag: heroTag,
          tooltip: label,
          child: Icon(
            iconData,
            color: Colors.black,
          ),
        ),
      );
    } else {
      return Align(
        alignment: alignment,
        child: FloatingActionButton.extended(
          elevation: isSecondary ? 0.0 : 2.0,
          backgroundColor: isSecondary ? Colors.white.withOpacity(0.8) : color,
          foregroundColor: Colors.black,
          onPressed: onPressed,
          icon: Icon(
            iconData,
            color: Colors.black,
          ),
          label: label.length > 0 ? Text(label) : SizedBox(),
          heroTag: heroTag,
        ),
      );
    }
  }
}
