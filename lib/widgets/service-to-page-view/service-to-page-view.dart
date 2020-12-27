import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServiceTOPageView extends StatelessWidget {
  final Function onTap;

  ServiceTOPageView({Key key, @required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlatButton.icon(
              onPressed: () {
                onTap();
              },
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
