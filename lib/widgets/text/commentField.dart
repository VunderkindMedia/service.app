import 'package:flutter/material.dart';

class CommentField extends StatelessWidget {
  final TextEditingController controller;

  CommentField({this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('Коментарий',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: controller,
                  maxLines: 4,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Введите комментарий...'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
