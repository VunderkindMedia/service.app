import 'package:flutter/material.dart';

class MainActionButton extends StatefulWidget {
  final String label;
  final Color color;
  final IconData icon;
  final Function onPressed;

  MainActionButton({this.label, this.color, this.icon, this.onPressed});

  @override
  _MainActionButtonState createState() => _MainActionButtonState();
}

class _MainActionButtonState extends State<MainActionButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(6.0)),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(widget.icon),
                SizedBox(width: 4.0),
                Text(widget.label)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
