import 'package:flutter/material.dart';

class CommentField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget title;

  CommentField({this.controller, this.title, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: title,
        subtitle: TextField(
          focusNode: focusNode,
          textAlign: TextAlign.left,
          controller: controller,
          maxLines: 4,
          decoration:
              InputDecoration.collapsed(hintText: 'Введите комментарий...'),
          keyboardType: TextInputType.text,
        ),
      ),
    );
  }
}
