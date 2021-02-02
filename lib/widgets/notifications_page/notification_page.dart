import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:service_app/get/controllers/notifications_controller.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final NotificationsController notificationsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Уведомления'),
        actions: [
          IconButton(
              icon: Icon(Icons.playlist_add_check),
              onPressed: () async {
                notificationsController.notifications
                    .where((value) => value.isNew)
                    .forEach((push) {
                  notificationsController.markIsNew(push, false);
                });
              })
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: notificationsController.notifications.length,
              itemBuilder: (context, i) {
                var notification = notificationsController.notifications[i];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: Row(
                        children: <Widget>[
                          Text(notification.title),
                          Spacer(),
                          Text(
                            DateFormat('dd.MM HH:mm')
                                .format(notification.createdAt.toLocal())
                                .toString(),
                            style: TextStyle(
                                fontSize: 12.0, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          notification.body,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      trailing:
                          notification.isNew ? Icon(Icons.new_releases) : null,
                      onTap: () async {
                        notificationsController.openNotification(notification);
                      },
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
