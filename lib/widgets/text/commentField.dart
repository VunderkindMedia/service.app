import 'package:flutter/material.dart';

class CommentField extends StatelessWidget {
  final TextEditingController controller;

  CommentField({this.controller});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: TextField(
        textAlign: TextAlign.left,
        controller: controller,
        maxLines: 4,
        decoration:
            InputDecoration.collapsed(hintText: 'Введите комментарий...'),
      ),
    );
  }
}
