import 'package:flutter/material.dart';

class CommentField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;

  CommentField({this.controller, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: TextField(
        focusNode: focusNode,
        textAlign: TextAlign.left,
        controller: controller,
        maxLines: 4,
        decoration:
            InputDecoration.collapsed(hintText: 'Введите комментарий...'),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
