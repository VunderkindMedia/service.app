import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/controllers/services_controller.dart';

class SideMenu extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController());
  final ServicesController servicesController = Get.put(ServicesController());

  void _logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Выход"),
            content:
                Text("Вы действительно хотите выйти данной из учетной записи?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: accountController.logout, child: Text("Выйти")),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Отмена")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
              child: Text(
            servicesController.getName(),
            style: TextStyle(color: Colors.white, fontSize: 15),
          )),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Список заявок"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          /* ListTile(
            leading: Icon(Icons.settings),
            title: Text("Настройки"),
            onTap: () {
              Navigator.pushNamed(context, SettingsScreen.id);
            },
          ), */
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Выход"),
            onTap: () {
              _logoutDialog(context);
            },
          )
        ],
      ),
    );
  }
}
