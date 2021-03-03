import 'package:flutter/material.dart';
import 'package:service_app/constants/app_fonts.dart';
import 'package:service_app/models/mounting.dart';
import 'package:service_app/widgets/text/iconedText.dart';
import 'package:service_app/widgets/text/contactActionButton.dart';

class MountingBody extends StatelessWidget {
  const MountingBody(
      {Key key, @required this.mounting, this.callPhone, this.openNavigator})
      : super(key: key);

  final Mounting mounting;
  final Function callPhone;
  final Function openNavigator;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(mounting.customer),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IconedText(
                    child: Text('${mounting.phone}', style: kCardTextStyle),
                    icon: Icon(Icons.contact_phone),
                  ),
                  IconedText(
                    child: Text('${mounting.getShortAddress()}',
                        style: kCardTextStyle),
                    icon: Icon(Icons.home),
                  ),
                  IconedText(
                    child: Text('${mounting.comment.trim()}',
                        style: kCardTextStyle),
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
                  function: callPhone,
                ),
                ContactActionButton(
                  text: 'Навигатор',
                  icon: Icon(Icons.navigation),
                  function: openNavigator,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
