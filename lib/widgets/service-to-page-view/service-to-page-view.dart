import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceTOPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
