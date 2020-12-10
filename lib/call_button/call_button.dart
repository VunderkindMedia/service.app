import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneButton extends StatelessWidget {
  final String phone;

  PhoneButton({Key key, @required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launch('tel://${this.phone}');
        print('Call some phone');
      },
      child: Icon(Icons.phone, color: Colors.green, size: 36.0),
    );
  }
}
