import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceTOPageView extends StatelessWidget {
  final String title;

  ServiceTOPageView({Key key, @required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(this.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 8),
          FlatButton.icon(
              onPressed: () {},
              color: Colors.blue,
              textColor: Colors.white,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),
              label: Text('Подобрать'))
        ],
      ),
    );
  }
}
