import 'package:flutter/material.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/widgets/text/iconedText.dart';

class ServiceBody extends StatelessWidget {
  const ServiceBody({
    Key key,
    @required this.service,
  }) : super(key: key);

  final Service service;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(service.customer),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  IconedText(
                    child: Text("${service.phone}",
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                    icon: Icon(Icons.phone),
                  ),
                  IconedText(
                    child: Text(
                        "${service.customerAddress}" +
                            ((service.floor != '0') ? ", этаж " + service.floor.toString() : "") +
                            ((service.intercom) ? "\nДомофон" : ""),
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                    icon: Icon(Icons.home),
                  ),
                  IconedText(
                    child: Text("${service.comment}",
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                    icon: Icon(Icons.comment),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
