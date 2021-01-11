import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/models/service.dart';
import 'package:service_app/widgets/text/iconedText.dart';

class ServiceBody extends StatelessWidget {
  ServiceBody({
    Key key,
    @required this.service,
  }) : super(key: key);

  final ServicesController servicesController = Get.find();
  final Service service;

  @override
  Widget build(BuildContext context) {
    if (service.id == -1) return SizedBox();

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
                    icon: Icon(Icons.contact_phone),
                  ),
                  IconedText(
                    child: Text(
                        "${service.getShortAddress()}" +
                            ((service.floor != '0')
                                ? ", этаж " + service.floor.toString()
                                : "") +
                            ((service.intercom) ? "\nДомофон" : ""),
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                    icon: Icon(Icons.home),
                  ),
                  IconedText(
                    child: Text("${service.comment.trim()}",
                        style: TextStyle(
                          fontSize: 16.0,
                        )),
                    icon: Icon(Icons.comment),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ContactActionButton(
                  text: 'Позвонить',
                  icon: Icon(Icons.call),
                  function: () =>
                      servicesController.callMethod(context, service.phone),
                ),
                ContactActionButton(
                  text: 'Навигатор',
                  icon: Icon(Icons.navigation),
                  function: () => servicesController.openNavigator(service),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ContactActionButton extends StatelessWidget {
  const ContactActionButton(
      {@required this.text, @required this.icon, @required this.function});

  final String text;
  final Icon icon;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              icon,
              Text(text),
            ],
          ),
          onPressed: function,
        ),
      ),
    );
  }
}
