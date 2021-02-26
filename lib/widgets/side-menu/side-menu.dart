import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:service_app/constants/app_colors.dart';

import 'package:service_app/widgets/notifications_page/notification_page.dart';
import 'package:service_app/get/controllers/account_controller.dart';
import 'package:service_app/get/controllers/notifications_controller.dart';
import 'package:service_app/get/controllers/services_controller.dart';
import 'package:service_app/widgets/text/iconedText.dart';
import 'package:service_app/widgets/side-menu/services-filter.dart';

class SideMenu extends StatelessWidget {
  final AccountController accountController = Get.find();
  final ServicesController servicesController = Get.put(ServicesController());
  final NotificationsController notificationsController =
      Get.put(NotificationsController());

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
    String dtstart = DateFormat('dd.MM')
        .format(servicesController.selectedDateStart.value)
        .toString();
    String dtend = DateFormat('dd.MM')
        .format(servicesController.selectedDateEnd.value)
        .toString();

    return Drawer(
      child: Container(
        color: kMainSecondColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 6.0),
              child: Card(
                color: kMainColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        accountController.personName,
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        accountController.userRolesTitle,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
              ),
            ),
            ExpansionTile(
              title: IconedText(
                child: Text('Список заявок\n$dtstart - $dtend'),
                icon: Icon(
                  Icons.list_alt_rounded,
                  color: Colors.black,
                ),
              ),
              initiallyExpanded: true,
              children: [
                ServicesFilter(),
              ],
            ),
            ListTile(
              leading: Obx(
                () => Icon(
                  notificationsController.hasNew.value
                      ? Icons.notifications_active
                      : Icons.notifications_none,
                  color: Colors.black,
                ),
              ),
              title: Text("Уведомления"),
              onTap: () => Get.to(NotificationsPage()),
            ),
            /* ListTile(
              leading: Icon(Icons.settings),
              title: Text("Настройки"),
              onTap: () {
                Navigator.pushNamed(context, SettingsScreen.id);
              },
            ), */
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.black,
              ),
              title: Text("Выход"),
              onTap: () {
                _logoutDialog(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
